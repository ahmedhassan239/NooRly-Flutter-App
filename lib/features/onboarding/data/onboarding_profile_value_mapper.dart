/// Maps Flutter onboarding option values to backend API values and back.
/// Backend uses stable enum-like strings; Flutter UI may use slightly different keys.
library;

/// Map Flutter flow state values to backend API payload values.
class OnboardingProfileValueMapper {
  OnboardingProfileValueMapper._();

  static const Map<String, String> _embraceIslamToApi = {
    'less_than_1_month': 'less_than_1_month',
    '1_6_months': 'months_1_to_6',
    '6_12_months': 'months_6_to_12',
    '1_2_years': 'years_1_to_2',
    '2_plus_years': 'over_2_years',
    'born_muslim': 'born_muslim',
  };

  static const Map<String, String> _arabicToApi = {
    'yes_fluently': 'fluent',
    'yes_slowly': 'slow',
    'learning_now': 'learning_now',
    'no_want_to_learn': 'wants_to_learn',
    'no': 'none',
  };

  static const Map<String, String> _prayerToApi = {
    'yes_regularly': 'regular',
    'yes_not_all_5': 'not_all_5',
    'learning_to_pray': 'learning',
    'not_yet': 'not_yet',
  };

  static const Map<String, String> _quranToApi = {
    'yes_regularly': 'regular',
    'yes_occasionally': 'occasional',
    'just_started': 'just_started',
    'not_yet': 'not_yet',
  };

  static const Map<String, String> _goalToApi = {
    'learn_basics': 'learn_basics',
    'improve_prayer': 'improve_prayer',
    'understand_quran': 'understand_quran',
    'build_habits': 'build_good_habits',
    'connect_community': 'connect_with_community',
  };

  static const Map<String, String> _challengeToApi = {
    'understanding_arabic': 'understanding_arabic',
    'remembering_to_pray': 'remembering_to_pray',
    'finding_time': 'finding_time',
    'staying_consistent': 'staying_consistent',
    'dealing_with_doubts': 'dealing_with_doubts',
    'lack_of_support': 'lack_of_support',
  };

  static const Map<String, String> _dailyTimeToApi = {
    '5_10_min': 'min_5_10',
    '15_20_min': 'min_15_20',
    '30_plus_min': 'min_30_plus',
    'flexible': 'flexible',
  };

  static const Map<String, String> _learningTimeToApi = {
    'morning': 'morning',
    'afternoon': 'afternoon',
    'evening': 'evening',
    'night': 'night',
    'anytime': 'anytime',
  };

  static const Map<String, String> _learningStyleToApi = {
    'reading': 'reading',
    'listening': 'listening',
    'videos': 'videos',
    'interactive': 'interactive',
    'mix_of_all': 'mix',
  };

  static const Map<String, String> _reminderToApi = {
    'all_reminders': 'all_reminders',
    'prayer_times_only': 'prayer_only',
    'let_me_customize': 'customize_later',
    'no_thanks': 'none',
  };

  /// Convert a single flow value to API value (pass-through if already API value).
  static String? embraceIslamToApi(String? v) => v == null ? null : (_embraceIslamToApi[v] ?? v);
  static String? arabicToApi(String? v) => v == null ? null : (_arabicToApi[v] ?? v);
  static String? prayerToApi(String? v) => v == null ? null : (_prayerToApi[v] ?? v);
  static String? quranToApi(String? v) => v == null ? null : (_quranToApi[v] ?? v);
  static List<String> goalsToApi(List<String> v) => v.map((e) => _goalToApi[e] ?? e).toList();
  static List<String> challengesToApi(List<String> v) => v.map((e) => _challengeToApi[e] ?? e).toList();
  static String? dailyTimeToApi(String? v) => v == null ? null : (_dailyTimeToApi[v] ?? v);
  static String? learningTimeToApi(String? v) => v == null ? null : (_learningTimeToApi[v] ?? v);
  static String? learningStyleToApi(String? v) => v == null ? null : (_learningStyleToApi[v] ?? v);
  static String? reminderToApi(String? v) => v == null ? null : (_reminderToApi[v] ?? v);
}
