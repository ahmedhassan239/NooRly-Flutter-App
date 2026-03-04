/// Prayer feature models: helpers, status, and UI data.
library;

/// Format [date] as DD-MM-YYYY for AlAdhan API.
String formatDateDDMMYYYY(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year;
  return '$d-$m-$y';
}

/// Normalize time string from API (e.g. "05:12 (EET)", "05:12 (PST)" or "05:12") to "HH:mm".
String normalizePrayerTimeString(String raw) {
  final trimmed = raw.trim();
  // Strip timezone suffix: "05:12 (EET)" or "05:12 (GMT+2)" -> "05:12"
  final spaceIdx = trimmed.indexOf(' ');
  if (spaceIdx > 0) return trimmed.substring(0, spaceIdx).trim();
  return trimmed;
}

/// Parse "HH:mm" (24h) into [DateTime] on [baseDate] in local timezone.
DateTime parsePrayerTimeToDateTime(String hhmm, DateTime baseDate) {
  final normalized = normalizePrayerTimeString(hhmm);
  final parts = normalized.split(':');
  if (parts.length < 2) return baseDate;
  final hour = int.tryParse(parts[0].trim()) ?? 0;
  final minute = int.tryParse(parts[1].replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
}

/// Format [duration] as "in Xm" or "in Xh Ym" (positive duration).
String formatRemaining(Duration duration) {
  if (duration.isNegative) return 'now';
  final totalMinutes = duration.inMinutes;
  if (totalMinutes < 60) return 'in ${totalMinutes}m';
  final h = duration.inHours;
  final m = totalMinutes - (h * 60);
  if (m == 0) return 'in ${h}h';
  return 'in ${h}h ${m}m';
}

/// Prayer status for UI.
enum PrayerStatus {
  done,
  next,
  upcoming,
}

/// Order and keys for the 5 daily prayers (no Sunrise).
const List<String> prayerNamesOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

const Map<String, String> prayerIcons = {
  'Fajr': '🌅',
  'Dhuhr': '☀️',
  'Asr': '🌤️',
  'Maghrib': '🌅',
  'Isha': '🌙',
};

/// One prayer entry for the list: name, time (HH:mm), status, optional remaining.
class PrayerCardData {
  const PrayerCardData({
    required this.name,
    required this.time,
    required this.status,
    this.remaining,
    this.timeAsDateTime,
  });
  final String name;
  final String time;
  final PrayerStatus status;
  final String? remaining;
  final DateTime? timeAsDateTime;

  String get icon => prayerIcons[name] ?? '🕌';
}

/// Daily progress: completed (done), missed (placeholder), remaining (next + upcoming).
class DailyProgressData {
  const DailyProgressData({
    required this.completed,
    required this.missed,
    required this.remaining,
    required this.total,
  });
  final int completed;
  final int missed;
  final int remaining;
  final int total;

  String get fraction => '$completed/$total';
}

/// Extract only the 5 prayer timings from AlAdhan timings map (keys may be "Fajr", "Dhuhr", etc.).
Map<String, String> extractPrayerTimings(Map<String, String> timings) {
  final out = <String, String>{};
  for (final name in prayerNamesOrder) {
    final value = timings[name];
    if (value != null && value.isNotEmpty) {
      out[name] = normalizePrayerTimeString(value);
    }
  }
  return out;
}
