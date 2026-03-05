import 'package:flutter_app/features/journey/data/models/journey_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LessonModel.fromJson (current lesson / GET /lessons/today)', () {
    test('parses full API shape with week_number and estimated_minutes', () {
      final json = {
        'id': '5',
        'day_number': 3,
        'week_number': 2,
        'title': 'Understanding Salah',
        'title_ar': 'فهم الصلاة',
        'summary': 'Short description',
        'content': '<p>Lesson content</p>',
        'estimated_minutes': 8,
        'is_unlocked': true,
        'is_completed': false,
      };

      final lesson = LessonModel.fromJson(json);

      expect(lesson.id, '5');
      expect(lesson.dayNumber, 3);
      expect(lesson.weekNumber, 2);
      expect(lesson.title, 'Understanding Salah');
      expect(lesson.titleAr, 'فهم الصلاة');
      expect(lesson.duration, 8);
      expect(lesson.content, '<p>Lesson content</p>');
    });

    test('parses when week_number is missing (optional)', () {
      final json = {
        'id': '1',
        'day_number': 1,
        'title': 'First Lesson',
        'estimated_minutes': 5,
      };

      final lesson = LessonModel.fromJson(json);

      expect(lesson.id, '1');
      expect(lesson.dayNumber, 1);
      expect(lesson.weekNumber, isNull);
      expect(lesson.title, 'First Lesson');
      expect(lesson.duration, 5);
    });

    test('toJson includes week_number for cache round-trip', () {
      final json = {
        'id': '5',
        'day_number': 3,
        'week_number': 2,
        'title': 'Test',
        'estimated_minutes': 10,
      };
      final lesson = LessonModel.fromJson(json);
      final encoded = lesson.toJson();

      expect(encoded['week_number'], 2);
      expect(encoded['day_number'], 3);
      expect(encoded['id'], '5');
      expect(LessonModel.fromJson(encoded).weekNumber, 2);
    });
  });
}
