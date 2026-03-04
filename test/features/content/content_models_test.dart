import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentModel', () {
    test('fromJson parses dua correctly', () {
      final json = {
        'id': '1',
        'arabic_text': 'بِسْمِ اللَّهِ',
        'translation': 'In the name of Allah',
        'transliteration': 'Bismillah',
        'title': 'Before eating',
        'title_ar': 'قبل الأكل',
        'source': 'Sahih Bukhari',
        'category_id': 'food',
        'category_name': 'Food & Drink',
        'is_saved': true,
      };

      final model = ContentModel.fromJson(json, ContentType.dua);

      expect(model.id, '1');
      expect(model.type, ContentType.dua);
      expect(model.arabicText, 'بِسْمِ اللَّهِ');
      expect(model.translation, 'In the name of Allah');
      expect(model.transliteration, 'Bismillah');
      expect(model.title, 'Before eating');
      expect(model.titleAr, 'قبل الأكل');
      expect(model.source, 'Sahih Bukhari');
      expect(model.categoryId, 'food');
      expect(model.isSaved, isTrue);
    });

    test('getTitle returns Arabic for ar locale', () {
      final model = ContentModel.fromJson({
        'id': '1',
        'arabic_text': 'text',
        'title': 'English Title',
        'title_ar': 'العنوان العربي',
      }, ContentType.dua);

      expect(model.getTitle('en'), 'English Title');
      expect(model.getTitle('ar'), 'العنوان العربي');
    });
  });

  group('VerseModel', () {
    test('fromJson parses verse correctly', () {
      final json = {
        'id': '2:255',
        'arabic_text': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'translation': 'Allah - there is no deity except Him, the Ever-Living',
        'surah_number': 2,
        'surah_name': 'Al-Baqarah',
        'surah_name_ar': 'البقرة',
        'verse_number': 255,
        'juz_number': 3,
        'page_number': 42,
      };

      final model = VerseModel.fromJson(json);

      expect(model.id, '2:255');
      expect(model.type, ContentType.verse);
      expect(model.surahNumber, 2);
      expect(model.surahName, 'Al-Baqarah');
      expect(model.surahNameAr, 'البقرة');
      expect(model.verseNumber, 255);
      expect(model.juzNumber, 3);
      expect(model.pageNumber, 42);
    });

    test('reference returns correct format', () {
      final model = VerseModel.fromJson({
        'id': '2:255',
        'arabic_text': 'text',
        'surah_name': 'Al-Baqarah',
        'verse_number': 255,
      });

      expect(model.reference, 'Al-Baqarah 255');
    });
  });

  group('HadithModel', () {
    test('fromJson parses hadith correctly', () {
      final json = {
        'id': '1',
        'arabic_text': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
        'translation': 'Actions are judged by intentions',
        'narrator': 'Umar ibn Al-Khattab',
        'narrator_ar': 'عمر بن الخطاب',
        'book_name': 'Sahih Bukhari',
        'book_name_ar': 'صحيح البخاري',
        'hadith_number': 1,
        'grade': 'Sahih',
        'grade_ar': 'صحيح',
      };

      final model = HadithModel.fromJson(json);

      expect(model.id, '1');
      expect(model.type, ContentType.hadith);
      expect(model.narrator, 'Umar ibn Al-Khattab');
      expect(model.narratorAr, 'عمر بن الخطاب');
      expect(model.bookName, 'Sahih Bukhari');
      expect(model.hadithNumber, 1);
      expect(model.grade, 'Sahih');
    });

    test('getNarrator returns localized narrator', () {
      final model = HadithModel.fromJson({
        'id': '1',
        'arabic_text': 'text',
        'narrator': 'Umar',
        'narrator_ar': 'عمر',
      });

      expect(model.getNarrator('en'), 'Umar');
      expect(model.getNarrator('ar'), 'عمر');
    });
  });

  group('DhikrModel', () {
    test('fromJson parses dhikr correctly', () {
      final json = {
        'id': '1',
        'arabic_text': 'سُبْحَانَ اللَّهِ',
        'translation': 'Glory be to Allah',
        'title': 'Tasbih',
        'repetition_count': 33,
        'virtue': 'Great reward',
        'timing': 'After prayer',
      };

      final model = DhikrModel.fromJson(json);

      expect(model.id, '1');
      expect(model.type, ContentType.dhikr);
      expect(model.arabicText, 'سُبْحَانَ اللَّهِ');
      expect(model.repetitionCount, 33);
      expect(model.virtue, 'Great reward');
      expect(model.timing, 'After prayer');
    });
  });

  group('CategoryModel', () {
    test('fromJson parses category correctly', () {
      final json = {
        'id': 'morning',
        'name': 'Morning Adhkar',
        'name_ar': 'أذكار الصباح',
        'description': 'Remembrance for the morning',
        'image_url': 'https://example.com/morning.jpg',
        'item_count': 15,
        'order': 1,
      };

      final model = CategoryModel.fromJson(json, type: ContentType.dhikr);

      expect(model.id, 'morning');
      expect(model.name, 'Morning Adhkar');
      expect(model.nameAr, 'أذكار الصباح');
      expect(model.itemCount, 15);
      expect(model.order, 1);
      expect(model.type, ContentType.dhikr);
    });

    test('getName returns localized name', () {
      final model = CategoryModel.fromJson({
        'id': '1',
        'name': 'Morning',
        'name_ar': 'الصباح',
      });

      expect(model.getName('en'), 'Morning');
      expect(model.getName('ar'), 'الصباح');
    });
  });
}
