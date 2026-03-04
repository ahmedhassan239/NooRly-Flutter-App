/// User entity representing the authenticated user.
library;

import 'package:flutter/foundation.dart';

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';

/// User entity - domain layer representation.
@immutable
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.phone,
    this.gender,
    this.birthDate,
    this.locale,
    this.shahadaDate,
    this.learningGoals,
    this.isEmailVerified = false,
    this.onboardingCompleted = false,
    this.onboardingCurrentStep,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique user identifier.
  final String id;

  /// User's email address.
  final String email;

  /// User's display name.
  final String? name;

  /// URL to user's avatar image.
  final String? avatarUrl;

  /// User's phone number.
  final String? phone;

  /// Gender (male, female, other, unknown).
  final String? gender;

  /// Birth date.
  final DateTime? birthDate;

  /// Locale (e.g. en, ar).
  final String? locale;

  /// Date of shahada (for new Muslims).
  final DateTime? shahadaDate;

  /// Selected learning goals.
  final List<String>? learningGoals;

  /// Whether email is verified.
  final bool isEmailVerified;

  /// Whether onboarding is completed (from GET /me onboarding summary).
  final bool onboardingCompleted;

  /// Current onboarding step (shahada_date, goals, summary, done).
  final String? onboardingCurrentStep;

  /// Account creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Get display name (fallback to email).
  String get displayName => name ?? email.split('@').first;

  /// Check if user has completed onboarding.
  bool get hasCompletedOnboarding => onboardingCompleted;

  /// Copy with new values.
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phone,
    String? gender,
    DateTime? birthDate,
    String? locale,
    DateTime? shahadaDate,
    List<String>? learningGoals,
    bool? isEmailVerified,
    bool? onboardingCompleted,
    String? onboardingCurrentStep,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      locale: locale ?? this.locale,
      shahadaDate: shahadaDate ?? this.shahadaDate,
      learningGoals: learningGoals ?? this.learningGoals,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingCurrentStep: onboardingCurrentStep ?? this.onboardingCurrentStep,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email, name: $name)';
}

/// Authentication state.
enum AuthStatus {
  /// Initial state, checking auth status.
  initial,

  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,

  /// User is in guest mode (read-only).
  guest,

  /// Authentication is loading.
  loading,
}

/// Authentication state with user data.
@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.onboarding,
    this.errorMessage,
  });

  /// Initial state.
  const AuthState.initial() : this();

  /// Authenticated state with user and optional full onboarding snapshot.
  const AuthState.authenticated(UserEntity user, {OnboardingEntity? onboarding})
      : this(status: AuthStatus.authenticated, user: user, onboarding: onboarding);

  /// Unauthenticated state.
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  /// Guest mode state.
  const AuthState.guest() : this(status: AuthStatus.guest);

  /// Loading state.
  const AuthState.loading() : this(status: AuthStatus.loading);

  /// Error state.
  const AuthState.error(String message)
      : this(status: AuthStatus.unauthenticated, errorMessage: message);

  /// Current authentication status.
  final AuthStatus status;

  /// Current user (if authenticated).
  final UserEntity? user;

  /// Full onboarding state (after GET /me/onboarding). Used for routing and prefill.
  final OnboardingEntity? onboarding;

  /// Error message (e.g. when AuthState.error(message) is used).
  final String? errorMessage;

  /// Whether onboarding is completed (from user summary or full onboarding).
  bool get onboardingCompleted =>
      user?.onboardingCompleted == true ||
      (onboarding != null && onboarding!.completed);

  /// Check if user is authenticated.
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if user is guest.
  bool get isGuest => status == AuthStatus.guest;

  /// Check if loading.
  bool get isLoading => status == AuthStatus.loading;

  /// Check if user can access content (authenticated or guest).
  bool get canAccessContent =>
      status == AuthStatus.authenticated || status == AuthStatus.guest;

  /// Copy with new values.
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    OnboardingEntity? onboarding,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      onboarding: onboarding ?? this.onboarding,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() => 'AuthState(status: $status, user: $user)';
}
