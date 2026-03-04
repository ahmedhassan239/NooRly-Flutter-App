/// Auth repository interface.
library;

import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';

/// Authentication repository interface.
abstract class AuthRepository {
  /// Login with email and password.
  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  /// Register a new user.
  /// Returns [RegisterResultNeedsOtp] when OTP is required, [RegisterResultAuthed] when token is returned.
  Future<RegisterResult> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    String? gender,
    DateTime? birthDate,
  });

  /// Logout the current user.
  Future<void> logout();

  /// Get the current authenticated user.
  Future<UserEntity> getCurrentUser();

  /// Refresh the access token.
  Future<AuthResponse> refreshToken();

  /// Login with social provider.
  Future<AuthResponse> socialLogin({
    required String provider,
    required String token,
  });

  /// Request password reset.
  Future<void> forgotPassword({required String email});

  /// Reset password with token.
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });

  /// Check if user is authenticated.
  Future<bool> isAuthenticated();

  /// Check if user is in guest mode.
  Future<bool> isGuestMode();

  /// Enter guest mode.
  Future<void> enterGuestMode();

  /// Exit guest mode.
  Future<void> exitGuestMode();

  /// Send email OTP for verification.
  /// Returns success message or throws exception.
  Future<void> sendEmailOtp({required String email});

  /// Verify email OTP.
  /// Returns AuthResponse with token on success.
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
  });
}
