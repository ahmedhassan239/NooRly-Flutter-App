/// Home dashboard models for API serialization.
library;

import 'package:flutter_app/features/home/domain/entities/home_entity.dart';

/// Home dashboard model.
class HomeDashboardModel extends HomeDashboardEntity {
  const HomeDashboardModel({
    super.dailyVerse,
    super.userProgress,
    super.featuredContent,
    super.quickStats,
    super.recentActivity,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    return HomeDashboardModel(
      dailyVerse: json['daily_verse'] != null
          ? DailyVerseModel.fromJson(json['daily_verse'] as Map<String, dynamic>)
          : null,
      userProgress: json['user_progress'] != null
          ? UserProgressModel.fromJson(json['user_progress'] as Map<String, dynamic>)
          : null,
      featuredContent: (json['featured_content'] as List<dynamic>?)
              ?.map((e) => FeaturedContentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quickStats: (json['quick_stats'] as List<dynamic>?)
              ?.map((e) => QuickStatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentActivity: (json['recent_activity'] as List<dynamic>?)
              ?.map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_verse': dailyVerse != null
          ? (dailyVerse as DailyVerseModel).toJson()
          : null,
      'user_progress': userProgress != null
          ? (userProgress as UserProgressModel).toJson()
          : null,
      'featured_content':
          featuredContent.map((e) => (e as FeaturedContentModel).toJson()).toList(),
      'quick_stats':
          quickStats.map((e) => (e as QuickStatModel).toJson()).toList(),
      'recent_activity':
          recentActivity.map((e) => (e as RecentActivityModel).toJson()).toList(),
    };
  }

  HomeDashboardEntity toEntity() {
    return HomeDashboardEntity(
      dailyVerse: dailyVerse,
      userProgress: userProgress,
      featuredContent: featuredContent,
      quickStats: quickStats,
      recentActivity: recentActivity,
    );
  }
}

/// Daily verse model.
class DailyVerseModel extends DailyVerseEntity {
  const DailyVerseModel({
    required super.id,
    required super.arabicText,
    super.translation,
    super.surahName,
    super.surahNameAr,
    super.verseNumber,
    super.audioUrl,
  });

  factory DailyVerseModel.fromJson(Map<String, dynamic> json) {
    return DailyVerseModel(
      id: (json['id'] ?? '').toString(),
      arabicText: json['arabic_text'] as String? ?? json['arabic'] as String? ?? '',
      translation: json['translation'] as String?,
      surahName: json['surah_name'] as String? ?? json['surah'] as String?,
      surahNameAr: json['surah_name_ar'] as String?,
      verseNumber: json['verse_number'] as int? ?? json['ayah'] as int?,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_text': arabicText,
      'translation': translation,
      'surah_name': surahName,
      'surah_name_ar': surahNameAr,
      'verse_number': verseNumber,
      'audio_url': audioUrl,
    };
  }
}

/// User progress model.
class UserProgressModel extends UserProgressEntity {
  const UserProgressModel({
    super.currentDay,
    super.totalDays,
    super.completedLessons,
    super.streak,
    super.lastActivityDate,
    super.progressPercentage,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      currentDay: json['current_day'] as int? ?? 0,
      totalDays: json['total_days'] as int? ?? 40,
      completedLessons: json['completed_lessons'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.tryParse(json['last_activity_date'] as String)
          : null,
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_day': currentDay,
      'total_days': totalDays,
      'completed_lessons': completedLessons,
      'streak': streak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
      'progress_percentage': progressPercentage,
    };
  }
}

/// Featured content model.
class FeaturedContentModel extends FeaturedContentEntity {
  const FeaturedContentModel({
    required super.id,
    required super.type,
    required super.title,
    super.titleAr,
    super.subtitle,
    super.subtitleAr,
    super.imageUrl,
    super.deepLink,
  });

  factory FeaturedContentModel.fromJson(Map<String, dynamic> json) {
    return FeaturedContentModel(
      id: (json['id'] ?? '').toString(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      subtitle: json['subtitle'] as String?,
      subtitleAr: json['subtitle_ar'] as String?,
      imageUrl: json['image_url'] as String? ?? json['image'] as String?,
      deepLink: json['deep_link'] as String? ?? json['link'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'title_ar': titleAr,
      'subtitle': subtitle,
      'subtitle_ar': subtitleAr,
      'image_url': imageUrl,
      'deep_link': deepLink,
    };
  }
}

/// Quick stat model.
class QuickStatModel extends QuickStatEntity {
  const QuickStatModel({
    required super.id,
    required super.label,
    required super.value,
    super.labelAr,
    super.icon,
    super.color,
  });

  factory QuickStatModel.fromJson(Map<String, dynamic> json) {
    return QuickStatModel(
      id: (json['id'] ?? '').toString(),
      label: json['label'] as String? ?? '',
      labelAr: json['label_ar'] as String?,
      value: (json['value'] ?? '').toString(),
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'label_ar': labelAr,
      'value': value,
      'icon': icon,
      'color': color,
    };
  }
}

/// Recent activity model.
class RecentActivityModel extends RecentActivityEntity {
  const RecentActivityModel({
    required super.id,
    required super.type,
    required super.title,
    super.titleAr,
    required super.timestamp,
    super.deepLink,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: (json['id'] ?? '').toString(),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      deepLink: json['deep_link'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'title_ar': titleAr,
      'timestamp': timestamp.toIso8601String(),
      'deep_link': deepLink,
    };
  }
}
