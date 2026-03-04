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
}
