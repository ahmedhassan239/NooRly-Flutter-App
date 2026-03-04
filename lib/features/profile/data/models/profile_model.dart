/// Profile models for API serialization.
library;

import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';

/// Profile model.
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.phone,
    super.bio,
    super.shahadaDate,
    super.learningGoals,
    super.stats,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatar'] as String?,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      shahadaDate: json['shahada_date'] != null
          ? DateTime.tryParse(json['shahada_date'] as String)
          : null,
      learningGoals: (json['learning_goals'] as List<dynamic>?)?.cast<String>() ?? [],
      stats: json['stats'] != null
          ? ProfileStatsModel.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'phone': phone,
      'bio': bio,
      'shahada_date': shahadaDate?.toIso8601String(),
      'learning_goals': learningGoals,
      'stats': stats != null ? (stats as ProfileStatsModel).toJson() : null,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      phone: phone,
      bio: bio,
      shahadaDate: shahadaDate,
      learningGoals: learningGoals,
      stats: stats,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Profile stats model.
class ProfileStatsModel extends ProfileStatsEntity {
  const ProfileStatsModel({
    super.lessonsCompleted,
    super.currentStreak,
    super.longestStreak,
    super.totalReadingTime,
    super.savedItems,
    super.journeyProgress,
  });

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) {
    return ProfileStatsModel(
      lessonsCompleted: json['lessons_completed'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? json['streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      totalReadingTime: json['total_reading_time'] as int? ?? 0,
      savedItems: json['saved_items'] as int? ?? 0,
      journeyProgress: (json['journey_progress'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessons_completed': lessonsCompleted,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_reading_time': totalReadingTime,
      'saved_items': savedItems,
      'journey_progress': journeyProgress,
    };
  }
}
