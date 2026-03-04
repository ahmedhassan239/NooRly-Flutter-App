/// Mock data for Journey page
/// 90-day learning path with 13 weeks

import 'package:flutter_app/features/journey/domain/entities/journey_entity.dart';

class JourneyMockData {
  JourneyMockData._();

  // Progress stats
  static const int totalLessons = 90;
  static const int completedLessons = 0;
  static const int currentWeek = 1;
  static const int currentDay = 1;
  static double get progressPercent => completedLessons / totalLessons;

  // All weeks data
  static final List<WeekData> weeks = [
    WeekData(
      weekId: null,
      weekNumber: 1,
      title: 'Faith Basics',
      icon: '🌙',
      iconUrl: null,
      isCurrent: true,
      doneCount: 0,
      totalCount: 7,
      lessons: [
        LessonData(
          id: '1',
          dayNumber: 1,
          title: 'Welcome to Islam',
          category: 'Faith',
          duration: '3 min read',
          status: LessonStatus.start,
          unlockInfo: null,
        ),
        LessonData(
          id: '2',
          dayNumber: 2,
          title: 'The Meaning of Shahada',
          category: 'Faith',
          duration: '5 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks Tomorrow',
        ),
        LessonData(
          id: '3',
          dayNumber: 3,
          title: 'Understanding Tawheed',
          category: 'Faith',
          duration: '7 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks 2 days',
        ),
        LessonData(
          id: '4',
          dayNumber: 4,
          title: 'The Five Pillars',
          category: 'Faith',
          duration: '6 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks 3 days',
        ),
        LessonData(
          id: '5',
          dayNumber: 5,
          title: 'Who is Allah?',
          category: 'Faith',
          duration: '8 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks 4 days',
        ),
        LessonData(
          id: '6',
          dayNumber: 6,
          title: 'Angels & Revelation',
          category: 'Faith',
          duration: '6 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks 5 days',
        ),
        LessonData(
          id: '7',
          dayNumber: 7,
          title: 'Week 1 Reflection',
          category: 'Faith',
          duration: '4 min read',
          status: LessonStatus.locked,
          unlockInfo: 'Unlocks 6 days',
        ),
      ],
    ),
    WeekData(
      weekId: null,
      weekNumber: 2,
      title: 'Faith Basics (Cont.)',
      icon: '📖',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(2, 'Faith Basics (Cont.)', 'Faith'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 3,
      title: 'Understanding Prayer',
      icon: '⭐',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(3, 'Understanding Prayer', 'Prayer'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 4,
      title: 'Learning Salah',
      icon: '🕌',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(4, 'Learning Salah', 'Prayer'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 5,
      title: 'Salah Practice',
      icon: '⚡',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(5, 'Salah Practice', 'Prayer'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 6,
      title: 'Quran Introduction',
      icon: '📖',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(6, 'Quran Introduction', 'Quran'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 7,
      title: 'Quran Connection',
      icon: '🌙',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(7, 'Quran Connection', 'Quran'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 8,
      title: 'Daily Habits',
      icon: '🎯',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(8, 'Daily Habits', 'Lifestyle'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 9,
      title: 'Islamic Character',
      icon: '⭐',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(9, 'Islamic Character', 'Character'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 10,
      title: 'Community & Ummah',
      icon: '💜',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(10, 'Community & Ummah', 'Community'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 11,
      title: 'Deepening Faith',
      icon: '🔥',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(11, 'Deepening Faith', 'Faith'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 12,
      title: 'Journey Completion',
      icon: '🏆',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 7,
      lessons: _generateWeekLessons(12, 'Journey Completion', 'Completion'),
    ),
    WeekData(
      weekId: null,
      weekNumber: 13,
      title: 'Bonus Week',
      icon: '🌙',
      iconUrl: null,
      isCurrent: false,
      doneCount: 0,
      totalCount: 6,
      lessons: _generateWeekLessons(13, 'Bonus Week', 'Bonus', lessonCount: 6),
    ),
  ];

  static List<LessonData> _generateWeekLessons(
    int weekNumber,
    String weekTitle,
    String category, {
    int lessonCount = 7,
  }) {
    final startDay = (weekNumber - 1) * 7 + 1;
    return List.generate(lessonCount, (index) {
      final dayNumber = startDay + index;
      final lessonId = '${(weekNumber - 1) * 7 + index + 1}';
      return LessonData(
        id: lessonId,
        dayNumber: dayNumber,
        title: '$weekTitle - Day ${index + 1}',
        category: category,
        duration: '${5 + (index % 4)} min read',
        status: LessonStatus.locked,
        unlockInfo: 'Unlocks in ${dayNumber - currentDay} days',
      );
    });
  }
}

/// Backend icon key -> emoji (matches config/journey_icons.php).
const Map<String, String> _journeyIconKeysToEmoji = {
  'mosque': '🕌',
  'quran': '📖',
  'tasbih': '📿',
  'crescent': '🌙',
  'kaaba': '🕋',
  'star': '⭐',
  'prayer': '🤲',
  'lantern': '🏮',
  'date_palm': '🌴',
  'heart': '💚',
};

/// Resolve week icon: backend key -> emoji, or URL for network image.
String? resolveWeekIconEmoji(String? iconKeyOrUrl) {
  if (iconKeyOrUrl == null || iconKeyOrUrl.isEmpty) return null;
  if (iconKeyOrUrl.startsWith('http://') || iconKeyOrUrl.startsWith('https://')) {
    return null; // Caller should use iconUrl
  }
  return _journeyIconKeysToEmoji[iconKeyOrUrl] ?? _journeyIconKeysToEmoji[iconKeyOrUrl.toLowerCase()];
}

/// Map journey entity to UI WeekData list and stats.
List<WeekData> journeyToWeekDataList(List<WeekEntity> weeks) {
  const fallbackWeekIcons = ['🌙', '📖', '⭐', '🕌', '⚡', '📖', '🌙', '📖', '⭐', '🕌', '⚡', '📖', '🌙'];
  return weeks.map((w) {
    final String iconDisplay;
    final String? iconUrl;
    final resolved = resolveWeekIconEmoji(w.icon);
    if (w.icon != null &&
        (w.icon!.startsWith('http://') || w.icon!.startsWith('https://'))) {
      iconDisplay = '';
      iconUrl = w.icon;
    } else if (resolved != null) {
      iconDisplay = resolved;
      iconUrl = null;
    } else {
      iconDisplay = w.weekNumber <= fallbackWeekIcons.length
          ? fallbackWeekIcons[w.weekNumber - 1]
          : '📚';
      iconUrl = null;
    }
    return WeekData(
      weekId: w.id?.toString(),
      weekNumber: w.weekNumber,
      title: w.title,
      icon: iconDisplay,
      iconUrl: iconUrl,
      isCurrent: w.isCurrent,
      doneCount: w.displayDoneCount,
      totalCount: w.displayTotalCount,
      lessons: w.lessons.map((l) {
        LessonStatus status;
        if (l.isCompleted) {
          status = LessonStatus.completed;
        } else if (l.isUnlocked) {
          status = LessonStatus.start;
        } else {
          status = LessonStatus.locked;
        }
        final duration = l.duration != null ? '${l.duration} min read' : '—';
        return LessonData(
          id: l.id,
          dayNumber: l.dayNumber,
          title: l.title,
          category: 'Lesson',
          duration: duration,
          status: status,
          unlockInfo: status == LessonStatus.locked
              ? 'Complete previous lesson'
              : null,
        );
      }).toList(),
    );
  }).toList();
}

enum LessonStatus {
  completed,
  start,
  locked,
}

class WeekData {
  /// Stable id from backend (for widget keys and caching).
  final String? weekId;
  final int weekNumber;
  final String title;
  /// Emoji or empty when using iconUrl.
  final String icon;
  /// When set, show Image.network(iconUrl) instead of icon emoji.
  final String? iconUrl;
  final bool isCurrent;
  /// From backend (done/total) so counter is correct even if lessons list is empty.
  final int doneCount;
  final int totalCount;
  final List<LessonData> lessons;

  const WeekData({
    this.weekId,
    required this.weekNumber,
    required this.title,
    required this.icon,
    this.iconUrl,
    required this.isCurrent,
    required this.doneCount,
    required this.totalCount,
    required this.lessons,
  });

  int get completedCount => doneCount;
}

class LessonData {
  /// Lesson id for API and routing (e.g. /lessons/:id).
  final String id;
  final int dayNumber;
  final String title;
  final String category;
  final String duration;
  final LessonStatus status;
  final String? unlockInfo;

  const LessonData({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.category,
    required this.duration,
    required this.status,
    this.unlockInfo,
  });

  bool get isLocked => status == LessonStatus.locked;
}





