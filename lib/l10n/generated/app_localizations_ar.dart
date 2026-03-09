// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رحلة النور';

  @override
  String get welcomeTitle => 'مرحباً برحلة النور';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get otpTitle => 'التحقق من البريد الإلكتروني';

  @override
  String otpSubtitle(String email) {
    return 'أدخل الرمز المكون من 6 أرقام المرسل إلى $email';
  }

  @override
  String get otpResend => 'إعادة إرسال الرمز';

  @override
  String otpResendIn(int seconds) {
    return 'إعادة الإرسال خلال $secondsث';
  }

  @override
  String get otpInvalid => 'رمز غير صحيح. يرجى المحاولة مرة أخرى.';

  @override
  String get otpExpired => 'انتهت صلاحية الرمز. يرجى طلب رمز جديد.';

  @override
  String get otpTooManyRequests =>
      'طلبات كثيرة جداً. يرجى الانتظار والمحاولة لاحقاً.';

  @override
  String get otpVerified => 'تم التحقق من البريد الإلكتروني بنجاح!';

  @override
  String get otpVerifyButton => 'تحقق';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navJourney => 'رحلتي';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navProfile => 'ملفي';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionSignIn => 'تسجيل الدخول';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionSaveChanges => 'حفظ التغييرات';

  @override
  String get actionExport => 'تصدير';

  @override
  String get actionSend => 'إرسال';

  @override
  String get actionOpen => 'فتح';

  @override
  String get actionCopy => 'نسخ';

  @override
  String get copiedToClipboard => 'تم النسخ!';

  @override
  String get homeGreeting => 'السلام عليكم';

  @override
  String get homeEncouragement => 'أنت تسير بشكل رائع. كل خطوة تُحسب.';

  @override
  String get homeFriendFallback => 'صديقي';

  @override
  String get homeExitTitle => 'الخروج من التطبيق؟';

  @override
  String get homeExitContent => 'هل تريد الخروج من نُورلي؟';

  @override
  String get homeExitConfirm => 'خروج';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get setLocationForTimes => 'حدد موقعك لمعرفة الأوقات';

  @override
  String get yourJourney => 'رحلتك';

  @override
  String get noLessonRightNow => 'لا يوجد درس الآن';

  @override
  String get viewJourney => 'عرض الرحلة';

  @override
  String get signInToContinueLessons => 'سجل دخولك لمتابعة دروسك';

  @override
  String get journeyErrorSession => 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get journeyErrorLoad =>
      'تعذّر تحميل الدرس. حاول مرة أخرى أو افتح رحلتك.';

  @override
  String journeyWeekDayLabel(int week, int day) {
    return 'الأسبوع $week / اليوم $day';
  }

  @override
  String journeyDayLabel(int day) {
    return 'اليوم $day';
  }

  @override
  String journeyDurationMinRead(int duration) {
    return '$duration دقيقة قراءة';
  }

  @override
  String get todaysFocus => 'تركيز اليوم';

  @override
  String get continueYourLesson => 'تابع درسك';

  @override
  String get takeTwoMinutesForDhikr => 'خصص دقيقتين للذكر';

  @override
  String get prepareForNextPrayer => 'استعد للصلاة القادمة';

  @override
  String get ramadanIsHere => 'رمضان قادم';

  @override
  String get prepareForTheBlessedMonth => 'استعد للشهر الكريم';

  @override
  String get startRamadanGuide => 'ابدأ دليل رمضان';

  @override
  String get journeyTitle => 'رحلتك';

  @override
  String get journeyLearningPath => 'مسار تعلم 90 يوماً';

  @override
  String get journeyStatProgress => 'التقدم';

  @override
  String get journeyStatDone => 'منجز';

  @override
  String get journeyStatCurrent => 'الحالي';

  @override
  String get journeyOverallProgress => 'التقدم الإجمالي';

  @override
  String get journeyEncouragement => 'واصل المسير! أنت تبلي حسناً!';

  @override
  String get journeyCouldNotLoad => 'تعذّر تحميل الرحلة';

  @override
  String get journeyCompletePreviousFirst => 'أكمل الدروس السابقة أولاً.';

  @override
  String get prayerNotificationsMuted => 'تم كتم الإشعارات';

  @override
  String get prayerNotificationsEnabled => 'تم تفعيل الإشعارات';

  @override
  String get prayerNotificationPermissionRequired =>
      'إذن الإشعارات مطلوب. يرجى تفعيله في الإعدادات.';

  @override
  String get prayerGettingLocation => 'جارٍ تحديد الموقع...';

  @override
  String get prayerTodaysPrayers => 'صلوات اليوم';

  @override
  String get prayerNoPrayerTimesForLocation => 'لا توجد أوقات صلاة لهذا الموقع';

  @override
  String get prayerLocationUnavailable => 'الموقع غير متاح';

  @override
  String get prayerEnterCityHint => 'أدخل المدينة والبلد (مثال: القاهرة، مصر)';

  @override
  String get prayerLocationPermissionDeniedForever =>
      'تم رفض إذن الموقع بشكل دائم. افتح إعدادات التطبيق لتفعيله.';

  @override
  String get prayerOpenSettings => 'فتح الإعدادات';

  @override
  String get prayerLocationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get prayerLocationServicesDisabled => 'خدمات الموقع معطّلة';

  @override
  String get prayerLocationUpdated => 'تم تحديث الموقع';

  @override
  String get prayerUseCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get prayerLocationRefreshed => 'تم تحديث الموقع';

  @override
  String get prayerRefreshLocation => 'تحديث الموقع';

  @override
  String get prayerUseAddress => 'استخدام العنوان';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileYourProgress => 'تقدمك';

  @override
  String get profileStreakLabel => 'تتالي';

  @override
  String get profileDaysLabel => 'أيام';

  @override
  String get profileActiveLabel => 'نشاط';

  @override
  String get profileWeeksLabel => 'أسابيع';

  @override
  String get profileLeftLabel => 'متبقي';

  @override
  String get profileCouldNotLoadProgress => 'تعذّر تحميل التقدم';

  @override
  String get profileJourneyProgress => 'تقدم الرحلة';

  @override
  String profileLessonsCompleted(int count) {
    return '$count دروس مكتملة';
  }

  @override
  String profilePercentComplete(int percent) {
    return '$percent% مكتمل';
  }

  @override
  String get profileMilestones => 'الإنجازات';

  @override
  String profileWeekComplete(int week) {
    return 'الأسبوع $week مكتمل';
  }

  @override
  String get profileNoMilestonesYet => 'لا توجد إنجازات بعد';

  @override
  String get profileInProgress => '(جارٍ)';

  @override
  String get profileNotSet => 'غير محدد';

  @override
  String get profilePersonalInfo => 'المعلومات الشخصية';

  @override
  String get profileLabelName => 'الاسم';

  @override
  String get profileLabelEmail => 'البريد الإلكتروني';

  @override
  String get profileLabelGender => 'الجنس';

  @override
  String get profileLabelBirthDate => 'تاريخ الميلاد';

  @override
  String get profileLabelLocale => 'اللغة';

  @override
  String get profileLabelShahadaDate => 'تاريخ الشهادة';

  @override
  String get profileLabelLearningGoals => 'أهداف التعلم';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileQuickActions => 'إجراءات سريعة';

  @override
  String get profileSavedDuas => 'الأدعية المحفوظة';

  @override
  String get profileViewSavedDuas => 'عرض مجموعة أدعيتك المحفوظة';

  @override
  String get profileYourReflections => 'تأملاتك';

  @override
  String get profileReviewReflections => 'راجع تأملات دروسك';

  @override
  String get profileManagePreferences => 'إدارة تفضيلات التطبيق';

  @override
  String get profileLogOut => 'تسجيل الخروج';

  @override
  String get profileLogOutTitle => 'تسجيل الخروج';

  @override
  String get profileLogOutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String profileDayOfTotal(int day, int total) {
    return 'اليوم $day من $total';
  }

  @override
  String get libraryTitle => 'المكتبة';

  @override
  String get libraryNoTabsAvailable => 'لا تتوفر تبويبات المكتبة';

  @override
  String get libraryDuas => 'أدعية';

  @override
  String get libraryHadith => 'أحاديث';

  @override
  String get libraryVerses => 'آيات';

  @override
  String get libraryAdhkar => 'أذكار';

  @override
  String get libraryNoCollectionsYet => 'لا توجد مجموعات بعد';

  @override
  String get libraryNoAdhkarCategoriesYet => 'لا توجد فئات أذكار بعد';

  @override
  String get searchDuas => 'ابحث في الأدعية...';

  @override
  String get searchHadith => 'ابحث في الأحاديث...';

  @override
  String get searchVerses => 'ابحث في الآيات...';

  @override
  String get searchAdhkar => 'ابحث في الأذكار...';

  @override
  String savedCountLabel(int count) {
    return '$count محفوظ';
  }

  @override
  String itemCountDuas(int count) {
    return '$count دعاء';
  }

  @override
  String itemCountHadith(int count) {
    return '$count حديث';
  }

  @override
  String itemCountVerses(int count) {
    return '$count آية';
  }

  @override
  String itemCountAdhkar(int count) {
    return '$count ذكر';
  }

  @override
  String get savedCardDuas => 'الأدعية المحفوظة';

  @override
  String get savedCardHadith => 'الأحاديث المحفوظة';

  @override
  String get savedCardVerses => 'الآيات المحفوظة';

  @override
  String get savedCardAdhkar => 'الأذكار المحفوظة';

  @override
  String get prayerSchedule => 'جدول الصلاة';

  @override
  String get dailyProgress => 'التقدم اليومي';

  @override
  String get prayerRemaining => 'متبقي';

  @override
  String get prayerMissed => 'فائتة';

  @override
  String get prayerCompleted => 'مكتملة';

  @override
  String get prayerDone => 'منجز';

  @override
  String get prayerNext => 'القادمة';

  @override
  String get prayerUpcoming => 'قادمة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get remainingNow => 'الآن';

  @override
  String remainingInMinutes(int minutes) {
    return 'خلال $minutes د';
  }

  @override
  String remainingInHours(int hours) {
    return 'خلال $hours س';
  }

  @override
  String remainingInHoursMinutes(int hours, int minutes) {
    return 'خلال $hours س $minutes د';
  }

  @override
  String get needHelpNow => 'تحتاج مساعدة الآن؟';

  @override
  String get quickSupportWhenYouNeedIt => 'دعم سريع عندما تحتاجه';

  @override
  String get dailyInspiration => 'إلهام اليوم';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noDailyInspiration => 'لا يوجد إلهام يومي متاح حالياً.';

  @override
  String get actionListen => 'استماع';

  @override
  String get actionShare => 'مشاركة';

  @override
  String get actionSaved => 'محفوظ';

  @override
  String get savedToFavorites => 'تم الحفظ في المفضلة';

  @override
  String get removedFromSaved => 'تمت الإزالة من المحفوظات';

  @override
  String get couldNotUpdateSavedState => 'تعذّر تحديث الحالة. حاول مرة أخرى.';

  @override
  String get loginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get pleaseSignInToSave => 'سجّل دخولك لحفظ العناصر في المفضلة.';

  @override
  String get duasSearchHint => 'ابحث في الأدعية...';

  @override
  String get duasCouldNotLoadCategories => 'تعذّر تحميل الفئات';

  @override
  String get duasNoCategoriesYet => 'لا توجد فئات بعد';

  @override
  String get duasNoDuasFound => 'لم يتم العثور على أدعية';

  @override
  String get duasSavedDuas => 'الأدعية المحفوظة';

  @override
  String get duasYourSavedDuas => 'أدعيتك المحفوظة';

  @override
  String duasCountLabel(int count) {
    return '$count دعاء';
  }

  @override
  String get savedTitle => 'المحفوظات';

  @override
  String get savedSignInToView => 'سجل دخولك لعرض العناصر المحفوظة';

  @override
  String get savedTabAll => 'الكل';

  @override
  String get savedTabDuas => 'أدعية';

  @override
  String get savedTabAdhkar => 'أذكار';

  @override
  String get savedTabVerses => 'آيات';

  @override
  String get savedTabHadith => 'أحاديث';

  @override
  String get savedNoItems => 'لا توجد عناصر محفوظة';

  @override
  String get savedEmptyHint => 'احفظ العناصر من المكتبة لتراها هنا.';

  @override
  String get savedNoSearchResults => 'لا توجد عناصر تطابق البحث';

  @override
  String get savedCouldNotLoad => 'تعذّر تحميل المحفوظات';

  @override
  String get savedSyncedToAccount => 'عناصرك المحفوظة مزامنة مع حسابك.';

  @override
  String get savedTypeDua => 'دعاء';

  @override
  String get savedTypeAdhkar => 'ذكر';

  @override
  String get savedTypeHadith => 'حديث';

  @override
  String get savedTypeVerse => 'آية';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileTapToChange => 'اضغط لتغيير الصورة';

  @override
  String get editProfileNameLabel => 'الاسم';

  @override
  String get editProfileNameHint => 'أدخل اسمك';

  @override
  String get editProfileShahadaDateLabel => 'تاريخ الشهادة (اختياري)';

  @override
  String get editProfileShahadaHelper => 'متى أعلنت شهادتك؟';

  @override
  String get editProfileSelectDate => 'اختر تاريخاً';

  @override
  String get editProfileSaveChanges => 'حفظ التغييرات';

  @override
  String get editProfileTakePhoto => 'التقاط صورة';

  @override
  String get editProfileCameraComingSoon => 'ميزة الكاميرا قريباً';

  @override
  String get editProfileChooseFromGallery => 'اختيار من المعرض';

  @override
  String get editProfileGalleryComingSoon => 'اختيار من المعرض قريباً';

  @override
  String get editProfileEnterNameError => 'يرجى إدخال اسمك';

  @override
  String get editProfileSavedSuccess => 'تم حفظ الملف الشخصي بنجاح!';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsPrayerReminders => 'تذكيرات الصلاة';

  @override
  String get settingsDailyLesson => 'الدرس اليومي';

  @override
  String get settingsMilestoneAlerts => 'تنبيهات الإنجازات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsUseDarkTheme => 'استخدام السمة الداكنة';

  @override
  String get settingsFontSize => 'حجم الخط';

  @override
  String get settingsFontSizeSubtitle => 'ضبط حجم النص';

  @override
  String get settingsPrayerTimes => 'أوقات الصلاة';

  @override
  String get settingsCalculationMethod => 'طريقة الحساب';

  @override
  String get settingsDefaultMadhab => 'المذهب الافتراضي';

  @override
  String get settingsAdjustTimes => 'ضبط الأوقات';

  @override
  String get settingsAdjustTimesSubtitle => 'ضبط أوقات الصلاة ±5 دقائق';

  @override
  String get settingsPrivacyData => 'الخصوصية والبيانات';

  @override
  String get settingsExportMyData => 'تصدير بياناتي';

  @override
  String get settingsExportMyDataSubtitle => 'تنزيل كل تقدمك';

  @override
  String get settingsDeleteAllData => 'حذف جميع البيانات';

  @override
  String get settingsDeleteAllDataSubtitle => 'حذف كل شيء نهائياً';

  @override
  String get settingsAbout => 'حول';

  @override
  String get settingsApp => 'التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsHelpSupport => 'المساعدة والدعم';

  @override
  String get settingsSendFeedback => 'إرسال ملاحظات';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get dialogExternalLinkTitle => 'رابط خارجي';

  @override
  String get dialogExternalLinkContent => 'سيتم الفتح في المتصفح:';

  @override
  String get dialogOpeningInBrowser => 'جاري الفتح في المتصفح...';

  @override
  String get dialogDeleteAllDataTitle => 'حذف جميع البيانات';

  @override
  String get dialogDeleteAllDataContent =>
      'سيؤدي هذا إلى حذف جميع تقدمك وتأملاتك ومحتواك المحفوظ نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get dialogDataDeletedSuccess => 'تم حذف جميع البيانات بنجاح';

  @override
  String get dialogExportTitle => 'تصدير بياناتي';

  @override
  String get dialogExportContent => 'سيتضمن تصدير بياناتك:';

  @override
  String get dialogExportPreparing => 'جاري تحضير تصدير بياناتك...';

  @override
  String get dialogExportSuccess =>
      'تم تصدير البيانات بنجاح! تحقق من التنزيلات.';

  @override
  String get dialogFeedbackTitle => 'إرسال ملاحظات';

  @override
  String get dialogFeedbackContent =>
      'يسعدنا سماع رأيك! شاركنا أفكارك واقتراحاتك أو أبلغنا عن المشكلات.';

  @override
  String get dialogFeedbackHint => 'اكتب ملاحظاتك هنا...';

  @override
  String get dialogFeedbackThanks => 'شكراً على ملاحظاتك!';

  @override
  String get dialogAdjustTimesTitle => 'ضبط أوقات الصلاة';

  @override
  String get dialogAdjustTimesContent =>
      'ضبط أوقات الصلاة الفردية بمقدار ±5 دقائق';

  @override
  String get dialogPrayerTimesAdjusted => 'تم ضبط أوقات الصلاة';

  @override
  String get darkModeEnabled => 'تم تفعيل الوضع الداكن';

  @override
  String get lightModeEnabled => 'تم تفعيل الوضع الفاتح';

  @override
  String languageChanged(String language) {
    return 'اللغة: $language';
  }

  @override
  String get listenComingSoon => 'الاستماع — قريباً';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get goHome => 'الصفحة الرئيسية';

  @override
  String get needHelp => 'تحتاج مساعدة؟';

  @override
  String get startupFailed => 'فشل التشغيل';

  @override
  String get startupPleaseReopen => 'يرجى إغلاق التطبيق وإعادة فتحه.';
}
