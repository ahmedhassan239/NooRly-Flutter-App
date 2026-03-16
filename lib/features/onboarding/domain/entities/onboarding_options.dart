/// Option value keys for onboarding choices. Used for state and API mapping.
library;

/// When did you embrace Islam?
abstract class EmbraceIslamOption {
  static const String lessThan1Month = 'less_than_1_month';
  static const String oneTo6Months = '1_6_months';
  static const String sixTo12Months = '6_12_months';
  static const String oneTo2Years = '1_2_years';
  static const String twoPlusYears = '2_plus_years';
  static const String bornMuslim = 'born_muslim';
}

/// Can you read Arabic?
abstract class ArabicLevelOption {
  static const String yesFluently = 'yes_fluently';
  static const String yesSlowly = 'yes_slowly';
  static const String learningNow = 'learning_now';
  static const String noWantToLearn = 'no_want_to_learn';
  static const String no = 'no';
}

/// Do you pray the 5 daily prayers?
abstract class PrayerLevelOption {
  static const String yesRegularly = 'yes_regularly';
  static const String yesNotAll5 = 'yes_not_all_5';
  static const String learningToPray = 'learning_to_pray';
  static const String notYet = 'not_yet';
}

/// Have you read any Quran?
abstract class QuranReadingOption {
  static const String yesRegularly = 'yes_regularly';
  static const String yesOccasionally = 'yes_occasionally';
  static const String justStarted = 'just_started';
  static const String notYet = 'not_yet';
}

/// Main goals (multi-select)
abstract class GoalOption {
  static const String learnBasics = 'learn_basics';
  static const String improvePrayer = 'improve_prayer';
  static const String understandQuran = 'understand_quran';
  static const String buildHabits = 'build_habits';
  static const String connectCommunity = 'connect_community';
}

/// Challenges (multi-select chips)
abstract class ChallengeOption {
  static const String understandingArabic = 'understanding_arabic';
  static const String rememberingToPray = 'remembering_to_pray';
  static const String findingTime = 'finding_time';
  static const String stayingConsistent = 'staying_consistent';
  static const String dealingWithDoubts = 'dealing_with_doubts';
  static const String lackOfSupport = 'lack_of_support';
}

/// How much time daily?
abstract class DailyTimeOption {
  static const String fiveTo10 = '5_10_min';
  static const String fifteenTo20 = '15_20_min';
  static const String thirtyPlus = '30_plus_min';
  static const String flexible = 'flexible';
}

/// Best time to learn?
abstract class LearningTimeOption {
  static const String morning = 'morning';
  static const String afternoon = 'afternoon';
  static const String evening = 'evening';
  static const String night = 'night';
  static const String anytime = 'anytime';
}

/// How do you learn best?
abstract class LearningStyleOption {
  static const String reading = 'reading';
  static const String listening = 'listening';
  static const String videos = 'videos';
  static const String interactive = 'interactive';
  static const String mixOfAll = 'mix_of_all';
}

/// Reminders & notifications
abstract class ReminderOption {
  static const String allReminders = 'all_reminders';
  static const String prayerTimesOnly = 'prayer_times_only';
  static const String letMeCustomize = 'let_me_customize';
  static const String noThanks = 'no_thanks';
}
