/// Mock data for Prayer Times page

enum PrayerStatus {
  completed,
  missed,
  next,
  upcoming,
}

class PrayerData {
  final String name;
  final String time;
  final String? timeUntil;
  final PrayerStatus status;
  final String icon;

  const PrayerData({
    required this.name,
    required this.time,
    this.timeUntil,
    required this.status,
    required this.icon,
  });
}

class PrayerMockData {
  PrayerMockData._();

  static const String location = 'San Francisco, CA';
  static const String currentDate = 'Tue, Jan 13';
  static const String currentTime = '04:24 PM';

  // Progress stats
  static const int completedCount = 0;
  static const int missedCount = 2;
  static const int remainingCount = 3;
  static const int totalPrayers = 5;

  static const List<PrayerData> prayers = [
    PrayerData(
      name: 'Fajr',
      time: '12:30',
      status: PrayerStatus.missed,
      icon: '🌅',
    ),
    PrayerData(
      name: 'Dhuhr',
      time: '14:15',
      status: PrayerStatus.missed,
      icon: '☀️',
    ),
    PrayerData(
      name: 'Asr',
      time: '16:54',
      timeUntil: 'in 29m',
      status: PrayerStatus.next,
      icon: '🌤️',
    ),
    PrayerData(
      name: 'Maghrib',
      time: '18:45',
      status: PrayerStatus.upcoming,
      icon: '🌅',
    ),
    PrayerData(
      name: 'Isha',
      time: '20:30',
      status: PrayerStatus.upcoming,
      icon: '🌙',
    ),
  ];
}
