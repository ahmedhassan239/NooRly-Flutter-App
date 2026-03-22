/// Mock data for lesson content
/// This contains the full content for each lesson in the 60-day journey

class LessonContentData {
  LessonContentData._();

  static LessonContent? getLessonByDay(int dayNumber) {
    return _lessons[dayNumber];
  }

  static final Map<int, LessonContent> _lessons = {
    1: LessonContent(
      dayNumber: 1,
      weekNumber: 1,
      title: 'Welcome to Islam',
      subtitle: 'Begin your beautiful journey into the faith',
      duration: '3 min read',
      category: 'Faith',
      whatYouWillLearn: [
        'Understanding the core concepts of welcome to islam',
        'Practical steps you can apply in daily life',
        'Quranic verses and hadith references',
      ],
      sections: [
        LessonSection(
          title: null,
          content:
              "Assalamu Alaikum (Peace be upon you)! Welcome to the most beautiful journey of your life.",
        ),
        LessonSection(
          title: 'What is Islam?',
          icon: '📖',
          content:
              'Islam is a complete way of life, a path of peace, purpose, and connection with your Creator. The word "Islam" comes from the Arabic root "s-l-m," which means peace and submission to the will of Allah (God).',
        ),
        LessonSection(
          title: 'Your New Beginning',
          icon: '💡',
          content:
              'Taking the Shahada (declaration of faith) is like being reborn. All your past mistakes are forgiven, and you start with a clean slate. This is one of the beautiful mercies of Allah.',
        ),
      ],
      quranVerseOrHadith: QuoteData(
        type: 'QURANIC VERSE / HADITH',
        text:
            '"Say, \'O My servants who have transgressed against themselves, do not despair of the mercy of Allah. Indeed, Allah forgives all sins. Indeed, it is He who is the Forgiving, the Merciful.\'"',
        reference: 'Quran 39:53',
      ),
      whatToExpect: WhatToExpectData(
        intro: "Over the next 60 days, we'll guide you through:",
        items: [
          'Core beliefs — Understanding who Allah is and what Islam teaches',
          'Prayer (Salah) — Learning how to connect with Allah five times daily',
          'Quran — Beginning your relationship with Allah\'s words',
          'Daily habits — Building a life of purpose and remembrance',
        ],
        outro:
            "Take your time. There's no rush. Allah brought you here at exactly the right moment.",
        closingMessage: 'Welcome home. 💚',
      ),
      keyTakeaways: [
        'Take your time to absorb these concepts',
        'Practice what you learn in daily life',
        'Ask questions if anything is unclear',
      ],
      reflectionPrompt:
          'Write your thoughts, questions, or how you plan to apply this lesson... (optional)',
    ),
    2: LessonContent(
      dayNumber: 2,
      weekNumber: 1,
      title: 'The Meaning of Shahada',
      subtitle: 'Understanding the declaration of faith',
      duration: '5 min read',
      category: 'Faith',
      whatYouWillLearn: [
        'The two parts of the Shahada explained',
        'What it means to bear witness',
        'How the Shahada changes your life',
      ],
      sections: [
        LessonSection(
          title: null,
          content:
              "The Shahada is the first pillar of Islam and the foundation of your faith. Let's explore its deep meaning.",
        ),
        LessonSection(
          title: 'The Two Testimonies',
          icon: '🌙',
          content:
              'The Shahada consists of two parts: "Ash-hadu an la ilaha illa Allah" (I bear witness that there is no god but Allah) and "wa ash-hadu anna Muhammadan rasul Allah" (and I bear witness that Muhammad is the Messenger of Allah).',
        ),
        LessonSection(
          title: 'A Covenant with Allah',
          icon: '💎',
          content:
              'When you said the Shahada, you entered into a covenant with Allah. This is a promise to worship Him alone and to follow the guidance brought by Prophet Muhammad (peace be upon him).',
        ),
      ],
      quranVerseOrHadith: QuoteData(
        type: 'HADITH',
        text:
            '"Islam is built on five pillars: the testimony that there is no god but Allah and that Muhammad is His Messenger, establishing prayer, giving Zakat, performing Hajj, and fasting Ramadan."',
        reference: 'Sahih Bukhari',
      ),
      whatToExpect: null,
      keyTakeaways: [
        'The Shahada is your entry into Islam',
        'It represents a covenant with Allah',
        'Understanding its meaning strengthens faith',
      ],
      reflectionPrompt:
          'What does the Shahada mean to you personally? How has saying it changed your perspective?',
    ),
  };
}

class LessonContent {
  final int dayNumber;
  final int weekNumber;
  final String title;
  final String subtitle;
  final String duration;
  final String category;
  final List<String> whatYouWillLearn;
  final List<LessonSection> sections;
  final QuoteData? quranVerseOrHadith;
  final WhatToExpectData? whatToExpect;
  final List<String> keyTakeaways;
  final String reflectionPrompt;

  const LessonContent({
    required this.dayNumber,
    required this.weekNumber,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.category,
    required this.whatYouWillLearn,
    required this.sections,
    this.quranVerseOrHadith,
    this.whatToExpect,
    required this.keyTakeaways,
    required this.reflectionPrompt,
  });
}

class LessonSection {
  final String? title;
  final String? icon;
  final String content;

  const LessonSection({
    this.title,
    this.icon,
    required this.content,
  });
}

class QuoteData {
  final String type;
  final String text;
  final String reference;

  const QuoteData({
    required this.type,
    required this.text,
    required this.reference,
  });
}

class WhatToExpectData {
  final String intro;
  final List<String> items;
  final String outro;
  final String closingMessage;

  const WhatToExpectData({
    required this.intro,
    required this.items,
    required this.outro,
    required this.closingMessage,
  });
}
