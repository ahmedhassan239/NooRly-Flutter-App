/// Authentication state provider.
library;

import 'dart:async';

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
  /// Never leaves app in [AuthState.initial] on failure; sets error so UI can show retry.
  Future<void> initialize() async {
    try {
      // Show loading immediately when retrying from error (so spinner replaces error screen)
      if (state.errorMessage != null) {
        state = const AuthState.loading();
      }

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

      // Timeout so release never hangs indefinitely (e.g. no network)
      const initTimeout = Duration(seconds: 20);
      final user = await _authRepository.getCurrentUser().timeout(
            initTimeout,
            onTimeout: () => throw TimeoutException(),
          );

      // Fetch full onboarding state for routing and prefill
      OnboardingEntity? onboarding;
      try {
        onboarding = await _onboardingRepository.getOnboarding().timeout(
          const Duration(seconds: 10),
        );
      } catch (e) {
        _logSafe('[Auth] Onboarding fetch error (continuing with user)');
        // Offline or error: still set user; router can use user.onboardingCompleted/currentStep
      }

      state = AuthState.authenticated(user, onboarding: onboarding);
    } on UnauthorizedException {
      // Token is definitely invalid → clear and show welcome screen.
      await _tokenStorage.clearAll();
      state = const AuthState.unauthenticated();

    } on ServerException catch (e) {
      // Backend returned 5xx while verifying the stored token.
      // Common backend bug: /me returns 500 instead of 401 for invalid tokens.
      // Do NOT show "Connection problem" — the network is fine. Let the user
      // log in again. We do NOT clear the token so a temporary server outage
      // can recover on the next launch.
      _logSafe('[Auth] Initialize: 5xx from /me (status ${e.statusCode}) → unauthenticated');
      state = const AuthState.unauthenticated();

    } on NetworkException catch (e) {
      // Genuine connectivity failure (DNS, socket, no internet).
      // "Connection problem" heading is accurate here.
      _logSafe('[Auth] Initialize: network error — ${e.message}');
      state = AuthState.error('Connection failed. Check your network and try again.');

    } on TimeoutException {
      // Request timed out — still a connectivity / server-speed issue.
      _logSafe('[Auth] Initialize: timeout');
      state = AuthState.error('Connection timed out. Check your network and try again.');

    } on ApiException catch (e) {
      // Any OTHER API error (403, 404, 422, etc.) during auth init is unexpected.
      // Go unauthenticated rather than showing a misleading "Connection problem".
      // The user can log in again; the error is logged above by LoggingInterceptor.
      _logSafe('[Auth] Initialize: unexpected API error ${e.runtimeType} (${e.statusCode}) → unauthenticated');
      state = const AuthState.unauthenticated();

    } catch (e, st) {
      // Non-ApiException (e.g. JSON parse error, null deref) — truly unexpected.
      _logSafe('[Auth] Initialize: unexpected error ${e.runtimeType}');
      if (kDebugMode) print('[Auth] Initialize stack: $st');
      final message = _safeErrorMessage(e);
      state = AuthState.error(message);
    }
  }

  /// Log without leaking tokens or sensitive data.
  void _logSafe(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Map exception to a user-facing message (no tokens or internal details).
  ///
  /// Checks by exception type first (precise), then falls back to string
  /// heuristics for exceptions we don't control (e.g. platform errors).
  String _safeErrorMessage(Object e) {
    // Type-based matching — most accurate
    if (e is NetworkException)  return 'Connection failed. Check your network and try again.';
    if (e is TimeoutException)  return 'Connection timed out. Please try again.';
    if (e is ServerException)   return 'Server error. Please try again later.';
    if (e is ApiException)      return e.message; // use server-provided message

    // String heuristics for platform / dart:io exceptions
    final s = e.toString().toLowerCase();
    if (s.contains('socket') || s.contains('connection') || s.contains('network')) {
      return 'Connection failed. Check your network and try again.';
    }
    if (s.contains('timeout') || s.contains('timed out')) {
      return 'Connection timed out. Please try again.';
    }
    if (s.contains('failed host lookup') || s.contains('name or service not known')) {
      return 'Cannot reach server. Check your network.';
    }
    return 'Something went wrong. Please try again.';
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
      state = AuthState.authenticated(user, onboarding: state.onboarding);
    }
  }

  /// Refresh current user from server.
  ///
  /// When [avatarUrlOverride] is non-empty, it is applied after GET [/me] so a
  /// just-uploaded avatar cannot be overwritten by a stale or mis-mapped response.
  Future<void> refreshUser({String? avatarUrlOverride}) async {
    if (!state.isAuthenticated) return;

    try {
      var user = await _authRepository.getCurrentUser();

      if (kDebugMode) {
        debugPrint('[Auth] refreshUser GET /me avatarUrl: ${user.avatarUrl}');
      }

      final override = avatarUrlOverride?.trim();
      if (override != null && override.isNotEmpty) {
        final server = user.avatarUrl?.trim() ?? '';
        if (kDebugMode && server != override) {
          debugPrint(
            '[Auth] refreshUser avatarUrlOverride: server="$server" -> keeping upload="$override"',
          );
        }
        user = user.copyWith(avatarUrl: override);
      }

      final onboarding = await _fetchOnboardingSafe();
      state = AuthState.authenticated(user, onboarding: onboarding);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Auth] Refresh user error: $e');
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
