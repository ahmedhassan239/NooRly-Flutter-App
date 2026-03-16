/// Local state for the new multi-step onboarding flow.
/// Persisted in memory (and optionally to local storage) while progressing.
library;

import 'package:flutter/foundation.dart';

@immutable
class OnboardingFlowState {
  const OnboardingFlowState({
    this.currentStepIndex = 0,
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
  });

  /// Step index in the question flow: 0 = about you, 1 = knowledge, 2 = goals, 3 = preferences, 4 = plan.
  final int currentStepIndex;

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

  /// Total steps in flow: 1 welcome + 5 question steps = 6.
  static const int totalSteps = 6;
  static const int questionSteps = 5;

  /// Step number for progress UI (2–6). Step 1 is welcome.
  int get stepNumberDisplay => currentStepIndex + 2;

  OnboardingFlowState copyWith({
    int? currentStepIndex,
    String? displayName,
    String? embraceIslamRange,
    String? arabicLevel,
    String? prayerLevel,
    String? quranReadingLevel,
    List<String>? goals,
    List<String>? challenges,
    String? dailyTime,
    String? preferredLearningTime,
    String? learningStyle,
    String? reminderPreference,
    DateTime? islamDate,
  }) {
    return OnboardingFlowState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      displayName: displayName ?? this.displayName,
      embraceIslamRange: embraceIslamRange ?? this.embraceIslamRange,
      arabicLevel: arabicLevel ?? this.arabicLevel,
      prayerLevel: prayerLevel ?? this.prayerLevel,
      quranReadingLevel: quranReadingLevel ?? this.quranReadingLevel,
      goals: goals ?? this.goals,
      challenges: challenges ?? this.challenges,
      dailyTime: dailyTime ?? this.dailyTime,
      preferredLearningTime: preferredLearningTime ?? this.preferredLearningTime,
      learningStyle: learningStyle ?? this.learningStyle,
      reminderPreference: reminderPreference ?? this.reminderPreference,
      islamDate: islamDate ?? this.islamDate,
    );
  }
}
