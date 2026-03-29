import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/content/content_display_normalize.dart';

void main() {
  group('ContentDisplayNormalize.forDisplay', () {
    test('collapses multiple ASCII spaces to one', () {
      expect(
        ContentDisplayNormalize.forDisplay('Hello    world'),
        'Hello world',
      );
    });

    test('collapses NBSP and mixed spaces (wide gap fix)', () {
      const nbsp = '\u00A0';
      expect(
        ContentDisplayNormalize.forDisplay('Word1$nbsp$nbsp$nbsp Word2'),
        'Word1 Word2',
      );
    });

    test('collapses em space and thin space within a line', () {
      expect(
        ContentDisplayNormalize.forDisplay('A\u2003B\u2009C'),
        'A B C',
      );
    });

    test('preserves single newline between lines', () {
      expect(
        ContentDisplayNormalize.forDisplay('Line1\nLine2'),
        'Line1\nLine2',
      );
    });

    test('collapses 3+ newlines to at most double', () {
      expect(
        ContentDisplayNormalize.forDisplay('A\n\n\n\nB'),
        'A\n\nB',
      );
    });

    test('strips trailing comma runs', () {
      expect(
        ContentDisplayNormalize.forDisplay('Text,,,,'),
        'Text',
      );
    });

    test('HTML br and nbsp become normalized plain text', () {
      expect(
        ContentDisplayNormalize.forDisplay(
          'A&nbsp;&nbsp;B<br><br><br>C',
        ),
        'A B\n\nC',
      );
    });

    test('decodes numeric nbsp entity', () {
      expect(
        ContentDisplayNormalize.forDisplay('X&#160;&#160;Y'),
        'X Y',
      );
    });

    test('preserves ZWJ in Arabic (no shaping break)', () {
      const zwj = '\u200D';
      final s = ContentDisplayNormalize.forDisplay('ل${zwj}ا');
      expect(s.contains(zwj), isTrue);
    });

    test('empty paragraph tags do not add huge gaps', () {
      expect(
        ContentDisplayNormalize.forDisplay(
          '<p></p><p></p>Hello',
        ),
        'Hello',
      );
    });
  });
}
