/// Centralized localized strings for all local notification content.
///
/// Use [localeCode] `ar` or `en`. Avoids duplicated hardcoded strings across schedulers.
library;

/// Localized notification content. [localeCode] must be `ar` or `en` (defaults to `en`).
class NotificationContentLocalizer {
  const NotificationContentLocalizer([this.localeCode = 'en'])
      : assert(localeCode == 'ar' || localeCode == 'en');

  final String localeCode;

  bool get isArabic => localeCode == 'ar';

  // ── Test notification ────────────────────────────────────────────────────

  String get testNotificationTitle =>
      isArabic ? 'اختبار إشعارات نورلي' : 'Test Noorly Notification';

  String get testNotificationBody => isArabic
      ? 'إذا وصلتك هذه الإشعارية، فالإشعارات تعمل بشكل صحيح.'
      : 'If you see this notification, notifications are working correctly.';

  // ── Prayer reminders ─────────────────────────────────────────────────────

  String prayerTitle(String prayerName) {
    if (isArabic) {
      return switch (prayerName) {
        'fajr' => '🌅 حان وقت صلاة الفجر',
        'dhuhr' => '☀️ حان وقت صلاة الظهر',
        'asr' => '🌤️ حان وقت صلاة العصر',
        'maghrib' => '🌆 حان وقت صلاة المغرب',
        'isha' => '🌙 حان وقت صلاة العشاء',
        _ => '',
      };
    }
    return switch (prayerName) {
      'fajr' => "🌅 It's Time for Fajr Prayer",
      'dhuhr' => "☀️ It's Time for Dhuhr Prayer",
      'asr' => "🌤️ It's Time for Asr Prayer",
      'maghrib' => "🌆 It's Time for Maghrib Prayer",
      'isha' => "🌙 It's Time for Isha Prayer",
      _ => '',
    };
  }

  String prayerBody(String prayerName) {
    if (isArabic) {
      return switch (prayerName) {
        'fajr' => '"الصلاة خير من النوم"',
        'dhuhr' => 'لا تنسَ صلاة الظهر اليوم',
        'asr' => 'وقت العصر دخل، توضأ وصلِّ',
        'maghrib' => 'أذان المغرب الآن',
        'isha' => 'صلِّ العشاء قبل النوم',
        _ => '',
      };
    }
    return switch (prayerName) {
      'fajr' => '"Prayer is better than sleep"',
      'dhuhr' => "Don't forget your Dhuhr prayer today",
      'asr' => 'Asr time has entered, make wudu and pray',
      'maghrib' => 'Maghrib Adhan is now',
      'isha' => 'Pray Isha before sleep',
      _ => '',
    };
  }

  // ── Adhkar ───────────────────────────────────────────────────────────────

  String get morningAdhkarTitle => isArabic ? '☀️ أذكار الصباح' : '☀️ Morning Adhkar';

  String get morningAdhkarBody => isArabic
      ? 'لا تنسَ أذكار الصباح اليوم\nاضغط للقراءة الآن'
      : "Don't forget your morning remembrances\nTap to read now";

  String get eveningAdhkarTitle => isArabic ? '🌙 أذكار المساء' : '🌙 Evening Adhkar';

  String get eveningAdhkarBody => isArabic
      ? 'حان وقت أذكار المساء\nاضغط للقراءة الآن'
      : "It's time for evening remembrances\nTap to read now";

  String get sleepAdhkarTitle => isArabic ? '😴 أذكار النوم' : '😴 Sleep Adhkar';

  String get sleepAdhkarBody => isArabic
      ? 'لا تنم قبل قراءة أذكار النوم\nاضغط للقراءة الآن'
      : "Don't sleep before reading sleep remembrances\nTap to read now";

  static const _randomDhikrTitlesEn = [
    '💚 Spiritual Reminder',
    '💚 Remember Allah',
    '💚 A Moment of Reflection',
  ];
  static const _randomDhikrBodiesEn = [
    'Glory is to Allah and praise is to Him\nSubhan Allahi wa bihamdihi',
    'There is no power except with Allah\nLa hawla wala quwwata illa billah',
    'Allah is the Greatest\nAllahu Akbar',
  ];
  static const _randomDhikrTitlesAr = [
    '💚 تذكير روحي',
    '💚 اذكر الله',
    '💚 لحظة تأمل',
  ];
  static const _randomDhikrBodiesAr = [
    'سُبْحَانَ اللهِ وَبِحَمْدِهِ\nSubhan Allahi wa bihamdihi',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ\nLa hawla wala quwwata illa billah',
    'اللهُ أَكْبَر\nAllahu Akbar',
  ];

  String randomDhikrTitle(int index) {
    final i = index % _randomDhikrTitlesEn.length;
    return isArabic ? _randomDhikrTitlesAr[i] : _randomDhikrTitlesEn[i];
  }

  String randomDhikrBody(int index) {
    final i = index % _randomDhikrBodiesEn.length;
    return isArabic ? _randomDhikrBodiesAr[i] : _randomDhikrBodiesEn[i];
  }

  // ── Lesson ──────────────────────────────────────────────────────────────

  String get lessonMorningTitle => isArabic ? '📖 درس اليوم جاهز!' : "📖 Today's Lesson is Ready!";

  String get lessonMorningBody =>
      isArabic ? 'افتح التطبيق لتبدأ درس اليوم' : "Open the app to start today's lesson";

  String lessonMorningBodyWithDay(
    int dayNumber,
    int durationMinutes,
    String titleEn,
    String titleAr,
  ) =>
      isArabic
          ? 'اليوم $dayNumber: $titleAr\n⏱️ $durationMinutes دقائق فقط'
          : 'Day $dayNumber: $titleEn\n⏱️ Just $durationMinutes minutes';

  String get lessonEveningTitle =>
      isArabic ? '⏰ لم تنهِ درس اليوم بعد' : "⏰ You Haven't Completed Today's Lesson Yet";

  String lessonEveningBody(int dayNumber, String titleEn, String titleAr) => isArabic
      ? 'لا يزال لديك وقت!\nاليوم $dayNumber: $titleAr'
      : 'You still have time!\nDay $dayNumber: $titleEn';

  // ── Occasion (Friday) ────────────────────────────────────────────────────

  String get fridayTitle => isArabic ? '🕌 الجمعة المباركة' : '🕌 Blessed Friday';

  String get fridayBody => isArabic
      ? 'لا تنسَ صلاة الجمعة اليوم\nاقرأ سورة الكهف 📖'
      : "Don't forget Jumu'ah prayer today\nRead Surah Al-Kahf 📖";
}
