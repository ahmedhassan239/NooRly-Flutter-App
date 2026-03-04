import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/app_icons.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Mock data for Hadith Hub page

class HadithMockData {
  HadithMockData._();

  static const List<HadithCategory> categories = [
    HadithCategory(
      id: 'saved',
      title: 'Saved Hadith',
      subtitle: '0 saved',
      icon: LucideIcons.bookmark,
      iconColor: AppColors.primary,
    ),
    HadithCategory(
      id: 'faith',
      title: 'Faith & Belief',
      subtitle: '5 hadith',
      icon: LucideIcons.gem,
      iconColor: AppColors.accentGold,
    ),
    HadithCategory(
      id: 'worship',
      title: 'Worship',
      subtitle: '4 hadith',
      icon: LucideIcons.landmark,
      iconColor: AppColors.primary,
    ),
    HadithCategory(
      id: 'character',
      title: 'Good Character',
      subtitle: '5 hadith',
      icon: AppIcons.bonus,
      iconColor: AppColors.accentGold,
    ),
    HadithCategory(
      id: 'knowledge',
      title: 'Knowledge',
      subtitle: '4 hadith',
      icon: LucideIcons.layers,
      iconColor: AppColors.primary,
    ),
  ];
}

class HadithCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const HadithCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Hadith data model
class HadithData {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;

  const HadithData({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
  });
}

/// Get hadith for a specific category
extension HadithMockDataExtension on HadithMockData {
  static List<HadithData> getHadithByCategory(String categoryId) {
    switch (categoryId) {
      case 'faith':
        return _faithHadith;
      case 'worship':
        return _worshipHadith;
      case 'character':
        return _characterHadith;
      case 'knowledge':
        return _knowledgeHadith;
      default:
        return [];
    }
  }

