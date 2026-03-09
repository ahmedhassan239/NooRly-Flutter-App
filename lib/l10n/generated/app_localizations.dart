import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Noor Journey'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Noor Journey'**
  String get welcomeTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String otpSubtitle(String email);

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get otpResend;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String otpResendIn(int seconds);

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please try again.'**
  String get otpInvalid;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired. Please request a new one.'**
  String get otpExpired;

  /// No description provided for @otpTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait and try later.'**
  String get otpTooManyRequests;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get otpVerified;

  /// No description provided for @otpVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerifyButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get navJourney;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get actionSignIn;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get actionSaveChanges;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get copiedToClipboard;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get homeGreeting;

  /// No description provided for @homeEncouragement.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great. Every step counts.'**
  String get homeEncouragement;

  /// No description provided for @homeFriendFallback.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get homeFriendFallback;

  /// No description provided for @homeExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get homeExitTitle;

  /// No description provided for @homeExitContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit NooRly?'**
  String get homeExitContent;

  /// No description provided for @homeExitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get homeExitConfirm;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @setLocationForTimes.
  ///
  /// In en, this message translates to:
  /// **'Set location for times'**
  String get setLocationForTimes;

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'YOUR JOURNEY'**
  String get yourJourney;

  /// No description provided for @noLessonRightNow.
  ///
  /// In en, this message translates to:
  /// **'No lesson right now'**
  String get noLessonRightNow;

  /// No description provided for @viewJourney.
  ///
  /// In en, this message translates to:
  /// **'View Journey'**
  String get viewJourney;

  /// No description provided for @signInToContinueLessons.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your lessons'**
  String get signInToContinueLessons;

  /// No description provided for @journeyErrorSession.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get journeyErrorSession;

  /// No description provided for @journeyErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load your lesson. Try again or open Journey.'**
  String get journeyErrorLoad;

  /// No description provided for @journeyWeekDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Week {week} / Day {day}'**
  String journeyWeekDayLabel(int week, int day);

  /// No description provided for @journeyDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String journeyDayLabel(int day);

  /// No description provided for @journeyDurationMinRead.
  ///
  /// In en, this message translates to:
  /// **'{duration} min read'**
  String journeyDurationMinRead(int duration);

  /// No description provided for @todaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get todaysFocus;

  /// No description provided for @continueYourLesson.
  ///
  /// In en, this message translates to:
  /// **'Continue your lesson'**
  String get continueYourLesson;

  /// No description provided for @takeTwoMinutesForDhikr.
  ///
  /// In en, this message translates to:
  /// **'Take 2 minutes for dhikr'**
  String get takeTwoMinutesForDhikr;

  /// No description provided for @prepareForNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prepare for next prayer'**
  String get prepareForNextPrayer;

  /// No description provided for @ramadanIsHere.
  ///
  /// In en, this message translates to:
  /// **'Ramadan is here'**
  String get ramadanIsHere;

  /// No description provided for @prepareForTheBlessedMonth.
  ///
  /// In en, this message translates to:
  /// **'Prepare for the blessed month'**
  String get prepareForTheBlessedMonth;

  /// No description provided for @startRamadanGuide.
  ///
  /// In en, this message translates to:
  /// **'Start Ramadan Guide'**
  String get startRamadanGuide;

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get journeyTitle;

  /// No description provided for @journeyLearningPath.
  ///
  /// In en, this message translates to:
  /// **'90-Day Learning Path'**
  String get journeyLearningPath;

  /// No description provided for @journeyStatProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get journeyStatProgress;

  /// No description provided for @journeyStatDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get journeyStatDone;

  /// No description provided for @journeyStatCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get journeyStatCurrent;

  /// No description provided for @journeyOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get journeyOverallProgress;

  /// No description provided for @journeyEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Keep going! You\'re doing great!'**
  String get journeyEncouragement;

  /// No description provided for @journeyCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load journey'**
  String get journeyCouldNotLoad;

  /// No description provided for @journeyCompletePreviousFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete previous lessons first.'**
  String get journeyCompletePreviousFirst;

  /// No description provided for @prayerNotificationsMuted.
  ///
  /// In en, this message translates to:
  /// **'Notifications muted'**
  String get prayerNotificationsMuted;

  /// No description provided for @prayerNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get prayerNotificationsEnabled;

  /// No description provided for @prayerNotificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required. Please enable it in settings.'**
  String get prayerNotificationPermissionRequired;

  /// No description provided for @prayerGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get prayerGettingLocation;

  /// No description provided for @prayerTodaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S PRAYERS'**
  String get prayerTodaysPrayers;

  /// No description provided for @prayerNoPrayerTimesForLocation.
  ///
  /// In en, this message translates to:
  /// **'No prayer times for this location'**
  String get prayerNoPrayerTimesForLocation;

  /// No description provided for @prayerLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get prayerLocationUnavailable;

  /// No description provided for @prayerEnterCityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city, country (e.g. Cairo, Egypt)'**
  String get prayerEnterCityHint;

  /// No description provided for @prayerLocationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission was permanently denied. Open app settings to enable it.'**
  String get prayerLocationPermissionDeniedForever;

  /// No description provided for @prayerOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get prayerOpenSettings;

  /// No description provided for @prayerLocationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get prayerLocationPermissionDenied;

  /// No description provided for @prayerLocationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get prayerLocationServicesDisabled;

  /// No description provided for @prayerLocationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get prayerLocationUpdated;

  /// No description provided for @prayerUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get prayerUseCurrentLocation;

  /// No description provided for @prayerLocationRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Location refreshed'**
  String get prayerLocationRefreshed;

  /// No description provided for @prayerRefreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh location'**
  String get prayerRefreshLocation;

  /// No description provided for @prayerUseAddress.
  ///
  /// In en, this message translates to:
  /// **'Use address'**
  String get prayerUseAddress;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get profileYourProgress;

  /// No description provided for @profileStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profileStreakLabel;

  /// No description provided for @profileDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profileDaysLabel;

  /// No description provided for @profileActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileActiveLabel;

  /// No description provided for @profileWeeksLabel.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get profileWeeksLabel;

  /// No description provided for @profileLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get profileLeftLabel;

  /// No description provided for @profileCouldNotLoadProgress.
  ///
  /// In en, this message translates to:
  /// **'Could not load progress'**
  String get profileCouldNotLoadProgress;

  /// No description provided for @profileJourneyProgress.
  ///
  /// In en, this message translates to:
  /// **'Journey Progress'**
  String get profileJourneyProgress;

  /// No description provided for @profileLessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons completed'**
  String profileLessonsCompleted(int count);

  /// No description provided for @profilePercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String profilePercentComplete(int percent);

  /// No description provided for @profileMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get profileMilestones;

  /// No description provided for @profileWeekComplete.
  ///
  /// In en, this message translates to:
  /// **'Week {week} Complete'**
  String profileWeekComplete(int week);

  /// No description provided for @profileNoMilestonesYet.
  ///
  /// In en, this message translates to:
  /// **'No milestones yet'**
  String get profileNoMilestonesYet;

  /// No description provided for @profileInProgress.
  ///
  /// In en, this message translates to:
  /// **'(In Progress)'**
  String get profileInProgress;

  /// No description provided for @profileNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileNotSet;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get profilePersonalInfo;

  /// No description provided for @profileLabelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileLabelName;

  /// No description provided for @profileLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileLabelEmail;

  /// No description provided for @profileLabelGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileLabelGender;

  /// No description provided for @profileLabelBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get profileLabelBirthDate;

  /// No description provided for @profileLabelLocale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get profileLabelLocale;

  /// No description provided for @profileLabelShahadaDate.
  ///
  /// In en, this message translates to:
  /// **'Shahada Date'**
  String get profileLabelShahadaDate;

  /// No description provided for @profileLabelLearningGoals.
  ///
  /// In en, this message translates to:
  /// **'Learning Goals'**
  String get profileLabelLearningGoals;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get profileQuickActions;

  /// No description provided for @profileSavedDuas.
  ///
  /// In en, this message translates to:
  /// **'Saved Duas'**
  String get profileSavedDuas;

  /// No description provided for @profileViewSavedDuas.
  ///
  /// In en, this message translates to:
  /// **'View your saved duas collection'**
  String get profileViewSavedDuas;

  /// No description provided for @profileYourReflections.
  ///
  /// In en, this message translates to:
  /// **'Your Reflections'**
  String get profileYourReflections;

  /// No description provided for @profileReviewReflections.
  ///
  /// In en, this message translates to:
  /// **'Review your lesson reflections'**
  String get profileReviewReflections;

  /// No description provided for @profileManagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage app preferences'**
  String get profileManagePreferences;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// No description provided for @profileLogOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOutTitle;

  /// No description provided for @profileLogOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogOutConfirm;

  /// No description provided for @profileDayOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String profileDayOfTotal(int day, int total);

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @libraryNoTabsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No library tabs available'**
  String get libraryNoTabsAvailable;

  /// No description provided for @libraryDuas.
  ///
  /// In en, this message translates to:
  /// **'Duas'**
  String get libraryDuas;

  /// No description provided for @libraryHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get libraryHadith;

  /// No description provided for @libraryVerses.
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get libraryVerses;

  /// No description provided for @libraryAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Adhkar'**
  String get libraryAdhkar;

  /// No description provided for @libraryNoCollectionsYet.
  ///
  /// In en, this message translates to:
  /// **'No collections yet'**
  String get libraryNoCollectionsYet;

  /// No description provided for @libraryNoAdhkarCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No adhkar categories yet'**
  String get libraryNoAdhkarCategoriesYet;

  /// No description provided for @searchDuas.
  ///
  /// In en, this message translates to:
  /// **'Search duas...'**
  String get searchDuas;

  /// No description provided for @searchHadith.
  ///
  /// In en, this message translates to:
  /// **'Search hadith...'**
  String get searchHadith;

  /// No description provided for @searchVerses.
  ///
  /// In en, this message translates to:
  /// **'Search verses...'**
  String get searchVerses;

  /// No description provided for @searchAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Search adhkar...'**
  String get searchAdhkar;

  /// No description provided for @savedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String savedCountLabel(int count);

  /// No description provided for @itemCountDuas.
  ///
  /// In en, this message translates to:
  /// **'{count} duas'**
  String itemCountDuas(int count);

  /// No description provided for @itemCountHadith.
  ///
  /// In en, this message translates to:
  /// **'{count} hadith'**
  String itemCountHadith(int count);

  /// No description provided for @itemCountVerses.
  ///
  /// In en, this message translates to:
  /// **'{count} verses'**
  String itemCountVerses(int count);

  /// No description provided for @itemCountAdhkar.
  ///
  /// In en, this message translates to:
  /// **'{count} adhkar'**
  String itemCountAdhkar(int count);

  /// No description provided for @savedCardDuas.
  ///
  /// In en, this message translates to:
  /// **'Saved Duas'**
  String get savedCardDuas;

  /// No description provided for @savedCardHadith.
  ///
  /// In en, this message translates to:
  /// **'Saved Hadith'**
  String get savedCardHadith;

  /// No description provided for @savedCardVerses.
  ///
  /// In en, this message translates to:
  /// **'Saved Verses'**
  String get savedCardVerses;

  /// No description provided for @savedCardAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Saved Adhkar'**
  String get savedCardAdhkar;

  /// No description provided for @prayerSchedule.
  ///
  /// In en, this message translates to:
  /// **'Prayer Schedule'**
  String get prayerSchedule;

  /// No description provided for @dailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// No description provided for @prayerRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get prayerRemaining;

  /// No description provided for @prayerMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get prayerMissed;

  /// No description provided for @prayerCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get prayerCompleted;

  /// No description provided for @prayerDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get prayerDone;

  /// No description provided for @prayerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get prayerNext;

  /// No description provided for @prayerUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get prayerUpcoming;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @remainingNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get remainingNow;

  /// No description provided for @remainingInMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes}m'**
  String remainingInMinutes(int minutes);

  /// No description provided for @remainingInHours.
  ///
  /// In en, this message translates to:
  /// **'in {hours}h'**
  String remainingInHours(int hours);

  /// No description provided for @remainingInHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {hours}h {minutes}m'**
  String remainingInHoursMinutes(int hours, int minutes);

  /// No description provided for @needHelpNow.
  ///
  /// In en, this message translates to:
  /// **'Need Help Now?'**
  String get needHelpNow;

  /// No description provided for @quickSupportWhenYouNeedIt.
  ///
  /// In en, this message translates to:
  /// **'Quick support when you need it'**
  String get quickSupportWhenYouNeedIt;

  /// No description provided for @dailyInspiration.
  ///
  /// In en, this message translates to:
  /// **'Daily Inspiration'**
  String get dailyInspiration;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noDailyInspiration.
  ///
  /// In en, this message translates to:
  /// **'No daily inspiration available right now.'**
  String get noDailyInspiration;

  /// No description provided for @actionListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get actionListen;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get actionSaved;

  /// No description provided for @savedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get savedToFavorites;

  /// No description provided for @removedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get removedFromSaved;

  /// No description provided for @couldNotUpdateSavedState.
  ///
  /// In en, this message translates to:
  /// **'Could not update saved state. Try again.'**
  String get couldNotUpdateSavedState;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @pleaseSignInToSave.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save items to your favorites.'**
  String get pleaseSignInToSave;

  /// No description provided for @duasSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search duas...'**
  String get duasSearchHint;

  /// No description provided for @duasCouldNotLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories'**
  String get duasCouldNotLoadCategories;

  /// No description provided for @duasNoCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get duasNoCategoriesYet;

  /// No description provided for @duasNoDuasFound.
  ///
  /// In en, this message translates to:
  /// **'No duas found'**
  String get duasNoDuasFound;

  /// No description provided for @duasSavedDuas.
  ///
  /// In en, this message translates to:
  /// **'Saved Duas'**
  String get duasSavedDuas;

  /// No description provided for @duasYourSavedDuas.
  ///
  /// In en, this message translates to:
  /// **'Your saved duas'**
  String get duasYourSavedDuas;

  /// No description provided for @duasCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} duas'**
  String duasCountLabel(int count);

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedSignInToView.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view saved items'**
  String get savedSignInToView;

  /// No description provided for @savedTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get savedTabAll;

  /// No description provided for @savedTabDuas.
  ///
  /// In en, this message translates to:
  /// **'Duas'**
  String get savedTabDuas;

  /// No description provided for @savedTabAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Adhkar'**
  String get savedTabAdhkar;

  /// No description provided for @savedTabVerses.
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get savedTabVerses;

  /// No description provided for @savedTabHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get savedTabHadith;

  /// No description provided for @savedNoItems.
  ///
  /// In en, this message translates to:
  /// **'No saved items'**
  String get savedNoItems;

  /// No description provided for @savedEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Save items from the library to see them here.'**
  String get savedEmptyHint;

  /// No description provided for @savedNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No items match your search'**
  String get savedNoSearchResults;

  /// No description provided for @savedCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load saved items'**
  String get savedCouldNotLoad;

  /// No description provided for @savedSyncedToAccount.
  ///
  /// In en, this message translates to:
  /// **'Your saved items are synced to your account.'**
  String get savedSyncedToAccount;

  /// No description provided for @savedTypeDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get savedTypeDua;

  /// No description provided for @savedTypeAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get savedTypeAdhkar;

  /// No description provided for @savedTypeHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get savedTypeHadith;

  /// No description provided for @savedTypeVerse.
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get savedTypeVerse;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileTapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get editProfileTapToChange;

  /// No description provided for @editProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editProfileNameLabel;

  /// No description provided for @editProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get editProfileNameHint;

  /// No description provided for @editProfileShahadaDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Shahada Date (Optional)'**
  String get editProfileShahadaDateLabel;

  /// No description provided for @editProfileShahadaHelper.
  ///
  /// In en, this message translates to:
  /// **'When did you take your shahada?'**
  String get editProfileShahadaHelper;

  /// No description provided for @editProfileSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get editProfileSelectDate;

  /// No description provided for @editProfileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSaveChanges;

  /// No description provided for @editProfileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get editProfileTakePhoto;

  /// No description provided for @editProfileCameraComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Camera functionality coming soon'**
  String get editProfileCameraComingSoon;

  /// No description provided for @editProfileChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get editProfileChooseFromGallery;

  /// No description provided for @editProfileGalleryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Gallery picker coming soon'**
  String get editProfileGalleryComingSoon;

  /// No description provided for @editProfileEnterNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get editProfileEnterNameError;

  /// No description provided for @editProfileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get editProfileSavedSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPrayerReminders.
  ///
  /// In en, this message translates to:
  /// **'Prayer Reminders'**
  String get settingsPrayerReminders;

  /// No description provided for @settingsDailyLesson.
  ///
  /// In en, this message translates to:
  /// **'Daily Lesson'**
  String get settingsDailyLesson;

  /// No description provided for @settingsMilestoneAlerts.
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get settingsMilestoneAlerts;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsUseDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get settingsUseDarkTheme;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsFontSize;

  /// No description provided for @settingsFontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size'**
  String get settingsFontSizeSubtitle;

  /// No description provided for @settingsPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get settingsPrayerTimes;

  /// No description provided for @settingsCalculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get settingsCalculationMethod;

  /// No description provided for @settingsDefaultMadhab.
  ///
  /// In en, this message translates to:
  /// **'Default Madhab'**
  String get settingsDefaultMadhab;

  /// No description provided for @settingsAdjustTimes.
  ///
  /// In en, this message translates to:
  /// **'Adjust Times'**
  String get settingsAdjustTimes;

  /// No description provided for @settingsAdjustTimesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fine-tune prayer times ±5 min'**
  String get settingsAdjustTimesSubtitle;

  /// No description provided for @settingsPrivacyData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get settingsPrivacyData;

  /// No description provided for @settingsExportMyData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get settingsExportMyData;

  /// No description provided for @settingsExportMyDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download all your progress'**
  String get settingsExportMyDataSubtitle;

  /// No description provided for @settingsDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get settingsDeleteAllData;

  /// No description provided for @settingsDeleteAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete everything'**
  String get settingsDeleteAllDataSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsApp;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settingsHelpSupport;

  /// No description provided for @settingsSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get settingsSendFeedback;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @dialogExternalLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'External Link'**
  String get dialogExternalLinkTitle;

  /// No description provided for @dialogExternalLinkContent.
  ///
  /// In en, this message translates to:
  /// **'This will open in your browser:'**
  String get dialogExternalLinkContent;

  /// No description provided for @dialogOpeningInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Opening in browser...'**
  String get dialogOpeningInBrowser;

  /// No description provided for @dialogDeleteAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get dialogDeleteAllDataTitle;

  /// No description provided for @dialogDeleteAllDataContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your progress, reflections, and saved content. This action cannot be undone.'**
  String get dialogDeleteAllDataContent;

  /// No description provided for @dialogDataDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data deleted successfully'**
  String get dialogDataDeletedSuccess;

  /// No description provided for @dialogExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get dialogExportTitle;

  /// No description provided for @dialogExportContent.
  ///
  /// In en, this message translates to:
  /// **'Your data export will include:'**
  String get dialogExportContent;

  /// No description provided for @dialogExportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your data export...'**
  String get dialogExportPreparing;

  /// No description provided for @dialogExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully! Check your downloads.'**
  String get dialogExportSuccess;

  /// No description provided for @dialogFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get dialogFeedbackTitle;

  /// No description provided for @dialogFeedbackContent.
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear from you! Share your thoughts, suggestions, or report issues.'**
  String get dialogFeedbackContent;

  /// No description provided for @dialogFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback here...'**
  String get dialogFeedbackHint;

  /// No description provided for @dialogFeedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get dialogFeedbackThanks;

  /// No description provided for @dialogAdjustTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust Prayer Times'**
  String get dialogAdjustTimesTitle;

  /// No description provided for @dialogAdjustTimesContent.
  ///
  /// In en, this message translates to:
  /// **'Fine-tune individual prayer times by ±5 minutes'**
  String get dialogAdjustTimesContent;

  /// No description provided for @dialogPrayerTimesAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Prayer times adjusted'**
  String get dialogPrayerTimesAdjusted;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode enabled'**
  String get darkModeEnabled;

  /// No description provided for @lightModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light mode enabled'**
  String get lightModeEnabled;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language: {language}'**
  String languageChanged(String language);

  /// No description provided for @listenComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Listen — coming soon'**
  String get listenComingSoon;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help'**
  String get needHelp;

  /// No description provided for @startupFailed.
  ///
  /// In en, this message translates to:
  /// **'Startup failed'**
  String get startupFailed;

  /// No description provided for @startupPleaseReopen.
  ///
  /// In en, this message translates to:
  /// **'Please close and reopen the app.'**
  String get startupPleaseReopen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
