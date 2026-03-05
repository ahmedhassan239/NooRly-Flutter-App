import 'package:flutter_app/features/home/data/daily_inspiration_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyInspirationDto', () {
    test('fromJson parses hadith and isValid is true', () {
      final json = {
        'data': {
          'type': 'hadith',
          'id': 123,
          'arabic': 'حديث عربي',
          'translation': 'Hadith translation',
          'title': 'Hadith',
          'source': 'Sahih Bukhari',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.type, 'hadith');
      expect(dto.id, 123);
      expect(dto.reference, 'Sahih Bukhari');
      expect(dto.isValid, isTrue);
    });

    test('fromJson parses ayah and isValid is true', () {
      final json = {
        'data': {
          'type': 'ayah',
          'id': 255,
          'arabic': 'آية',
          'translation': 'Ayah translation',
          'title': 'Quran',
          'surah': 'Al-Baqarah 255',
          'ayah_number': 255,
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.type, 'ayah');
      expect(dto.surah, 'Al-Baqarah 255');
      expect(dto.isValid, isTrue);
    });

    test('fromJson normalizes type to lowercase', () {
      final json = {
        'data': {
          'type': 'DHIKR',
          'id': 1,
          'arabic': 'ذكر',
          'translation': 'Dhikr translation',
          'source': 'Bukhari',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.type, 'dhikr');
      expect(dto.isValid, isTrue);
    });

    test('isValid is false for unknown type', () {
      final json = {
        'data': {
          'type': 'unknown',
          'id': 1,
          'arabic': 'x',
          'translation': 'y',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.isValid, isFalse);
    });

    test('isValid is false when id is 0', () {
      final json = {
        'data': {
          'type': 'dua',
          'id': 0,
          'arabic': 'دعاء',
          'translation': 'Dua translation',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.isValid, isFalse);
    });

    test('isValid is false when arabic and translation both empty', () {
      final json = {
        'data': {
          'type': 'hadith',
          'id': 1,
          'arabic': '',
          'translation': '',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.isValid, isFalse);
    });

    test('isValid is true when only translation is non-empty', () {
      final json = {
        'data': {
          'type': 'dua',
          'id': 1,
          'arabic': '',
          'translation': 'Only translation',
        },
      };
      final dto = DailyInspirationDto.fromJson(json);
      expect(dto.isValid, isTrue);
    });

    test('saveButtonType maps ayah to verse and dhikr to adhkar', () {
      expect(
        DailyInspirationDto(
          type: 'ayah',
          id: 1,
          arabic: 'a',
          translation: 't',
        ).saveButtonType,
        'verse',
      );
      expect(
        DailyInspirationDto(
          type: 'dhikr',
          id: 1,
          arabic: 'a',
          translation: 't',
        ).saveButtonType,
        'adhkar',
      );
      expect(
        DailyInspirationDto(
          type: 'hadith',
          id: 1,
          arabic: 'a',
          translation: 't',
        ).saveButtonType,
        'hadith',
      );
    });
  });
}
