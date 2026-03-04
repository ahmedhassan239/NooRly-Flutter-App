/// Home dashboard entities.
library;

import 'package:flutter/foundation.dart';

/// Home dashboard data.
@immutable
class HomeDashboardEntity {
  const HomeDashboardEntity({
    this.dailyVerse,
    this.userProgress,
    this.featuredContent = const [],
    this.quickStats = const [],
    this.recentActivity = const [],
  });

  /// Daily verse/ayah.
  final DailyVerseEntity? dailyVerse;

  /// User's learning progress.
  final UserProgressEntity? userProgress;

  /// Featured content items.
  final List<FeaturedContentEntity> featuredContent;

  /// Quick stats (lessons completed, streak, etc.).
  final List<QuickStatEntity> quickStats;

  /// Recent activity items.
  final List<RecentActivityEntity> recentActivity;
}

/// Daily verse entity.
@immutable
class DailyVerseEntity {
  const DailyVerseEntity({
    required this.id,
    required this.arabicText,
    this.translation,
    this.surahName,
    this.surahNameAr,
    this.verseNumber,
    this.audioUrl,
  });

  final String id;
  final String arabicText;
  final String? translation;
  final String? surahName;
  final String? surahNameAr;
  final int? verseNumber;
  final String? audioUrl;

  /// Get reference string (e.g., "Al-Baqarah 2:255").
  String get reference {
    if (surahName == null || verseNumber == null) return '';
    return '$surahName $verseNumber';
  }
}

/// User progress entity.
@immutable
class UserProgressEntity {
  const UserProgressEntity({
    this.currentDay = 0,
    this.totalDays = 40,
    this.completedLessons = 0,
    this.streak = 0,
    this.lastActivityDate,
    this.progressPercentage = 0,
  });

  /// Current day in the journey.
  final int currentDay;

  /// Total days in the journey.
  final int totalDays;

  /// Number of completed lessons.
  final int completedLessons;

  /// Current streak (consecutive days).
  final int streak;

  /// Last activity date.
  final DateTime? lastActivityDate;

  /// Progress percentage (0-100).
  final double progressPercentage;

  /// Check if journey is complete.
  bool get isComplete => currentDay >= totalDays;

  /// Get remaining days.
  int get remainingDays => totalDays - currentDay;
}

/// Featured content entity.
@immutable
class FeaturedContentEntity {
  const FeaturedContentEntity({
    required this.id,
    required this.type,
    required this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.imageUrl,
    this.deepLink,
  });

  /// Content identifier.
  final String id;

  /// Content type (dua, hadith, verse, lesson, etc.).
  final String type;

  /// Title (English).
  final String title;

  /// Title (Arabic).
  final String? titleAr;

  /// Subtitle (English).
  final String? subtitle;

  /// Subtitle (Arabic).
  final String? subtitleAr;

  /// Image URL.
  final String? imageUrl;

  /// Deep link to content.
  final String? deepLink;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title;
  }
}

/// Quick stat entity.
@immutable
class QuickStatEntity {
  const QuickStatEntity({
    required this.id,
    required this.label,
    required this.value,
    this.labelAr,
    this.icon,
    this.color,
  });

  final String id;
  final String label;
  final String? labelAr;
  final String value;
  final String? icon;
  final String? color;

  /// Get localized label.
  String getLabel(String locale) {
    if (locale == 'ar' && labelAr != null) return labelAr!;
    return label;
  }
}

/// Recent activity entity.
@immutable
class RecentActivityEntity {
  const RecentActivityEntity({
    required this.id,
    required this.type,
    required this.title,
    this.titleAr,
    required this.timestamp,
    this.deepLink,
  });

  final String id;
  final String type;
  final String title;
  final String? titleAr;
  final DateTime timestamp;
  final String? deepLink;

  /// Get localized title.
  String getTitle(String locale) {
    if (locale == 'ar' && titleAr != null) return titleAr!;
    return title;
  }
}
