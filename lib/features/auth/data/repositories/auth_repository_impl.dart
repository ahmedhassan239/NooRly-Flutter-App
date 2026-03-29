/// Auth repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(email: email, password: password);

    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.login,
      data: request.toJson(),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final data = response.data!;
    
    // Check for email verification requirement
    if (data['needs_email_verification'] == true) {
      throw EmailVerificationRequiredException(
        email: (data['email'] as String?) ?? email,
      );
    }

    final authResponse = AuthResponse.fromJson(data);

    // Store tokens
    await _tokenStorage.saveAuthData(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      expiry: authResponse.expiryDateTime,
      userId: authResponse.user.id,
    );

    return authResponse;
  }

  @override
  Future<RegisterResult> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    String? gender,
    DateTime? birthDate,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      name: name,
      gender: gender,
      birthDate: birthDate,
    );

    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.register,
      data: request.toJson(),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final data = response.data!;
    // Support both formats: data at root (data["needs_email_verification"]) or nested (data["data"]["needs_email_verification"])
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
    final needsEmailVerification = inner['needs_email_verification'] == true;
    final responseEmail = (inner['email'] as String?)?.trim() ?? (data['email'] as String?)?.trim() ?? email;

    if (needsEmailVerification) {
      return RegisterResultNeedsOtp(responseEmail);
    }

    // Token present (legacy path)
    final authResponse = AuthResponse.fromJson(data);
    if (authResponse.accessToken.isEmpty) {
      throw UnknownException(message: response.message);
    }
    await _tokenStorage.saveAuthData(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      expiry: authResponse.expiryDateTime,
      userId: authResponse.user.id,
    );
    return RegisterResultAuthed(authResponse);
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout endpoint to invalidate token on server
      await _apiClient.post<void>(AuthEndpoints.logout);
    } catch (_) {
      // Ignore errors - we'll clear local tokens anyway
    } finally {
      // Always clear local tokens
      await _tokenStorage.clearAll();
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      AuthEndpoints.me,
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    return UserModel.fromJson(response.data!).toEntity();
  }

  @override
  Future<AuthResponse> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const UnauthorizedException(
        message: 'No refresh token available',
      );
    }

    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.refresh,
      data: {'refresh_token': refreshToken},
    );

    if (!response.status || response.data == null) {
      // Clear tokens if refresh fails
      await _tokenStorage.clearAll();
      throw const UnauthorizedException(
        message: 'Session expired. Please login again.',
      );
    }

    final authResponse = AuthResponse.fromJson(response.data!);

    // Store new tokens
    await _tokenStorage.saveAuthData(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      expiry: authResponse.expiryDateTime,
      userId: authResponse.user.id,
    );

    return authResponse;
  }

  @override
  Future<AuthResponse> socialLogin({
    required String provider,
    required String token,
  }) async {
    final request = SocialLoginRequest(provider: provider, token: token);

    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.socialLogin,
      data: request.toJson(),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final data = response.data!;

    // Check for email verification requirement
    if (data['needs_email_verification'] == true) {
      throw EmailVerificationRequiredException(
        email: (data['email'] as String?) ?? '',
      );
    }

    final authResponse = AuthResponse.fromJson(data);

    // Store tokens
    await _tokenStorage.saveAuthData(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      expiry: authResponse.expiryDateTime,
      userId: authResponse.user.id,
    );

    return authResponse;
  }

  @override
  Future<void> requestPasswordResetOtp({required String email}) async {
    final response = await _apiClient.post<void>(
      AuthEndpoints.forgotPasswordRequestOtp,
      data: {'email': email},
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<String> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.forgotPasswordVerifyOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final resetToken = (response.data!['reset_token'] as String?)?.trim() ?? '';
    if (resetToken.isEmpty) {
      throw UnknownException(message: 'Invalid reset session response.');
    }

    return resetToken;
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiClient.post<void>(
      AuthEndpoints.forgotPasswordReset,
      data: {
        'email': email,
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _tokenStorage.isAuthenticated();
  }

  @override
  Future<bool> isGuestMode() async {
    return _tokenStorage.isGuestMode();
  }

  @override
  Future<void> enterGuestMode() async {
    await _tokenStorage.setGuestMode(true);
  }

  @override
  Future<void> exitGuestMode() async {
    await _tokenStorage.setGuestMode(false);
  }

  @override
  Future<void> sendEmailOtp({required String email}) async {
    final response = await _apiClient.post<void>(
      AuthEndpoints.sendEmailOtp,
      data: {'email': email},
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }
  }

  @override
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      AuthEndpoints.verifyEmailOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final authResponse = AuthResponse.fromJson(response.data!);

    // Store tokens
    await _tokenStorage.saveAuthData(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      expiry: authResponse.expiryDateTime,
      userId: authResponse.user.id,
    );

    return authResponse;
  }
}
