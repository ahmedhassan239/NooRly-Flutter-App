import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Mock data for Duas Hub page

class DuasMockData {
  DuasMockData._();

  static const List<DuaCategory> categories = [
    DuaCategory(
      id: 'saved',
      title: 'Saved Duas',
      subtitle: '0 saved',
      icon: LucideIcons.bookmark,
      iconColor: AppColors.primary,
    ),
    DuaCategory(
      id: 'morning-evening',
      title: 'Morning & Evening',
      subtitle: '8 duas',
      icon: LucideIcons.moon,
      iconColor: AppColors.accentGold,
    ),
    DuaCategory(
      id: 'meals',
      title: 'Before & After Meals',
      subtitle: '4 duas',
      icon: LucideIcons.utensils,
      iconColor: AppColors.accentCoral,
    ),
    DuaCategory(
      id: 'sleep',
      title: 'Sleep & Waking',
      subtitle: '6 duas',
      icon: LucideIcons.bed,
      iconColor: AppColors.primary,
    ),
    DuaCategory(
      id: 'travel',
      title: 'Travel',
      subtitle: '4 duas',
      icon: LucideIcons.car,
      iconColor: AppColors.error,
    ),
    DuaCategory(
      id: 'protection',
      title: 'Protection',
      subtitle: '5 duas',
      icon: LucideIcons.shield,
      iconColor: AppColors.primary,
    ),
    DuaCategory(
      id: 'gratitude',
      title: 'Gratitude & Praise',
      subtitle: '4 duas',
      icon: LucideIcons.heart,
      iconColor: AppColors.accentGreen,
    ),
    DuaCategory(
      id: 'knowledge',
      title: 'Knowledge & Guidance',
      subtitle: '4 duas',
      icon: LucideIcons.bookOpen,
      iconColor: AppColors.primary,
    ),
    DuaCategory(
      id: 'health',
      title: 'Health & Healing',
      subtitle: '3 duas',
      icon: LucideIcons.heart,
      iconColor: AppColors.accentGreen,
    ),
  ];
}

class DuaCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const DuaCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Dua data model
class DuaData {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  /// Arabic attribution when [source] is English-only (optional).
  final String? sourceAr;

  const DuaData({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    this.sourceAr,
  });
}

/// Get duas for a specific category
extension DuasMockDataExtension on DuasMockData {
  static List<DuaData> getDuasByCategory(String categoryId) {
    switch (categoryId) {
      case 'sleep':
        return _sleepDuas;
      case 'morning-evening':
        return _morningEveningDuas;
      case 'meals':
        return _mealsDuas;
      case 'travel':
        return _travelDuas;
      case 'protection':
        return _protectionDuas;
      case 'gratitude':
        return _gratitudeDuas;
      case 'knowledge':
        return _knowledgeDuas;
      case 'health':
        return _healthDuas;
      default:
        return [];
    }
  }

  static DuaCategory? getCategoryById(String categoryId) {
    try {
      return DuasMockData.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Sleep & Waking Duas
  static const List<DuaData> _sleepDuas = [
    DuaData(
      id: 'sleep-1',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allahumma amutu wa ahya',
      translation: 'In Your name, O Allah, I die and I live',
      source: 'Bukhari',
    ),
    DuaData(
      id: 'sleep-2',
      arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
      transliteration: 'Allahumma qini adhabaka yawma tab\'athu ibadaka',
      translation: 'O Allah, protect me from Your punishment on the day You resurrect Your servants',
      source: 'Surah Al-Baqarah 2:255',
      sourceAr: 'سُورَةُ البَقَرَةِ — ٢٥٥',
    ),
    DuaData(
      id: 'sleep-3',
      arabic: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ',
      transliteration: 'Allahumma aslamtu nafsi ilayka',
      translation: 'O Allah, I have submitted myself to You',
      source: 'Muslim',
    ),
    DuaData(
      id: 'sleep-4',
      arabic: 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
      transliteration: 'Allahumma bismika amutu wa ahya',
      translation: 'O Allah, in Your name I die and I live',
      source: 'Ibn As-Sunni',
    ),
    DuaData(
      id: 'sleep-5',
      arabic: 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ وَرَبَّ الأَرْضِ',
      transliteration: 'Allahumma Rabbas-samawati wa Rabb-al-ard',
      translation: 'O Allah, Lord of the heavens and the earth',
      source: 'Bukhari',
    ),
    DuaData(
      id: 'sleep-6',
      arabic: 'اللَّهُمَّ أَعُوذُ بِكَ مِنْ عَذَابِ النَّارِ',
      transliteration: 'Allahumma a\'udhu bika min adhabi an-nar',
      translation: 'O Allah, I seek refuge in You from the punishment of the Fire',
      source: 'Muslim',
    ),
  ];

  // Morning & Evening Duas
  static const List<DuaData> _morningEveningDuas = [
    DuaData(
      id: 'morning-1',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      transliteration: 'Asbahna wa asbahal-mulku lillah',
      translation: 'We have reached the morning and at this very time all sovereignty belongs to Allah',
      source: 'Muslim',
    ),
    DuaData(
      id: 'evening-1',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      transliteration: 'Amsayna wa amsal-mulku lillah',
      translation: 'We have reached the evening and at this very time all sovereignty belongs to Allah',
      source: 'Muslim',
    ),
  ];

  // Meals Duas
  static const List<DuaData> _mealsDuas = [
    DuaData(
      id: 'meal-1',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillah',
      translation: 'In the name of Allah',
      source: 'Bukhari',
    ),
  ];

  // Travel Duas
  static const List<DuaData> _travelDuas = [
    DuaData(
      id: 'travel-1',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا',
      transliteration: 'Subhanalladhi sakhkhara lana hadha',
      translation: 'Glory to Him who has subjected this to us',
      source: 'Muslim',
    ),
  ];

  // Protection Duas
  static const List<DuaData> _protectionDuas = [
    DuaData(
      id: 'protection-1',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati',
      translation: 'I seek refuge in the perfect words of Allah',
      source: 'Bukhari',
    ),
  ];

  // Gratitude Duas
  static const List<DuaData> _gratitudeDuas = [
    DuaData(
      id: 'gratitude-1',
      arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      transliteration: 'Alhamdulillahi Rabbil-alamin',
      translation: 'Praise be to Allah, Lord of the worlds',
      source: 'Quran',
    ),
  ];

  // Knowledge Duas
  static const List<DuaData> _knowledgeDuas = [
    DuaData(
      id: 'knowledge-1',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni ilma',
      translation: 'My Lord, increase me in knowledge',
      source: 'Quran 20:114',
    ),
  ];

  // Health Duas
  static const List<DuaData> _healthDuas = [
    DuaData(
      id: 'health-1',
      arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي',
      transliteration: 'Allahumma afini fi badani',
      translation: 'O Allah, grant me health in my body',
      source: 'Tirmidhi',
    ),
  ];
}
