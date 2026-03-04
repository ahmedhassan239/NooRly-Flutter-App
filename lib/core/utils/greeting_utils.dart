/// Pure, unit-testable helpers for time-based greeting and title from gender.
library;

/// Returns a greeting string based on [now] (device local time).
///
/// - 05:00–11:59 → "Good morning"
/// - 12:00–16:59 → "Good afternoon"
/// - 17:00–20:59 → "Good evening"
/// - 21:00–04:59 → "Good night"
String getGreeting(DateTime now) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) return 'Good morning';
  if (hour >= 12 && hour < 17) return 'Good afternoon';
  if (hour >= 17 && hour < 21) return 'Good evening';
  return 'Good night';
}

/// Returns honorific title from gender for display (e.g. "Mr Abdullah", "Ms Aisha").
///
/// - "male" (case-insensitive) → "Mr"
/// - "female" (case-insensitive) → "Ms"
/// - Unknown / other / null → ""
String getTitleFromGender(String? gender) {
  if (gender == null || gender.isEmpty) return '';
  switch (gender.trim().toLowerCase()) {
    case 'male':
      return 'Mr';
    case 'female':
      return 'Ms';
    default:
      return '';
  }
}

/// Builds display name with optional title: "Mr Abdullah", "Ms Aisha", or "Abdullah".
///
/// [name] can be full name or first name; null/empty returns "".
/// [gender] is used for title (Mr/Ms); unknown gender uses no title.
String getDisplayNameWithTitle(String? name, String? gender) {
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty) return '';
  final title = getTitleFromGender(gender);
  if (title.isEmpty) return trimmed;
  return '$title $trimmed';
}
