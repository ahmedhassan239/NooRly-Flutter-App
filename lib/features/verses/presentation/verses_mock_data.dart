import 'package:flutter/material.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Mock data for Verses Hub page

class VersesMockData {
  VersesMockData._();

  static const List<VerseCategory> categories = [
    VerseCategory(
      id: 'saved',
      title: 'Saved Verses',
      subtitle: '0 saved',
      icon: LucideIcons.bookmark,
      iconColor: AppColors.primary,
    ),
    VerseCategory(
      id: 'mercy',
      title: 'Mercy & Compassion',
      subtitle: '4 verses',
      icon: LucideIcons.heart,
      iconColor: AppColors.accentCoral,
    ),
    VerseCategory(
      id: 'patience',
      title: 'Patience & Perseverance',
      subtitle: '4 verses',
      icon: LucideIcons.leaf,
      iconColor: AppColors.accentGreen,
    ),
    VerseCategory(
      id: 'guidance',
      title: 'Guidance & Light',
      subtitle: '4 verses',
      icon: LucideIcons.bird,
      iconColor: AppColors.accentGold,
    ),
    VerseCategory(
      id: 'gratitude',
      title: 'Gratitude & Blessings',
      subtitle: '4 verses',
      icon: LucideIcons.heart,
      iconColor: AppColors.accentGreen,
    ),
  ];
}

class VerseCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const VerseCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Verse data model
class VerseData {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;

  const VerseData({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
  });
}

/// Get verses for a specific category
extension VersesMockDataExtension on VersesMockData {
  static List<VerseData> getVersesByCategory(String categoryId) {
    switch (categoryId) {
      case 'mercy':
        return _mercyVerses;
      case 'patience':
        return _patienceVerses;
      case 'guidance':
        return _guidanceVerses;
      case 'gratitude':
        return _gratitudeVerses;
      default:
        return [];
    }
  }

  static VerseCategory? getCategoryById(String categoryId) {
    try {
      return VersesMockData.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  static VerseData? getVerseById(String verseId) {
    final allVerses = [
      ..._mercyVerses,
      ..._patienceVerses,
      ..._guidanceVerses,
      ..._gratitudeVerses,
    ];
    try {
      return allVerses.firstWhere((v) => v.id == verseId);
    } catch (e) {
      return null;
    }
  }

  // Mercy & Compassion Verses
  static const List<VerseData> _mercyVerses = [
    VerseData(
      id: 'mercy-1',
      arabic: 'وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ',
      transliteration: 'Wa rahmatī wasi\'at kulla shay\'',
      translation: 'And My mercy encompasses all things.',
      source: 'Al-A\'raf 7:156',
    ),
    VerseData(
      id: 'mercy-2',
      arabic: 'وَاللَّهُ رَءُوفٌ رَحِيمٌ',
      transliteration: 'Wallahu Ra\'ufun Rahim',
      translation: 'And Allah is Kind and Merciful to the believers.',
      source: 'At-Tawbah 9:117',
    ),
    VerseData(
      id: 'mercy-3',
      arabic: 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ',
      transliteration: 'Wa ma arsalnaka illa rahmatan lil-alamin',
      translation: 'And We have not sent you, [O Muhammad], except as a mercy to the worlds.',
      source: 'Al-Anbiya 21:107',
    ),
    VerseData(
      id: 'mercy-4',
      arabic: 'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ',
      transliteration: 'Qul ya ibadiyalladhina asrafu ala anfusihim la taqnutu min rahmatillah',
      translation: 'Say, "O My servants who have transgressed against themselves [by sinning], do not despair of the mercy of Allah."',
      source: 'Az-Zumar 39:53',
    ),
  ];

  // Patience & Perseverance Verses
  static const List<VerseData> _patienceVerses = [
    VerseData(
      id: 'patience-1',
      arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      transliteration: 'Inna ma\'al usri yusra',
      translation: 'Indeed, with hardship comes ease.',
      source: 'Ash-Sharh 94:6',
    ),
    VerseData(
      id: 'patience-2',
      arabic: 'وَاصْبِرْ وَمَا صَبْرُكَ إِلَّا بِاللَّهِ',
      transliteration: 'Wasbir wa ma sabruka illa billah',
      translation: 'And be patient, for your patience is only through Allah.',
      source: 'An-Nahl 16:127',
    ),
    VerseData(
      id: 'patience-3',
      arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
      transliteration: 'Ya ayyuhalladhina amanusta\'inu bis-sabri was-salah',
      translation: 'O you who believe, seek help through patience and prayer.',
      source: 'Al-Baqarah 2:153',
    ),
    VerseData(
      id: 'patience-4',
      arabic: 'إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُم بِغَيْرِ حِسَابٍ',
      transliteration: 'Innama yuwaffas-sabiruna ajrahum bighayri hisab',
      translation: 'Indeed, the patient will be given their reward without account.',
      source: 'Az-Zumar 39:10',
    ),
  ];

  // Guidance & Light Verses
  static const List<VerseData> _guidanceVerses = [
    VerseData(
      id: 'guidance-1',
      arabic: 'اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ',
      transliteration: 'Allahu nuru as-samawati wal-ard',
      translation: 'Allah is the Light of the heavens and the earth.',
      source: 'An-Nur 24:35',
    ),
    VerseData(
      id: 'guidance-2',
      arabic: 'وَمَن يَهْدِ اللَّهُ فَهُوَ الْمُهْتَدِ',
      transliteration: 'Wa man yahdillahu fahuwa al-muhtad',
      translation: 'And whoever Allah guides - he is the [rightly] guided.',
      source: 'Al-A\'raf 7:178',
    ),
    VerseData(
      id: 'guidance-3',
      arabic: 'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
      transliteration: 'Inna hadha al-Qur\'ana yahdi lillati hiya aqwam',
      translation: 'Indeed, this Qur\'an guides to that which is most suitable.',
      source: 'Al-Isra 17:9',
    ),
    VerseData(
      id: 'guidance-4',
      arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
      transliteration: 'Wa man yattaqillaha yaj\'al lahu makhrajan',
      translation: 'And whoever fears Allah - He will make for him a way out.',
      source: 'At-Talaq 65:2',
    ),
  ];

  // Gratitude & Blessings Verses
  static const List<VerseData> _gratitudeVerses = [
    VerseData(
      id: 'gratitude-1',
      arabic: 'وَإِن تَعُدُّوا نِعْمَةَ اللَّهِ لَا تُحْصُوهَا',
      transliteration: 'Wa in ta\'uddu ni\'mata Allahi la tuhsuha',
      translation: 'And if you should count the favors of Allah, you could not enumerate them.',
      source: 'Ibrahim 14:34',
    ),
    VerseData(
      id: 'gratitude-2',
      arabic: 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
      transliteration: 'La\'in shakartum la\'azidannakum',
      translation: 'If you are grateful, I will surely increase you [in favor].',
      source: 'Ibrahim 14:7',
    ),
    VerseData(
      id: 'gratitude-3',
      arabic: 'وَمَن يَشْكُرْ فَإِنَّمَا يَشْكُرُ لِنَفْسِهِ',
      transliteration: 'Wa man yashkur fa\'innama yashkuru li-nafsih',
      translation: 'And whoever is grateful - his gratitude is only for [the benefit of] himself.',
      source: 'An-Naml 27:40',
    ),
    VerseData(
      id: 'gratitude-4',
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      transliteration: 'Fadhkuruni adhkurkum',
      translation: 'So remember Me; I will remember you.',
      source: 'Al-Baqarah 2:152',
    ),
  ];
}
