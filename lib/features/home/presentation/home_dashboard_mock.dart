/// Mock data for Home Dashboard
/// Replace with actual data from providers/API later

class HomeMockData {
  HomeMockData._();

  // User info
  static const String userName = 'Abdullah';
  static const int currentDay = 1;
  static const int totalDays = 60;
  static const int streakDays = 0;
  static const int completedLessons = 0;
  static const double progressPercent = 0.0;

  // Tasks
  static final List<TaskItem> todayTasks = [
    TaskItem(
      id: '1',
      title: 'Morning Adhkar',
      subtitle: '5 minutes',
      icon: '🌅',
      isCompleted: true,
    ),
    TaskItem(
      id: '2',
      title: 'Learn Lesson 1',
      subtitle: 'The Shahada',
      icon: '📖',
      isCompleted: false,
    ),
    TaskItem(
      id: '3',
      title: 'Evening Adhkar',
      subtitle: '5 minutes',
      icon: '🌙',
      isCompleted: false,
    ),
  ];

  // Prayer times
  static final List<PrayerTime> prayerTimes = [
    PrayerTime(name: 'Fajr', time: '5:23 AM', isNext: false, isPassed: true),
    PrayerTime(name: 'Dhuhr', time: '12:15 PM', isNext: false, isPassed: true),
    PrayerTime(name: 'Asr', time: '3:45 PM', isNext: true, isPassed: false),
    PrayerTime(name: 'Maghrib', time: '6:32 PM', isNext: false, isPassed: false),
    PrayerTime(name: 'Isha', time: '8:00 PM', isNext: false, isPassed: false),
  ];

  // Daily inspiration content
  static final Map<String, InspirationContent> inspirationContent = {
    'dua': InspirationContent(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
      transliteration: "Allahumma inni as'aluka 'ilman nafi'an, wa rizqan tayyiban, wa 'amalan mutaqabbalan",
      translation: 'O Allah, I ask You for beneficial knowledge, goodly provision, and acceptable deeds.',
      source: 'Ibn Majah',
    ),
    'hadith': InspirationContent(
      arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
      transliteration: "Innama al-a'malu bin-niyyat, wa innama li kulli imri'in ma nawa",
      translation: 'Actions are judged by intentions, and everyone will be rewarded according to what they intended.',
      source: 'Sahih Bukhari',
    ),
    'verse': InspirationContent(
      arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
      transliteration: "Wa man yattaqi Allaha yaj'al lahu makhraja, wa yarzuqhu min haythu la yahtasib",
      translation: 'And whoever fears Allah - He will make for him a way out. And will provide for him from where he does not expect.',
      source: 'Quran 65:2-3',
    ),
    'adhkar': InspirationContent(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      transliteration: 'SubhanAllahi wa bihamdihi, SubhanAllahil Azeem',
      translation: 'Glory be to Allah and all praise is due to Him. Glory be to Allah, the Magnificent.',
      source: 'Sahih Bukhari',
    ),
  };

  // Today's lesson
  static const LessonPreview todayLesson = LessonPreview(
    dayNumber: 1,
    title: 'The Shahada',
    subtitle: 'Understanding the declaration of faith',
    duration: '15 min',
    category: 'Foundation',
  );

  // Hub items
  static final List<HubItem> hubItems = [
    HubItem(
      id: 'duas',
      title: 'Duas',
      icon: '🤲',
      route: '/duas',
      color: 0xFF1E40AF,
    ),
    HubItem(
      id: 'hadith',
      title: 'Hadith',
      icon: '📜',
      route: '/hadith',
      color: 0xFFF59E0B,
    ),
    HubItem(
      id: 'verses',
      title: 'Verses',
      icon: '📖',
      route: '/verses',
      color: 0xFF10B981,
    ),
    HubItem(
      id: 'adhkar',
      title: 'Adhkar',
      icon: '📿',
      route: '/adhkar',
      color: 0xFF8B5CF6,
    ),
  ];
}

class TaskItem {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
  });
}

class PrayerTime {
  final String name;
  final String time;
  final bool isNext;
  final bool isPassed;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isPassed,
  });
}

class InspirationContent {
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;

  const InspirationContent({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
  });
}

class LessonPreview {
  final int dayNumber;
  final String title;
  final String subtitle;
  final String duration;
  final String category;

  const LessonPreview({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.category,
  });
}

class HubItem {
  final String id;
  final String title;
  final String icon;
  final String route;
  final int color;

  const HubItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });
}





