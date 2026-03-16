/// Maps backend onboarding profile enum values to localized display labels.
library;

import 'package:flutter_app/l10n/generated/app_localizations.dart';

/// Returns localized label for a backend value, or null if value is null/empty.
String? onboardingProfileLabel(
  AppLocalizations l10n,
  String? backendValue,
  Map<String, String Function(AppLocalizations)> map,
) {
  if (backendValue == null || backendValue.isEmpty) return null;
  final fn = map[backendValue];
  return fn != null ? fn(l10n) : backendValue;
}

/// Embrace Islam range: backend value -> label.
String? embraceIslamLabel(AppLocalizations l10n, String? v) {
  const map = {
    'less_than_1_month': _e1,
    'months_1_to_6': _e2,
    'months_6_to_12': _e3,
    'years_1_to_2': _e4,
    'over_2_years': _e5,
    'born_muslim': _e6,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _e1(AppLocalizations l) => l.onboardingEmbraceIslamLessThan1Month;
String _e2(AppLocalizations l) => l.onboardingEmbraceIslam1To6Months;
String _e3(AppLocalizations l) => l.onboardingEmbraceIslam6To12Months;
String _e4(AppLocalizations l) => l.onboardingEmbraceIslam1To2Years;
String _e5(AppLocalizations l) => l.onboardingEmbraceIslam2PlusYears;
String _e6(AppLocalizations l) => l.onboardingEmbraceIslamBornMuslim;

/// Arabic level.
String? arabicLevelLabel(AppLocalizations l10n, String? v) {
  const map = {
    'fluent': _a1,
    'slow': _a2,
    'learning_now': _a3,
    'wants_to_learn': _a4,
    'none': _a5,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _a1(AppLocalizations l) => l.onboardingArabicYesFluently;
String _a2(AppLocalizations l) => l.onboardingArabicYesSlowly;
String _a3(AppLocalizations l) => l.onboardingArabicLearningNow;
String _a4(AppLocalizations l) => l.onboardingArabicNoWantToLearn;
String _a5(AppLocalizations l) => l.onboardingArabicNo;

/// Prayer level.
String? prayerLevelLabel(AppLocalizations l10n, String? v) {
  const map = {
    'regular': _p1,
    'not_all_5': _p2,
    'learning': _p3,
    'not_yet': _p4,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _p1(AppLocalizations l) => l.onboardingPrayerYesRegularly;
String _p2(AppLocalizations l) => l.onboardingPrayerYesNotAll5;
String _p3(AppLocalizations l) => l.onboardingPrayerLearningToPray;
String _p4(AppLocalizations l) => l.onboardingPrayerNotYet;

/// Quran reading level.
String? quranLevelLabel(AppLocalizations l10n, String? v) {
  const map = {
    'regular': _q1,
    'occasional': _q2,
    'just_started': _q3,
    'not_yet': _q4,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _q1(AppLocalizations l) => l.onboardingQuranYesRegularly;
String _q2(AppLocalizations l) => l.onboardingQuranYesOccasionally;
String _q3(AppLocalizations l) => l.onboardingQuranJustStarted;
String _q4(AppLocalizations l) => l.onboardingQuranNotYet;

/// Goal: single value.
String? goalLabel(AppLocalizations l10n, String? v) {
  const map = {
    'learn_basics': _g1,
    'improve_prayer': _g2,
    'understand_quran': _g3,
    'build_good_habits': _g4,
    'connect_with_community': _g5,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _g1(AppLocalizations l) => l.onboardingGoalLearnBasics;
String _g2(AppLocalizations l) => l.onboardingGoalImprovePrayer;
String _g3(AppLocalizations l) => l.onboardingGoalUnderstandQuran;
String _g4(AppLocalizations l) => l.onboardingGoalBuildHabits;
String _g5(AppLocalizations l) => l.onboardingGoalConnectCommunity;

/// Challenge: single value.
String? challengeLabel(AppLocalizations l10n, String? v) {
  const map = {
    'understanding_arabic': _c1,
    'remembering_to_pray': _c2,
    'finding_time': _c3,
    'staying_consistent': _c4,
    'dealing_with_doubts': _c5,
    'lack_of_support': _c6,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _c1(AppLocalizations l) => l.onboardingChallengeUnderstandingArabic;
String _c2(AppLocalizations l) => l.onboardingChallengeRememberingToPray;
String _c3(AppLocalizations l) => l.onboardingChallengeFindingTime;
String _c4(AppLocalizations l) => l.onboardingChallengeStayingConsistent;
String _c5(AppLocalizations l) => l.onboardingChallengeDealingWithDoubts;
String _c6(AppLocalizations l) => l.onboardingChallengeLackOfSupport;

/// Daily time.
String? dailyTimeLabel(AppLocalizations l10n, String? v) {
  const map = {
    'min_5_10': _d1,
    'min_15_20': _d2,
    'min_30_plus': _d3,
    'flexible': _d4,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _d1(AppLocalizations l) => l.onboardingTime5To10;
String _d2(AppLocalizations l) => l.onboardingTime15To20;
String _d3(AppLocalizations l) => l.onboardingTime30Plus;
String _d4(AppLocalizations l) => l.onboardingTimeFlexible;

/// Preferred learning time.
String? learningTimeLabel(AppLocalizations l10n, String? v) {
  const map = {
    'morning': _t1,
    'afternoon': _t2,
    'evening': _t3,
    'night': _t4,
    'anytime': _t5,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _t1(AppLocalizations l) => l.onboardingBestTimeMorning;
String _t2(AppLocalizations l) => l.onboardingBestTimeAfternoon;
String _t3(AppLocalizations l) => l.onboardingBestTimeEvening;
String _t4(AppLocalizations l) => l.onboardingBestTimeNight;
String _t5(AppLocalizations l) => l.onboardingBestTimeAnytime;

/// Learning style.
String? learningStyleLabel(AppLocalizations l10n, String? v) {
  const map = {
    'reading': _s1,
    'listening': _s2,
    'videos': _s3,
    'interactive': _s4,
    'mix': _s5,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _s1(AppLocalizations l) => l.onboardingStyleReading;
String _s2(AppLocalizations l) => l.onboardingStyleListening;
String _s3(AppLocalizations l) => l.onboardingStyleVideos;
String _s4(AppLocalizations l) => l.onboardingStyleInteractive;
String _s5(AppLocalizations l) => l.onboardingStyleMixOfAll;

/// Reminder preference.
String? reminderLabel(AppLocalizations l10n, String? v) {
  const map = {
    'all_reminders': _r1,
    'prayer_only': _r2,
    'customize_later': _r3,
    'none': _r4,
  };
  return v == null ? null : (map[v] != null ? map[v]!(l10n) : v);
}

String _r1(AppLocalizations l) => l.onboardingReminderAll;
String _r2(AppLocalizations l) => l.onboardingReminderPrayerOnly;
String _r3(AppLocalizations l) => l.onboardingReminderCustomize;
String _r4(AppLocalizations l) => l.onboardingReminderNoThanks;
