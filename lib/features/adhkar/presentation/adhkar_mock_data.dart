import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Mock data for Adhkar Hub page

class AdhkarMockData {
  AdhkarMockData._();

  static const List<AdhkarCategory> categories = [
    AdhkarCategory(
      id: 'saved',
      title: 'Saved Adhkar',
      subtitle: '0 saved',
      icon: LucideIcons.bookmark,
      iconColor: AppColors.primary,
    ),
    AdhkarCategory(
      id: 'morning',
      title: 'Morning Adhkar',
      subtitle: '5 adhkar',
      icon: LucideIcons.sun,
      iconColor: AppColors.accentGold,
    ),
    AdhkarCategory(
      id: 'evening',
      title: 'Evening Adhkar',
      subtitle: '5 adhkar',
      icon: LucideIcons.moon,
      iconColor: AppColors.primary,
    ),
    AdhkarCategory(
      id: 'after-prayer',
      title: 'After Prayer',
      subtitle: '5 adhkar',
      icon: LucideIcons.landmark,
      iconColor: AppColors.primary,
    ),
    AdhkarCategory(
      id: 'daily',
      title: 'Daily Dhikr',
      subtitle: '5 adhkar',
      icon: LucideIcons.circleDot,
      iconColor: AppColors.accentGreen,
    ),
  ];
}

class AdhkarCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Adhkar data model
class AdhkarData {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final int repetition; // Number of times to say (e.g., 1, 3)

  const AdhkarData({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.repetition,
  });
}

/// Get adhkar for a specific category
extension AdhkarMockDataExtension on AdhkarMockData {
  static List<AdhkarData> getAdhkarByCategory(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return _morningAdhkar;
      case 'evening':
        return _eveningAdhkar;
      case 'after-prayer':
        return _afterPrayerAdhkar;
      case 'daily':
        return _dailyAdhkar;
      default:
        return [];
    }
  }

  static AdhkarCategory? getCategoryById(String categoryId) {
    try {
      return AdhkarMockData.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  static AdhkarData? getAdhkarById(String adhkarId) {
    final allAdhkar = [
      ..._morningAdhkar,
      ..._eveningAdhkar,
      ..._afterPrayerAdhkar,
      ..._dailyAdhkar,
    ];
    try {
      return allAdhkar.firstWhere((a) => a.id == adhkarId);
    } catch (e) {
      return null;
    }
  }

  // Morning Adhkar
  static const List<AdhkarData> _morningAdhkar = [
    AdhkarData(
      id: 'morning-1',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      transliteration: 'Asbahna wa asbahal-mulku lillah',
      translation: 'We have reached the morning and the dominion belongs to Allah.',
      source: 'Muslim',
      repetition: 1,
    ),
    AdhkarData(
      id: 'morning-2',
      arabic: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ فَمِنْكَ',
      transliteration: 'Allahumma ma asbaha bi min ni\'matin famink',
      translation: 'O Allah, whatever blessing I have received this morning is from You.',
      source: 'Abu Dawud',
      repetition: 1,
    ),
    AdhkarData(
      id: 'morning-3',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ',
      transliteration: 'Allahumma inni as\'alukal-\'afwa wal-\'afiyah',
      translation: 'O Allah, I ask You for pardon and well-being.',
      source: 'Tirmidhi',
      repetition: 3,
    ),
    AdhkarData(
      id: 'morning-4',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bikalimati-llahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      source: 'Muslim',
      repetition: 3,
    ),
    AdhkarData(
      id: 'morning-5',
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ',
      transliteration: 'Bismillahilladhi la yadurru ma\'asmihi shay\'un',
      translation: 'In the name of Allah, with whose name nothing can cause harm.',
      source: 'Tirmidhi',
      repetition: 3,
    ),
  ];

  // Evening Adhkar
  static const List<AdhkarData> _eveningAdhkar = [
    AdhkarData(
      id: 'evening-1',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      transliteration: 'Amsayna wa amsal-mulku lillah',
      translation: 'We have reached the evening and the dominion belongs to Allah.',
      source: 'Muslim',
      repetition: 1,
    ),
    AdhkarData(
      id: 'evening-2',
      arabic: 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ فَمِنْكَ',
      transliteration: 'Allahumma ma amsa bi min ni\'matin famink',
      translation: 'O Allah, whatever blessing I have received this evening is from You.',
      source: 'Abu Dawud',
      repetition: 1,
    ),
    AdhkarData(
      id: 'evening-3',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ',
      transliteration: 'Allahumma inni as\'alukal-\'afwa wal-\'afiyah',
      translation: 'O Allah, I ask You for pardon and well-being.',
      source: 'Tirmidhi',
      repetition: 3,
    ),
    AdhkarData(
      id: 'evening-4',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bikalimati-llahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      source: 'Muslim',
      repetition: 3,
    ),
    AdhkarData(
      id: 'evening-5',
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ',
      transliteration: 'Bismillahilladhi la yadurru ma\'asmihi shay\'un',
      translation: 'In the name of Allah, with whose name nothing can cause harm.',
      source: 'Tirmidhi',
      repetition: 3,
    ),
  ];

  // After Prayer Adhkar
  static const List<AdhkarData> _afterPrayerAdhkar = [
    AdhkarData(
      id: 'after-prayer-1',
      arabic: 'أَسْتَغْفِرُ اللَّه',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah.',
      source: 'Muslim',
      repetition: 3,
    ),
    AdhkarData(
      id: 'after-prayer-2',
      arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ',
      transliteration: 'Allahumma antas-salam wa minkas-salam',
      translation: 'O Allah, You are Peace and from You comes peace.',
      source: 'Muslim',
      repetition: 1,
    ),
    AdhkarData(
      id: 'after-prayer-3',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration: 'La ilaha illallahu wahdahu la sharika lah',
      translation: 'There is no god but Allah, alone, without partner.',
      source: 'Bukhari',
      repetition: 10,
    ),
    AdhkarData(
      id: 'after-prayer-4',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subhanallah',
      translation: 'Glory be to Allah.',
      source: 'Muslim',
      repetition: 33,
    ),
    AdhkarData(
      id: 'after-prayer-5',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translation: 'Praise be to Allah.',
      source: 'Muslim',
      repetition: 33,
    ),
  ];

  // Daily Dhikr
  static const List<AdhkarData> _dailyAdhkar = [
    AdhkarData(
      id: 'daily-1',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'Subhanallahi wa bihamdih',
      translation: 'Glory be to Allah and praise be to Him.',
      source: 'Bukhari',
      repetition: 100,
    ),
    AdhkarData(
      id: 'daily-2',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power and no strength except with Allah.',
      source: 'Bukhari',
      repetition: 100,
    ),
    AdhkarData(
      id: 'daily-3',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
      translation: 'O Allah, send blessings upon Muhammad.',
      source: 'Muslim',
      repetition: 10,
    ),
    AdhkarData(
      id: 'daily-4',
      arabic: 'رَبِّ اغْفِرْ لِي',
      transliteration: 'Rabbi ighfir li',
      translation: 'My Lord, forgive me.',
      source: 'Bukhari',
      repetition: 100,
    ),
    AdhkarData(
      id: 'daily-5',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illallah',
      translation: 'There is no god but Allah.',
      source: 'Muslim',
      repetition: 100,
    ),
  ];
}
