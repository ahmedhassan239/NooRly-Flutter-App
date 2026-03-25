/// User model for API serialization.
library;

import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';

/// User model - data layer representation (GET /me response).
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.phone,
    super.gender,
    super.birthDate,
    super.locale,
    super.shahadaDate,
    super.learningGoals,
    super.isEmailVerified,
    super.onboardingCompleted,
    super.onboardingCurrentStep,
    super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON (GET /me or auth response user).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final onboarding = json['onboarding'] as Map<String, dynamic>?;
    final profile = json['profile'] as Map<String, dynamic>?;
    final rootAvatar =
        json['avatar_url'] as String? ?? json['avatar'] as String?;
    final nestedAvatar = profile != null
        ? (profile['avatar_url'] as String? ?? profile['avatar'] as String?)
        : null;
    final avatarUrl = (rootAvatar != null && rootAvatar.trim().isNotEmpty)
        ? rootAvatar
        : nestedAvatar;

    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      avatarUrl: avatarUrl,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      locale: json['locale'] as String?,
      shahadaDate: json['shahada_date'] != null
          ? DateTime.tryParse(json['shahada_date'] as String)
          : null,
      learningGoals: json['learning_goals'] != null
          ? List<String>.from(json['learning_goals'] as List)
          : null,
      isEmailVerified: json['email_verified'] as bool? ??
          json['is_email_verified'] as bool? ??
          false,
      onboardingCompleted: onboarding?['completed'] as bool? ?? false,
      onboardingCurrentStep: onboarding?['current_step'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'phone': phone,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'locale': locale,
      'shahada_date': shahadaDate?.toIso8601String(),
      'learning_goals': learningGoals,
      'email_verified': isEmailVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert to entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      phone: phone,
      gender: gender,
      birthDate: birthDate,
      locale: locale,
      shahadaDate: shahadaDate,
      learningGoals: learningGoals,
      isEmailVerified: isEmailVerified,
      onboardingCompleted: onboardingCompleted,
      onboardingCurrentStep: onboardingCurrentStep,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Login request model.
class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

/// Register request model.
class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.name,
    this.gender,
    this.birthDate,
  });

  final String email;
  final String password;
  final String passwordConfirmation;
  final String? name;
  /// male or female
  final String? gender;
  final DateTime? birthDate;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (name != null && name!.isNotEmpty) 'name': name,
        if (gender != null && gender!.isNotEmpty) 'gender': gender,
        if (birthDate != null) 'birth_date': _formatBirthDate(birthDate!),
      };

  static String _formatBirthDate(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

/// Result of register API: either OTP required or fully authenticated.
sealed class RegisterResult {
  const RegisterResult();
}

/// Register succeeded but email must be verified; navigate to OTP screen.
class RegisterResultNeedsOtp extends RegisterResult {
  const RegisterResultNeedsOtp(this.email);
  final String email;
}

/// Register returned token; user is authenticated.
class RegisterResultAuthed extends RegisterResult {
  const RegisterResultAuthed(this.authResponse);
  final AuthResponse authResponse;
}

/// Auth response model (login/register response).
class AuthResponse {
  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType = 'Bearer',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested user data
    final userData = json['user'] as Map<String, dynamic>? ?? json;

    return AuthResponse(
      user: UserModel.fromJson(userData),
      accessToken: json['access_token'] as String? ??
          json['token'] as String? ??
          '',
      refreshToken: json['refresh_token'] as String?,
      expiresIn: json['expires_in'] as int?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String tokenType;

  /// Calculate token expiry datetime.
  DateTime? get expiryDateTime {
    if (expiresIn == null) return null;
    return DateTime.now().add(Duration(seconds: expiresIn!));
  }
}

/// Social login request model.
class SocialLoginRequest {
  const SocialLoginRequest({
    required this.provider,
    required this.token,
  });

  /// Provider name: 'google', 'apple', 'facebook'
  final String provider;

  /// OAuth token from the provider.
  final String token;

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'token': token,
      };
}
