/// Profile entities.
library;

import 'package:flutter/foundation.dart';

/// User profile entity.
@immutable
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.phone,
    this.bio,
    this.shahadaDate,
    this.learningGoals = const [],
    this.stats,
    this.createdAt,
    this.updatedAt,
  });

  /// User ID.
  final String id;

  /// Email address.
  final String email;

  /// Display name.
  final String? name;

  /// Avatar URL.
  final String? avatarUrl;

  /// Phone number.
  final String? phone;

  /// Bio/about.
  final String? bio;

  /// Shahada date.
  final DateTime? shahadaDate;

  /// Learning goals.
  final List<String> learningGoals;

  /// User stats.
  final ProfileStatsEntity? stats;

  /// Account creation date.
  final DateTime? createdAt;

  /// Last update date.
  final DateTime? updatedAt;

  /// Get display name (fallback to email).
  String get displayName => name ?? email.split('@').first;

  /// Days since shahada.
  int? get daysSinceShahada {
    if (shahadaDate == null) return null;
    return DateTime.now().difference(shahadaDate!).inDays;
  }

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phone,
    String? bio,
    DateTime? shahadaDate,
    List<String>? learningGoals,
    ProfileStatsEntity? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      shahadaDate: shahadaDate ?? this.shahadaDate,
      learningGoals: learningGoals ?? this.learningGoals,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Profile statistics.
@immutable
class ProfileStatsEntity {
  const ProfileStatsEntity({
    this.lessonsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalReadingTime = 0,
    this.savedItems = 0,
    this.journeyProgress = 0,
  });

  /// Number of lessons completed.
  final int lessonsCompleted;

  /// Current streak (consecutive days).
  final int currentStreak;

  /// Longest streak ever.
  final int longestStreak;

  /// Total reading time in minutes.
  final int totalReadingTime;

  /// Number of saved items.
  final int savedItems;

  /// Journey progress percentage.
  final double journeyProgress;
}

/// Update profile request.
@immutable
class UpdateProfileRequest {
  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.bio,
    this.shahadaDate,
    this.learningGoals,
  });

  final String? name;
  final String? phone;
  final String? bio;
  final DateTime? shahadaDate;
  final List<String>? learningGoals;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (shahadaDate != null) 'shahada_date': shahadaDate!.toIso8601String(),
      if (learningGoals != null) 'learning_goals': learningGoals,
    };
  }
}
