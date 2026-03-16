/// API model for GET/PUT /me/onboarding-profile.
library;

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_profile_entity.dart';

class OnboardingProfileModel extends OnboardingProfileEntity {
  const OnboardingProfileModel({
    super.displayName,
    super.embraceIslamRange,
    super.arabicLevel,
    super.prayerLevel,
    super.quranReadingLevel,
    super.goals,
    super.challenges,
    super.dailyTime,
    super.preferredLearningTime,
    super.learningStyle,
    super.reminderPreference,
    super.islamDate,
    super.onboardingCompletedAt,
  });

  factory OnboardingProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const OnboardingProfileModel();
    }
    return OnboardingProfileModel(
      displayName: json['display_name'] as String?,
      embraceIslamRange: json['embrace_islam_range'] as String?,
      arabicLevel: json['arabic_level'] as String?,
      prayerLevel: json['prayer_level'] as String?,
      quranReadingLevel: json['quran_reading_level'] as String?,
      goals: json['goals'] != null
          ? List<String>.from(json['goals'] as List)
          : [],
      challenges: json['challenges'] != null
          ? List<String>.from(json['challenges'] as List)
          : [],
      dailyTime: json['daily_time'] as String?,
      preferredLearningTime: json['preferred_learning_time'] as String?,
      learningStyle: json['learning_style'] as String?,
      reminderPreference: json['reminder_preference'] as String?,
      islamDate: json['islam_date'] != null
          ? DateTime.tryParse(json['islam_date'] as String)
          : null,
      onboardingCompletedAt: json['onboarding_completed_at'] != null
          ? DateTime.tryParse(json['onboarding_completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'embrace_islam_range': embraceIslamRange,
      'arabic_level': arabicLevel,
      'prayer_level': prayerLevel,
      'quran_reading_level': quranReadingLevel,
      'goals': goals,
      'challenges': challenges,
      'daily_time': dailyTime,
      'preferred_learning_time': preferredLearningTime,
      'learning_style': learningStyle,
      'reminder_preference': reminderPreference,
      'islam_date': islamDate?.toIso8601String().split('T').first,
    };
  }
}