  static HadithCategory? getCategoryById(String categoryId) {
    try {
      return HadithMockData.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  static HadithData? getHadithById(String hadithId) {
    final allHadith = [
      ..._faithHadith,
      ..._worshipHadith,
      ..._characterHadith,
      ..._knowledgeHadith,
    ];
    try {
      return allHadith.firstWhere((h) => h.id == hadithId);
    } catch (e) {
      return null;
    }
  }

  // Faith & Belief Hadith
  static const List<HadithData> _faithHadith = [
    HadithData(
      id: 'faith-1',
      arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      transliteration: 'Innama al-a\'malu bin-niyyat',
      translation: 'Actions are judged by intentions, and every person will get what they intended.',
      source: 'Sahih al-Bukhari, 1',
    ),
    HadithData(
      id: 'faith-2',
      arabic: 'الإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً',
      transliteration: 'Al-imanu bid\'un wa sab\'un shu\'batan',
      translation: 'Faith has over seventy branches, and modesty is a branch of faith.',
      source: 'Sahih Muslim, 35',
    ),
    HadithData(
      id: 'faith-3',
      arabic: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ',
      transliteration: 'La yu\'minu ahadukum hatta yuhibba li-akhihi',
      translation: 'None of you will have faith until he wishes for his brother what he likes for himself.',
      source: 'Sahih al-Bukhari, 13',
    ),
    HadithData(
      id: 'faith-4',
      arabic: 'الطُّهُورُ شَطْرُ الإِيمَانِ',
      transliteration: 'At-tuhuru shatru al-iman',
      translation: 'Cleanliness is half of faith.',
      source: 'Sahih Muslim, 223',
    ),
    HadithData(
      id: 'faith-5',
      arabic: 'الإِيمَانُ قَوْلٌ وَعَمَلٌ',
      transliteration: 'Al-imanu qawlun wa amal',
      translation: 'Faith is what is in the heart and what is expressed by the tongue and what is done by the limbs.',
      source: 'Sahih al-Bukhari, 8',
    ),
  ];

  // Worship Hadith
  static const List<HadithData> _worshipHadith = [
    HadithData(
      id: 'worship-1',
      arabic: 'الصَّلاةُ عِمَادُ الدِّينِ',
      transliteration: 'As-salatu imadu ad-din',
      translation: 'Prayer is the pillar of religion.',
      source: 'Sunan at-Tirmidhi, 2616',
    ),
    HadithData(
      id: 'worship-2',
      arabic: 'الصَّوْمُ جُنَّةٌ',
      transliteration: 'As-sawmu junnatun',
      translation: 'Fasting is a shield.',
      source: 'Sahih al-Bukhari, 1894',
    ),
    HadithData(
      id: 'worship-3',
      arabic: 'الزَّكَاةُ طُهْرَةٌ',
      transliteration: 'Az-zakatu tuhuratun',
      translation: 'Zakat is a purification.',
      source: 'Sahih Muslim, 223',
    ),
    HadithData(
      id: 'worship-4',
      arabic: 'الْحَجُّ الْمَبْرُورُ',
      transliteration: 'Al-hajju al-mabruur',
      translation: 'An accepted Hajj has no reward except Paradise.',
      source: 'Sahih al-Bukhari, 1773',
    ),
  ];

  // Good Character Hadith
  static const List<HadithData> _characterHadith = [
    HadithData(
      id: 'character-1',
      arabic: 'أَكْمَلُ الْمُؤْمِنِينَ إِيمَانًا',
      transliteration: 'Akmalul mu\'minina imanan',
      translation: 'The most perfect believer in faith is the one who is best in character.',
      source: 'Sunan at-Tirmidhi, 1162',
    ),
    HadithData(
      id: 'character-2',
      arabic: 'الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ',
      transliteration: 'Ar-rahimuna yarhamuhum ar-Rahman',
      translation: 'The merciful will be shown mercy by the Most Merciful.',
      source: 'Sunan at-Tirmidhi, 1924',
    ),
    HadithData(
      id: 'character-3',
      arabic: 'لاَ تَحْقِرَنَّ مِنَ الْمَعْرُوفِ شَيْئًا',
      transliteration: 'La tahqiranna min al-ma\'rufi shay\'an',
      translation: 'Do not belittle any good deed, even meeting your brother with a cheerful face.',
      source: 'Sahih Muslim, 2626',
    ),
    HadithData(
      id: 'character-4',
      arabic: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ',
      transliteration: 'Al-muslimu man salima al-muslimuna',
      translation: 'A Muslim is one from whose tongue and hand Muslims are safe.',
      source: 'Sahih al-Bukhari, 10',
    ),
    HadithData(
      id: 'character-5',
      arabic: 'خَيْرُ النَّاسِ أَنْفَعُهُمْ',
      transliteration: 'Khayru an-nasi anfa\'uhum',
      translation: 'The best of people are those who are most beneficial to others.',
      source: 'Musnad Ahmad, 21693',
    ),
  ];

  // Knowledge Hadith
  static const List<HadithData> _knowledgeHadith = [
    HadithData(
      id: 'knowledge-1',
      arabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ',
      transliteration: 'Talabu al-ilmi faridatun',
      translation: 'Seeking knowledge is obligatory upon every Muslim.',
      source: 'Sunan Ibn Majah, 224',
    ),
    HadithData(
      id: 'knowledge-2',
      arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا',
      transliteration: 'Man salaka tariqan yaltamisu fihi ilman',
      translation: 'Whoever travels a path in search of knowledge, Allah will make easy for him a path to Paradise.',
      source: 'Sahih Muslim, 2699',
    ),
    HadithData(
      id: 'knowledge-3',
      arabic: 'إِنَّ اللَّهَ وَمَلائِكَتَهُ',
      transliteration: 'Inna Allaha wa mala\'ikatahu',
      translation: 'Allah, His angels, and all those in the heavens and on earth send blessings upon the one who teaches people good.',
      source: 'Sunan at-Tirmidhi, 2685',
    ),
    HadithData(
      id: 'knowledge-4',
      arabic: 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا',
      transliteration: 'Man yuridillahu bihi khayran',
      translation: 'When Allah wishes good for someone, He gives him understanding of the religion.',
      source: 'Sahih al-Bukhari, 71',
    ),
  ];
}
