/// Authentication state provider.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/diagnostics/prod_safety_guard.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/app/router.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/minions/social_auth_service.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_app/features/onboarding/providers/onboarding_providers.dart';

/// Auth state provider.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref: ref,
  );
});

/// Current user provider (convenience).
final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});

/// Is authenticated provider (convenience).
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Is guest mode provider (convenience).
final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isGuest;
});

/// Auth state notifier.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required Ref ref,
  })  : _ref = ref,
        super(const AuthState.initial());

  final Ref _ref;

  AuthRepository get _authRepository => _ref.read(authRepositoryProvider);
  TokenStorage get _tokenStorage => _ref.read(tokenStorageProvider);
  OnboardingRepository get _onboardingRepository => _ref.read(onboardingRepositoryProvider);
  SocialAuthService get _socialAuthService => _ref.read(socialAuthServiceProvider);
  ProdSafetyGuard get _prodSafetyGuard => _ref.read(prodSafetyGuardProvider);
  GoRouter get _router => _ref.read(routerProvider);

  /// Initialize auth state on app start: read token -> GET /me -> GET /me/onboarding.
  Future<void> initialize() async {
    try {
      // Check if in guest mode
      final isGuest = await _tokenStorage.isGuestMode();
      if (isGuest) {
        state = const AuthState.guest();
        return;
      }

      // Check if we have a stored token
      final token = await _tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        state = const AuthState.unauthenticated();
        return;
      }

      // Validate token and load user (401 throws UnauthorizedException)
      state = const AuthState.loading();
      final user = await _authRepository.getCurrentUser();

      // Fetch full onboarding state for routing and prefill
      OnboardingEntity? onboarding;
      try {
        onboarding = await _onboardingRepository.getOnboarding();
      } catch (e) {
        if (kDebugMode) {
          print('[Auth] Onboarding fetch error (continuing with user): $e');
        }
        // Offline or error: still set user; router can use user.onboardingCompleted/currentStep
      }

      state = AuthState.authenticated(user, onboarding: onboarding);
    } on UnauthorizedException {
      // Token expired or invalid (401)
      await _tokenStorage.clearAll();
      state = const AuthState.unauthenticated();
    } catch (e) {
      if (kDebugMode) {
        print('[Auth] Initialize error: $e');
      }
      final hasToken = await _tokenStorage.getAccessToken() != null;
      if (hasToken) {
        // Token exists but /me failed (e.g. offline) - keep initial to show loading/retry
        state = const AuthState.initial();
      } else {
        state = const AuthState.unauthenticated();
      }
    }
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _prodSafetyGuard.ensureSafety(); // Safety Check
    } on ProdSafetyException catch (e) {
      state = AuthState.error(e.message);
      return;
    }

    state = const AuthState.loading();

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      final user = response.user.toEntity();
      final onboarding = await _fetchOnboardingSafe();
      state = AuthState.authenticated(user, onboarding: onboarding);
    } on EmailVerificationRequiredException catch (e) {
      state = const AuthState.unauthenticated();
      _router.pushNamed('verify-email', queryParameters: {'email': e.email}); // ignore: unawaited_futures
    } on ValidationException catch (e) {
      state = AuthState.error(e.allErrors);
      rethrow;
    } on ApiException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error(e.toString());
      rethrow;
    }
  }

  /// Register a new user.
  /// Returns [RegisterResult]. Caller should navigate to OTP screen when [RegisterResultNeedsOtp].
  Future<RegisterResult> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    String? gender,
    DateTime? birthDate,
  }) async {
    try {
      _prodSafetyGuard.ensureSafety(); // Safety Check
    } on ProdSafetyException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    }

    state = const AuthState.loading();

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        name: name,
        gender: gender,
        birthDate: birthDate,
      );
      if (result is RegisterResultNeedsOtp) {
        state = const AuthState.unauthenticated();
        return result;
      }
      if (result is RegisterResultAuthed) {
        final user = result.authResponse.user.toEntity();
        final onboarding = await _fetchOnboardingSafe();
        state = AuthState.authenticated(user, onboarding: onboarding);
        return result;
      }
      state = const AuthState.unauthenticated();
      throw UnknownException(message: 'Unexpected register result');
    } on ConflictException catch (_) {
      state = const AuthState.error('This email is already registered. Please login.');
      rethrow;
    } on ValidationException catch (e) {
      state = AuthState.error(e.allErrors);
      rethrow;
    } on ApiException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error(e.toString());
      rethrow;
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      state = const AuthState.unauthenticated();
      _router.go('/');
    }
  }

  /// Enter guest mode.
  Future<void> enterGuestMode() async {
    await _authRepository.enterGuestMode();
    state = const AuthState.guest();
  }

  /// Exit guest mode.
  Future<void> exitGuestMode() async {
    await _authRepository.exitGuestMode();
    state = const AuthState.unauthenticated();
  }

  /// Handle 401 unauthorized globally.
  Future<void> handleUnauthorized() async {
    // Try to refresh token first
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await _authRepository.refreshToken();
        state = AuthState.authenticated(response.user.toEntity());
        return;
      }
    } catch (_) {
      // Refresh failed, proceed to logout
    }

    // Clear tokens and redirect to welcome
    await _tokenStorage.clearAll();
    state = const AuthState.unauthenticated();
    _router.go('/');
  }

  /// Update user data (after profile edit, etc.).
  void updateUser(UserEntity user) {
    if (state.isAuthenticated) {
      state = AuthState.authenticated(user);
    }
  }

  /// Refresh current user from server.
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authRepository.getCurrentUser();
      final onboarding = await _fetchOnboardingSafe();
      state = AuthState.authenticated(user, onboarding: onboarding);
    } catch (e) {
      if (kDebugMode) {
        print('[Auth] Refresh user error: $e');
      }
    }
  }

  /// Fetch onboarding and update state (e.g. after PUT from onboarding screens).
  Future<void> refreshOnboarding() async {
    if (!state.isAuthenticated || state.user == null) return;
    try {
      final onboarding = await _onboardingRepository.getOnboarding();
      state = state.copyWith(onboarding: onboarding);
    } catch (e) {
      if (kDebugMode) {
        print('[Auth] Refresh onboarding error: $e');
      }
    }
  }

  Future<OnboardingEntity?> _fetchOnboardingSafe() async {
    try {
      return await _onboardingRepository.getOnboarding();
    } catch (_) {
      return null;
    }
  }

  /// Social login.
  Future<void> socialLogin({
    required String provider,
  }) async {
    try {
      _prodSafetyGuard.ensureSafety(); // Safety Check
    } on ProdSafetyException catch (e) {
      state = AuthState.error(e.message);
      return;
    }

    state = const AuthState.loading();

    try {
      String? token;
      
      // 1. Get token from native SDK
      switch (provider.toLowerCase()) {
        case 'google':
          token = await _socialAuthService.signInWithGoogle();
          break;
        case 'apple':
          token = await _socialAuthService.signInWithApple();
          break;
        case 'facebook':
          token = await _socialAuthService.signInWithFacebook();
          break;
      }

      if (token == null) {
        // User canceled
        state = const AuthState.unauthenticated();
        return;
      }

      // 2. Send token to backend
      final response = await _authRepository.socialLogin(
        provider: provider.toLowerCase(),
        token: token,
      );
      
      final user = response.user.toEntity();
      final onboarding = await _fetchOnboardingSafe();
      state = AuthState.authenticated(user, onboarding: onboarding);
      _router.go('/home');
    } on EmailVerificationRequiredException catch (e) {
      state = const AuthState.unauthenticated();
      _router.pushNamed('verify-email', queryParameters: {'email': e.email}); // ignore: unawaited_futures
    } on SocialAuthException catch (e) {
        state = AuthState.error(e.message);
    } on ApiException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
