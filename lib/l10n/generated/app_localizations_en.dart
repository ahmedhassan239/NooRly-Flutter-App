// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Noor Journey';

  @override
  String get welcomeTitle => 'Welcome to Noor Journey';

  @override
  String get getStarted => 'Get Started';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get otpTitle => 'Verify Email';

  @override
  String otpSubtitle(String email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get otpResend => 'Resend Code';

  @override
  String otpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get otpInvalid => 'Invalid code. Please try again.';

  @override
  String get otpExpired => 'Code expired. Please request a new one.';

  @override
  String get otpTooManyRequests =>
      'Too many requests. Please wait and try later.';

  @override
  String get otpVerified => 'Email verified successfully!';

  @override
  String get otpVerifyButton => 'Verify';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navJourney => 'Journey';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSignIn => 'Sign In';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSaveChanges => 'Save Changes';

  @override
  String get actionExport => 'Export';

  @override
  String get actionSend => 'Send';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionCopy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard!';

  @override
  String get homeGreeting => 'Assalamu Alaikum';

  @override
  String get homeEncouragement => 'You\'re doing great. Every step counts.';

  @override
  String get homeFriendFallback => 'Friend';

  @override
  String get homeExitTitle => 'Exit app?';

  @override
  String get homeExitContent => 'Do you want to exit NooRly?';

  @override
  String get homeExitConfirm => 'Exit';

  @override
  String get nextPrayer => 'Next Prayer';

  @override
  String get setLocationForTimes => 'Set location for times';

  @override
  String get yourJourney => 'YOUR JOURNEY';

  @override
  String get noLessonRightNow => 'No lesson right now';

  @override
  String get viewJourney => 'View Journey';

  @override
  String get signInToContinueLessons => 'Sign in to continue your lessons';

  @override
  String get journeyErrorSession => 'Session expired. Please sign in again.';

  @override
  String get journeyErrorLoad =>
      'Could not load your lesson. Try again or open Journey.';

  @override
  String journeyWeekDayLabel(int week, int day) {
    return 'Week $week / Day $day';
  }

  @override
  String journeyDayLabel(int day) {
    return 'Day $day';
  }

  @override
  String journeyDurationMinRead(int duration) {
    return '$duration min read';
  }

  @override
  String get todaysFocus => 'Today\'s Focus';

  @override
  String get continueYourLesson => 'Continue your lesson';

  @override
  String get takeTwoMinutesForDhikr => 'Take 2 minutes for dhikr';

  @override
  String get prepareForNextPrayer => 'Prepare for next prayer';

  @override
  String get ramadanIsHere => 'Ramadan is here';

  @override
  String get prepareForTheBlessedMonth => 'Prepare for the blessed month';

  @override
  String get startRamadanGuide => 'Start Ramadan Guide';

  @override
  String get ramadanGuideTitle => 'Ramadan Guide';

  @override
  String get ramadanGuideEmpty => 'No guide content available right now.';

  @override
  String get ramadanGuideError => 'Something went wrong. Please try again.';

  @override
  String get journeyTitle => 'Your Journey';

  @override
  String get journeyLearningPath => '90-Day Learning Path';

  @override
  String get journeyStatProgress => 'Progress';

  @override
  String get journeyStatDone => 'Done';

  @override
  String get journeyStatCurrent => 'Current';

  @override
  String get journeyOverallProgress => 'Overall Progress';

  @override
  String get journeyEncouragement => 'Keep going! You\'re doing great!';

  @override
  String get journeyCouldNotLoad => 'Could not load journey';

  @override
  String get journeyCompletePreviousFirst => 'Complete previous lessons first.';

  @override
  String journeyWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String get lessonMarkAsCompleted => 'Mark as Completed';

  @override
  String get lessonCompleted => 'Completed';

  @override
  String get lessonNextLesson => 'Next Lesson →';

  @override
  String get lessonNoMoreLessons => 'No more lessons';

  @override
  String get lessonPersonalReflection => 'Personal Reflection';

  @override
  String get lessonWriteThoughts => 'Write your thoughts...';

  @override
  String get lessonSaveReflection => 'Save reflection';

  @override
  String get lessonReflectionSaved => 'Reflection saved';

  @override
  String get lessonSaved => 'Saved';

  @override
  String get lessonRetry => 'Retry';

  @override
  String get lessonNotFound => 'Lesson not found';

  @override
  String get prayerNotificationsMuted => 'Notifications muted';

  @override
  String get prayerNotificationsEnabled => 'Notifications enabled';

  @override
  String get prayerNotificationPermissionRequired =>
      'Notification permission is required. Please enable it in settings.';

  @override
  String get prayerGettingLocation => 'Getting location...';

  @override
  String get prayerTodaysPrayers => 'TODAY\'S PRAYERS';

  @override
  String get prayerNoPrayerTimesForLocation =>
      'No prayer times for this location';

  @override
  String get prayerLocationUnavailable => 'Location unavailable';

  @override
  String get prayerEnterCityHint => 'Enter city, country (e.g. Cairo, Egypt)';

  @override
  String get prayerLocationPermissionDeniedForever =>
      'Location permission was permanently denied. Open app settings to enable it.';

  @override
  String get prayerOpenSettings => 'Open settings';

  @override
  String get prayerLocationPermissionDenied => 'Location permission denied';

  @override
  String get prayerLocationServicesDisabled => 'Location services are disabled';

  @override
  String get prayerLocationUpdated => 'Location updated';

  @override
  String get prayerUseCurrentLocation => 'Use current location';

  @override
  String get prayerLocationRefreshed => 'Location refreshed';

  @override
  String get prayerRefreshLocation => 'Refresh location';

  @override
  String get prayerUseAddress => 'Use address';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileYourProgress => 'Your Progress';

  @override
  String get profileStreakLabel => 'Streak';

  @override
  String get profileDaysLabel => 'days';

  @override
  String get profileActiveLabel => 'Active';

  @override
  String get profileWeeksLabel => 'weeks';

  @override
  String get profileLeftLabel => 'Left';

  @override
  String get profileCouldNotLoadProgress => 'Could not load progress';

  @override
  String get profileJourneyProgress => 'Journey Progress';

  @override
  String profileLessonsCompleted(int count) {
    return '$count lessons completed';
  }

  @override
  String profilePercentComplete(int percent) {
    return '$percent% complete';
  }

  @override
  String get profileMilestones => 'Milestones';

  @override
  String profileWeekComplete(int week) {
    return 'Week $week Complete';
  }

  @override
  String get profileNoMilestonesYet => 'No milestones yet';

  @override
  String get profileInProgress => '(In Progress)';

  @override
  String get profileNotSet => 'Not set';

  @override
  String get profilePersonalInfo => 'Personal Info';

  @override
  String get profileLabelName => 'Name';

  @override
  String get profileLabelEmail => 'Email';

  @override
  String get profileLabelGender => 'Gender';

  @override
  String get profileLabelBirthDate => 'Birth date';

  @override
  String get profileLabelLocale => 'Locale';

  @override
  String get profileLabelShahadaDate => 'Shahada Date';

  @override
  String get profileLabelLearningGoals => 'Learning Goals';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileQuickActions => 'Quick Actions';

  @override
  String get profileSavedDuas => 'Saved Duas';

  @override
  String get profileViewSavedDuas => 'View your saved duas collection';

  @override
  String get profileYourReflections => 'Your Reflections';

  @override
  String get profileReviewReflections => 'Review your lesson reflections';

  @override
  String get profileManagePreferences => 'Manage app preferences';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileLogOutTitle => 'Log Out';

  @override
  String get profileLogOutConfirm => 'Are you sure you want to log out?';

  @override
  String profileDayOfTotal(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryNoTabsAvailable => 'No library tabs available';

  @override
  String get libraryDuas => 'Duas';

  @override
  String get libraryHadith => 'Hadith';

  @override
  String get libraryVerses => 'Verses';

  @override
  String get libraryAdhkar => 'Adhkar';

  @override
  String get libraryNoCollectionsYet => 'No collections yet';

  @override
  String get libraryNoAdhkarCategoriesYet => 'No adhkar categories yet';

  @override
  String get searchDuas => 'Search duas...';

  @override
  String get searchHadith => 'Search hadith...';

  @override
  String get searchVerses => 'Search verses...';

  @override
  String get searchAdhkar => 'Search adhkar...';

  @override
  String savedCountLabel(int count) {
    return '$count saved';
  }

  @override
  String itemCountDuas(int count) {
    return '$count duas';
  }

  @override
  String itemCountHadith(int count) {
    return '$count hadith';
  }

  @override
  String itemCountVerses(int count) {
    return '$count verses';
  }

  @override
  String itemCountAdhkar(int count) {
    return '$count adhkar';
  }

  @override
  String sayRepetition(int count) {
    return 'Say ${count}x';
  }

  @override
  String get adhkarLabel => 'Adhkar';

  @override
  String get translationLabel => 'Translation';

  @override
  String get sourceLabel => 'Source';

  @override
  String get savedCardDuas => 'Saved Duas';

  @override
  String get savedCardHadith => 'Saved Hadith';

  @override
  String get savedCardVerses => 'Saved Verses';

  @override
  String get savedCardAdhkar => 'Saved Adhkar';

  @override
  String get prayerSchedule => 'Prayer Schedule';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String get prayerRemaining => 'Remaining';

  @override
  String get prayerMissed => 'Missed';

  @override
  String get prayerCompleted => 'Completed';

  @override
  String get prayerDone => 'Done';

  @override
  String get prayerNext => 'Next';

  @override
  String get prayerUpcoming => 'Upcoming';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get remainingNow => 'now';

  @override
  String remainingInMinutes(int minutes) {
    return 'in ${minutes}m';
  }

  @override
  String remainingInHours(int hours) {
    return 'in ${hours}h';
  }

  @override
  String remainingInHoursMinutes(int hours, int minutes) {
    return 'in ${hours}h ${minutes}m';
  }

  @override
  String get needHelpNow => 'Need Help Now?';

  @override
  String get quickSupportWhenYouNeedIt => 'Quick support when you need it';

  @override
  String get howCanWeHelp => 'How Can We Help?';

  @override
  String get helpNowSubtitle => 'You\'re not alone. We\'re here for you.';

  @override
  String get helpNowEmpty => 'No help topics available right now.';

  @override
  String get helpNowError => 'Something went wrong. Please try again.';

  @override
  String get helpNowItemNotFound => 'Help topic not found.';

  @override
  String get goBack => 'Go back';

  @override
  String get dailyInspiration => 'Daily Inspiration';

  @override
  String get seeAll => 'See All';

  @override
  String get noDailyInspiration => 'No daily inspiration available right now.';

  @override
  String get actionListen => 'Listen';

  @override
  String get actionShare => 'Share';

  @override
  String get actionSaved => 'Saved';

  @override
  String get savedToFavorites => 'Saved to favorites';

  @override
  String get removedFromSaved => 'Removed from saved';

  @override
  String get couldNotUpdateSavedState =>
      'Could not update saved state. Try again.';

  @override
  String get loginRequired => 'Login Required';

  @override
  String get pleaseSignInToSave =>
      'Please sign in to save items to your favorites.';

  @override
  String get duasSearchHint => 'Search duas...';

  @override
  String get duasCouldNotLoadCategories => 'Could not load categories';

  @override
  String get duasNoCategoriesYet => 'No categories yet';

  @override
  String get duasNoDuasFound => 'No duas found';

  @override
  String get duasSavedDuas => 'Saved Duas';

  @override
  String get duasYourSavedDuas => 'Your saved duas';

  @override
  String duasCountLabel(int count) {
    return '$count duas';
  }

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedSignInToView => 'Sign in to view saved items';

  @override
  String get savedTabAll => 'All';

  @override
  String get savedTabDuas => 'Duas';

  @override
  String get savedTabAdhkar => 'Adhkar';

  @override
  String get savedTabVerses => 'Verses';

  @override
  String get savedTabHadith => 'Hadith';

  @override
  String get savedNoItems => 'No saved items';

  @override
  String get savedEmptyHint => 'Save items from the library to see them here.';

  @override
  String get savedNoSearchResults => 'No items match your search';

  @override
  String get savedCouldNotLoad => 'Could not load saved items';

  @override
  String get savedSyncedToAccount =>
      'Your saved items are synced to your account.';

  @override
  String get savedTypeDua => 'Dua';

  @override
  String get savedTypeAdhkar => 'Dhikr';

  @override
  String get savedTypeHadith => 'Hadith';

  @override
  String get savedTypeVerse => 'Verse';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileTapToChange => 'Tap to change photo';

  @override
  String get editProfileNameLabel => 'Name';

  @override
  String get editProfileNameHint => 'Enter your name';

  @override
  String get editProfileShahadaDateLabel => 'Shahada Date (Optional)';

  @override
  String get editProfileShahadaHelper => 'When did you take your shahada?';

  @override
  String get editProfileSelectDate => 'Select date';

  @override
  String get editProfileSaveChanges => 'Save Changes';

  @override
  String get editProfileTakePhoto => 'Take Photo';

  @override
  String get editProfileCameraComingSoon => 'Camera functionality coming soon';

  @override
  String get editProfileChooseFromGallery => 'Choose from Gallery';

  @override
  String get editProfileGalleryComingSoon => 'Gallery picker coming soon';

  @override
  String get editProfileEnterNameError => 'Please enter your name';

  @override
  String get editProfileSavedSuccess => 'Profile saved successfully!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrayerReminders => 'Prayer Reminders';

  @override
  String get settingsDailyLesson => 'Daily Lesson';

  @override
  String get settingsMilestoneAlerts => 'Milestone Alerts';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsUseDarkTheme => 'Use dark theme';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsFontSizeSubtitle => 'Adjust text size';

  @override
  String get settingsPrayerTimes => 'Prayer Times';

  @override
  String get settingsCalculationMethod => 'Calculation Method';

  @override
  String get settingsDefaultMadhab => 'Default Madhab';

  @override
  String get settingsAdjustTimes => 'Adjust Times';

  @override
  String get settingsAdjustTimesSubtitle => 'Fine-tune prayer times ±5 min';

  @override
  String get settingsPrivacyData => 'Privacy & Data';

  @override
  String get settingsExportMyData => 'Export My Data';

  @override
  String get settingsExportMyDataSubtitle => 'Download all your progress';

  @override
  String get settingsDeleteAllData => 'Delete All Data';

  @override
  String get settingsDeleteAllDataSubtitle => 'Permanently delete everything';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsApp => 'App';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsHelpSupport => 'Help & Support';

  @override
  String get settingsSendFeedback => 'Send Feedback';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get dialogExternalLinkTitle => 'External Link';

  @override
  String get dialogExternalLinkContent => 'This will open in your browser:';

  @override
  String get dialogOpeningInBrowser => 'Opening in browser...';

  @override
  String get dialogDeleteAllDataTitle => 'Delete All Data';

  @override
  String get dialogDeleteAllDataContent =>
      'This will permanently delete all your progress, reflections, and saved content. This action cannot be undone.';

  @override
  String get dialogDataDeletedSuccess => 'All data deleted successfully';

  @override
  String get dialogExportTitle => 'Export My Data';

  @override
  String get dialogExportContent => 'Your data export will include:';

  @override
  String get dialogExportPreparing => 'Preparing your data export...';

  @override
  String get dialogExportSuccess =>
      'Data exported successfully! Check your downloads.';

  @override
  String get dialogFeedbackTitle => 'Send Feedback';

  @override
  String get dialogFeedbackContent =>
      'We\'d love to hear from you! Share your thoughts, suggestions, or report issues.';

  @override
  String get dialogFeedbackHint => 'Write your feedback here...';

  @override
  String get dialogFeedbackThanks => 'Thank you for your feedback!';

  @override
  String get dialogAdjustTimesTitle => 'Adjust Prayer Times';

  @override
  String get dialogAdjustTimesContent =>
      'Fine-tune individual prayer times by ±5 minutes';

  @override
  String get dialogPrayerTimesAdjusted => 'Prayer times adjusted';

  @override
  String get darkModeEnabled => 'Dark mode enabled';

  @override
  String get lightModeEnabled => 'Light mode enabled';

  @override
  String languageChanged(String language) {
    return 'Language: $language';
  }

  @override
  String get listenComingSoon => 'Listen — coming soon';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get goHome => 'Go Home';

  @override
  String get needHelp => 'Need Help';

  @override
  String get startupFailed => 'Startup failed';

  @override
  String get startupPleaseReopen => 'Please close and reopen the app.';

  @override
  String get onboardingCommonContinue => 'Continue';

  @override
  String get onboardingCommonSkipForNow => 'Skip for now';

  @override
  String get onboardingCommonSeeMyPlan => 'See my plan ✨';

  @override
  String get onboardingCommonStartMyJourney => 'Start My Journey ✨';

  @override
  String get onboardingAboutYouTitle => 'A little about you';

  @override
  String get onboardingAboutYouSubtitle =>
      'This helps us personalize your experience';

  @override
  String get onboardingAboutYouNameLabel => 'What should we call you?';

  @override
  String get onboardingAboutYouNamePlaceholder => 'Your name (optional)';

  @override
  String get onboardingAboutYouEmbraceIslamLabel =>
      'When did you embrace Islam?';

  @override
  String get onboardingEmbraceIslamLessThan1Month => 'Less than 1 month';

  @override
  String get onboardingEmbraceIslam1To6Months => '1–6 months';

  @override
  String get onboardingEmbraceIslam6To12Months => '6–12 months';

  @override
  String get onboardingEmbraceIslam1To2Years => '1–2 years';

  @override
  String get onboardingEmbraceIslam2PlusYears => '2+ years';

  @override
  String get onboardingEmbraceIslamBornMuslim => 'Born Muslim';

  @override
  String get onboardingKnowledgeTitle => 'Your current knowledge';

  @override
  String get onboardingKnowledgeSubtitle =>
      'No judgment — just so we can meet you where you are.';

  @override
  String get onboardingKnowledgeArabicLabel => 'Can you read Arabic?';

  @override
  String get onboardingArabicYesFluently => 'Yes, fluently';

  @override
  String get onboardingArabicYesSlowly => 'Yes, slowly';

  @override
  String get onboardingArabicLearningNow => 'Learning now';

  @override
  String get onboardingArabicNoWantToLearn => 'No, but want to learn';

  @override
  String get onboardingArabicNo => 'No';

  @override
  String get onboardingKnowledgePrayerLabel =>
      'Do you pray the 5 daily prayers?';

  @override
  String get onboardingPrayerYesRegularly => 'Yes, regularly';

  @override
  String get onboardingPrayerYesNotAll5 => 'Yes, but not all 5';

  @override
  String get onboardingPrayerLearningToPray => 'Learning to pray';

  @override
  String get onboardingPrayerNotYet => 'Not yet';

  @override
  String get onboardingKnowledgeQuranLabel => 'Have you read any Quran?';

  @override
  String get onboardingQuranYesRegularly => 'Yes, regularly';

  @override
  String get onboardingQuranYesOccasionally => 'Yes, occasionally';

  @override
  String get onboardingQuranJustStarted => 'Just started';

  @override
  String get onboardingQuranNotYet => 'Not yet';

  @override
  String get onboardingGoalsTitle => 'What brings you here?';

  @override
  String get onboardingGoalsSubtitle => 'Select all that resonate with you';

  @override
  String get onboardingGoalsMainLabel => 'Your main goals';

  @override
  String get onboardingGoalLearnBasics => 'Learn the basics';

  @override
  String get onboardingGoalImprovePrayer => 'Improve my prayer';

  @override
  String get onboardingGoalUnderstandQuran => 'Understand Quran';

  @override
  String get onboardingGoalBuildHabits => 'Build good habits';

  @override
  String get onboardingGoalConnectCommunity => 'Connect with community';

  @override
  String get onboardingChallengesLabel => 'What challenges you most?';

  @override
  String get onboardingChallengeUnderstandingArabic => 'Understanding Arabic';

  @override
  String get onboardingChallengeRememberingToPray => 'Remembering to pray';

  @override
  String get onboardingChallengeFindingTime => 'Finding time to learn';

  @override
  String get onboardingChallengeStayingConsistent => 'Staying consistent';

  @override
  String get onboardingChallengeDealingWithDoubts => 'Dealing with doubts';

  @override
  String get onboardingChallengeLackOfSupport => 'Lack of support';

  @override
  String get onboardingPreferencesTitle => 'Your preferences';

  @override
  String get onboardingPreferencesSubtitle =>
      'We\'ll shape Noorly around your schedule';

  @override
  String get onboardingPreferencesTimeDailyLabel => 'How much time daily?';

  @override
  String get onboardingTime5To10 => '5–10 min';

  @override
  String get onboardingTime5To10Sub => 'Quick daily dose';

  @override
  String get onboardingTime15To20 => '15–20 min';

  @override
  String get onboardingTime15To20Sub => 'Balanced learning';

  @override
  String get onboardingTime30Plus => '30+ min';

  @override
  String get onboardingTime30PlusSub => 'Deep immersion';

  @override
  String get onboardingTimeFlexible => 'Flexible';

  @override
  String get onboardingTimeFlexibleSub => 'No set schedule';

  @override
  String get onboardingPreferencesBestTimeLabel => 'Best time to learn?';

  @override
  String get onboardingBestTimeMorning => 'Morning';

  @override
  String get onboardingBestTimeAfternoon => 'Afternoon';

  @override
  String get onboardingBestTimeEvening => 'Evening';

  @override
  String get onboardingBestTimeNight => 'Night';

  @override
  String get onboardingBestTimeAnytime => 'Anytime';

  @override
  String get onboardingPreferencesLearningStyleLabel =>
      'How do you learn best?';

  @override
  String get onboardingStyleReading => 'Reading';

  @override
  String get onboardingStyleListening => 'Listening';

  @override
  String get onboardingStyleVideos => 'Videos';

  @override
  String get onboardingStyleInteractive => 'Interactive';

  @override
  String get onboardingStyleMixOfAll => 'Mix of all';

  @override
  String get onboardingPreferencesRemindersLabel => 'Reminders & notifications';

  @override
  String get onboardingReminderAll => 'All reminders';

  @override
  String get onboardingReminderAllSub => 'Prayers + lessons + motivation';

  @override
  String get onboardingReminderPrayerOnly => 'Prayer times only';

  @override
  String get onboardingReminderPrayerOnlySub => 'Just salah reminders';

  @override
  String get onboardingReminderCustomize => 'Let me customize';

  @override
  String get onboardingReminderCustomizeSub => 'Choose in settings later';

  @override
  String get onboardingReminderNoThanks => 'No thanks';

  @override
  String get onboardingReminderNoThanksSub => 'I\'ll manage on my own';

  @override
  String get onboardingPlanTitle => 'Your Starting Plan';

  @override
  String get onboardingPlanSubtitle => 'Here\'s how we\'ll begin, together.';

  @override
  String get onboardingPlanFaithFoundations => 'Faith Foundations';

  @override
  String get onboardingPlanFaithFoundationsSub => 'Understand your beliefs';

  @override
  String get onboardingPlanWeeks1To2 => 'Weeks 1–2';

  @override
  String get onboardingPlanDailyPrayer => 'Daily Prayer';

  @override
  String get onboardingPlanDailyPrayerSub => 'Learn and practice salah';

  @override
  String get onboardingPlanWeeks3To5 => 'Weeks 3–5';

  @override
  String get onboardingPlanLivingIslam => 'Living Islam';

  @override
  String get onboardingPlanLivingIslamSub => 'Build character and habits';

  @override
  String get onboardingPlanWeeks6To8 => 'Weeks 6–8';

  @override
  String get onboardingPlanAddIslamDate => 'Add your Islam date';

  @override
  String get onboardingPlanAddIslamDateSub =>
      'Optional — we\'ll celebrate your milestones';

  @override
  String get dashboardOnboardingTitle => 'Your Journey';

  @override
  String get dashboardOnboardingSubtitle => 'Your saved preferences and goals';

  @override
  String get dashboardOnboardingYourJourney => 'Your Journey';

  @override
  String get dashboardOnboardingYourPreferences => 'Your Preferences';

  @override
  String get dashboardOnboardingYourGoals => 'Your Goals';

  @override
  String get dashboardOnboardingYourChallenges => 'Your Challenges';

  @override
  String get dashboardOnboardingYourLearningProfile => 'Your Learning Profile';

  @override
  String get dashboardOnboardingCompleteCta => 'Complete your onboarding';

  @override
  String get dashboardOnboardingEmpty => 'No onboarding data yet.';

  @override
  String get dashboardOnboardingDisplayName => 'Name';

  @override
  String get dashboardOnboardingEmbraceIslam => 'When you embraced Islam';

  @override
  String get dashboardOnboardingArabicLevel => 'Arabic reading';

  @override
  String get dashboardOnboardingPrayerLevel => 'Prayer';

  @override
  String get dashboardOnboardingQuranLevel => 'Quran reading';

  @override
  String get dashboardOnboardingDailyTime => 'Daily time';

  @override
  String get dashboardOnboardingBestTime => 'Best time to learn';

  @override
  String get dashboardOnboardingLearningStyle => 'Learning style';

  @override
  String get dashboardOnboardingReminders => 'Reminders';

  @override
  String get dashboardOnboardingIslamDate => 'Islam date';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationsPrayer => 'Prayer Reminders';

  @override
  String get notificationsPrayerDesc => 'Get reminded at each prayer time';

  @override
  String get notificationsPrayerAll => 'All Prayer Reminders';

  @override
  String get notificationsFajr => 'Fajr';

  @override
  String get notificationsDhuhr => 'Dhuhr';

  @override
  String get notificationsAsr => 'Asr';

  @override
  String get notificationsMaghrib => 'Maghrib';

  @override
  String get notificationsIsha => 'Isha';

  @override
  String get notificationsTimingMode => 'Notification timing';

  @override
  String get notificationsTimingBefore => 'Before Adhan';

  @override
  String get notificationsTimingAt => 'At Adhan';

  @override
  String get notificationsTimingAfter => 'After Adhan';

  @override
  String notificationsOffsetMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get notificationsLesson => 'Lesson Reminders';

  @override
  String get notificationsLessonDesc =>
      'Daily reminders to continue your journey';

  @override
  String get notificationsLessonMorning => 'Daily lesson reminder';

  @override
  String get notificationsLessonTime => 'Reminder time';

  @override
  String get notificationsLessonEvening =>
      'Evening reminder (if not completed)';

  @override
  String get notificationsStreak => 'Streak reminder';

  @override
  String get notificationsDhikr => 'Adhkar Reminders';

  @override
  String get notificationsDhikrDesc =>
      'Morning, evening and sleep remembrances';

  @override
  String get notificationsMorningAdhkar => 'Morning Adhkar';

  @override
  String get notificationsEveningAdhkar => 'Evening Adhkar';

  @override
  String get notificationsSleepAdhkar => 'Sleep Adhkar';

  @override
  String get notificationsSleepAdhkarTime => 'Sleep adhkar time';

  @override
  String get notificationsRandomDhikr => 'Random Dhikr Reminders';

  @override
  String get notificationsRandomDhikrFrequency => 'Frequency per day';

  @override
  String get notificationsMilestones => 'Milestones & Occasions';

  @override
  String get notificationsMilestonesDesc =>
      'Celebrate achievements and Islamic occasions';

  @override
  String get notificationsAchievements => 'Achievement notifications';

  @override
  String get notificationsOccasions =>
      'Special occasions (Friday, Ramadan, Eid)';

  @override
  String get notificationsSupportReminders => 'Support reminders';

  @override
  String get notificationsQuietHours => 'Quiet Hours';

  @override
  String get notificationsQuietHoursDesc =>
      'No notifications during this period';

  @override
  String get notificationsQuietHoursEnable => 'Enable quiet hours';

  @override
  String get notificationsQuietStart => 'Start time';

  @override
  String get notificationsQuietEnd => 'End time';

  @override
  String get notificationsSoundVibration => 'Sound & Vibration';

  @override
  String get notificationsSound => 'Sound';

  @override
  String get notificationsVibration => 'Vibration';

  @override
  String get notificationsLanguage => 'Notification Language';

  @override
  String get notificationsLangAppLocale => 'App language';

  @override
  String get notificationsLangArabic => 'Arabic';

  @override
  String get notificationsLangEnglish => 'English';

  @override
  String get notificationsLangBoth => 'Both';

  @override
  String get notificationsSaveSuccess => 'Notification settings saved';

  @override
  String get notificationsPermissionRequired =>
      'Please enable notifications in your device settings to receive reminders';

  @override
  String get notificationsEnableButton => 'Enable Notifications';
}
