import 'package:flutter_app/core/utils/greeting_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getGreeting', () {
    test('05:00-11:59 returns Good morning', () {
      expect(getGreeting(DateTime(2025, 1, 1, 5, 0)), 'Good morning');
      expect(getGreeting(DateTime(2025, 1, 1, 8, 30)), 'Good morning');
      expect(getGreeting(DateTime(2025, 1, 1, 11, 59)), 'Good morning');
    });

    test('12:00-16:59 returns Good afternoon', () {
      expect(getGreeting(DateTime(2025, 1, 1, 12, 0)), 'Good afternoon');
      expect(getGreeting(DateTime(2025, 1, 1, 14, 0)), 'Good afternoon');
      expect(getGreeting(DateTime(2025, 1, 1, 16, 59)), 'Good afternoon');
    });

    test('17:00-20:59 returns Good evening', () {
      expect(getGreeting(DateTime(2025, 1, 1, 17, 0)), 'Good evening');
      expect(getGreeting(DateTime(2025, 1, 1, 19, 0)), 'Good evening');
      expect(getGreeting(DateTime(2025, 1, 1, 20, 59)), 'Good evening');
    });

    test('21:00-04:59 returns Good night', () {
      expect(getGreeting(DateTime(2025, 1, 1, 21, 0)), 'Good night');
      expect(getGreeting(DateTime(2025, 1, 1, 0, 0)), 'Good night');
      expect(getGreeting(DateTime(2025, 1, 1, 4, 59)), 'Good night');
    });
  });

  group('getTitleFromGender', () {
    test('male returns Mr', () {
      expect(getTitleFromGender('male'), 'Mr');
      expect(getTitleFromGender('Male'), 'Mr');
      expect(getTitleFromGender('MALE'), 'Mr');
    });

    test('female returns Ms', () {
      expect(getTitleFromGender('female'), 'Ms');
      expect(getTitleFromGender('Female'), 'Ms');
    });

    test('null or empty returns empty string', () {
      expect(getTitleFromGender(null), '');
      expect(getTitleFromGender(''), '');
    });

    test('other/unknown returns empty string', () {
      expect(getTitleFromGender('other'), '');
      expect(getTitleFromGender('unknown'), '');
      expect(getTitleFromGender('non-binary'), '');
    });
  });

  group('getDisplayNameWithTitle', () {
    test('male + name returns Mr name', () {
      expect(getDisplayNameWithTitle('Abdullah', 'male'), 'Mr Abdullah');
    });

    test('female + name returns Ms name', () {
      expect(getDisplayNameWithTitle('Aisha', 'female'), 'Ms Aisha');
    });

    test('unknown gender returns name only', () {
      expect(getDisplayNameWithTitle('Abdullah', null), 'Abdullah');
      expect(getDisplayNameWithTitle('Abdullah', 'other'), 'Abdullah');
    });

    test('null or empty name returns empty string', () {
      expect(getDisplayNameWithTitle(null, 'male'), '');
      expect(getDisplayNameWithTitle('', 'female'), '');
      expect(getDisplayNameWithTitle('  ', 'male'), '');
    });
  });
}
