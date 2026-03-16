/// Persisted onboarding profile from GET/PUT /me/onboarding-profile.
library;

import 'package:flutter/foundation.dart';

@immutable
class OnboardingProfileEntity {
  const OnboardingProfileEntity({
    this.displayName,
    this.embraceIslamRange,
    this.arabicLevel,
    this.prayerLevel,
    this.quranReadingLevel,
    this.goals = const [],
    this.challenges = const [],
    this.dailyTime,
    this.preferredLearningTime,
    this.learningStyle,
    this.reminderPreference,
    this.islamDate,
    this.onboardingCompletedAt,
  });

  final String? displayName;
  final String? embraceIslamRange;
  final String? arabicLevel;
  final String? prayerLevel;
  final String? quranReadingLevel;
  final List<String> goals;
  final List<String> challenges;
  final String? dailyTime;
  final String? preferredLearningTime;
  final String? learningStyle;
  final String? reminderPreference;
  final DateTime? islamDate;
  final DateTime? onboardingCompletedAt;

  bool get isEmpty =>
      displayName == null &&
      embraceIslamRange == null &&
      arabicLevel == null &&
      prayerLevel == null &&
      quranReadingLevel == null &&
      goals.isEmpty &&
      challenges.isEmpty &&
      dailyTime == null &&
      preferredLearningTime == null &&
      learningStyle == null &&
      reminderPreference == null &&
      islamDate == null;

  bool get isCompleted => onboardingCompletedAt != null;
}
