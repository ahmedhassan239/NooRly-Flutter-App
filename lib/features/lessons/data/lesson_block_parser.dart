/// Parses lesson content into [LessonBlock] lists from two sources:
///
///   1. New API format — `blocks` JSON array from backend.
///   2. Legacy format  — `content` Markdown string + separate
///                        `quranVerses` / `hadithItems` arrays.
///
/// The screen never knows which path was taken; it always gets a
/// `List<LessonBlock>` ready to feed into `LessonRenderer`.
library;

import 'package:flutter_app/features/lessons/domain/models/lesson_block.dart';
import 'package:flutter_app/features/lessons/data/lesson_quran_hadith_parser.dart';

// ── Public API ────────────────────────────────────────────────────────────────

/// Entry point: call this from both [LessonModel.fromJson] and the repository.
///
/// Priority:
///   `blocks` key present → parse structured blocks (may append legacy
///   quranVerses / hadithItems if the blocks list contains none).
///   No `blocks` key     → convert Markdown `content` + verse/hadith data.
List<LessonBlock> parseBlocks(Map<String, dynamic> json) {
  final rawBlocks = json['blocks'];

  if (rawBlocks is List && rawBlocks.isNotEmpty) {
    final blocks = <LessonBlock>[];
    for (final item in rawBlocks) {
      if (item is Map<String, dynamic>) {
        final block = _blockFromJson(item);
        if (block != null) blocks.add(block);
      }
    }
    // Append legacy verse/hadith arrays if the blocks list has none.
    if (!blocks.any((b) => b is VerseBlock)) {
      blocks.addAll(_versesFromJson(json));
    }
    if (!blocks.any((b) => b is HadithBlock)) {
      blocks.addAll(_hadithFromJson(json));
    }
    return blocks;
  }

  // Legacy path: detect content format then route appropriately.
  final content = _contentString(json);

  // HTML from backend (inline styles, tags) → flutter_html fallback.
  // MarkdownToBlocks cannot parse HTML; it would produce a single
  // ParagraphBlock containing the raw tag string, which renders as text.
  if (_isHtml(content)) {
    return [HtmlBlock(html: content)];
    // Note: verses/hadith are intentionally NOT appended here because
    // the HTML already contains them. Appending would duplicate them.
  }

  // Plain Markdown (local assets) → native block widgets.
  final blocks = MarkdownToBlocks.convert(content);
  blocks.addAll(_versesFromJson(json));
  blocks.addAll(_hadithFromJson(json));
  return blocks;
}

/// Returns true when [s] looks like HTML rather than Markdown.
/// HTML from this backend always contains inline-styled tags.
bool _isHtml(String s) {
  if (s.trim().isEmpty) return false;
  // Decode any JSON-escaped newlines first, then check for tag presence.
  final t = s.trim();
  // A quick multi-tag probe is more reliable than startsWith('<') alone
  // because content can start with whitespace or a newline before the first tag.
  return t.contains(RegExp(
    r'<(h[1-6]|p|div|span|strong|em|ul|ol|li|blockquote|br|table)\b',
    caseSensitive: false,
  ));
}

// ── JSON block parser ─────────────────────────────────────────────────────────

LessonBlock? _blockFromJson(Map<String, dynamic> j) {
  final type = j['type'] as String? ?? '';
  switch (type) {
    case 'paragraph':
      final text = _str(j, 'text');
      return text.isEmpty ? null : ParagraphBlock(text: text);

    case 'heading':
      final text = _str(j, 'text');
      final level = (j['level'] as int?) ?? 2;
      return text.isEmpty ? null : HeadingBlock(text: text, level: level.clamp(1, 3));

    case 'list':
      final rawItems = j['items'];
      if (rawItems is! List) return null;
      final items = rawItems.whereType<String>().toList();
      return items.isEmpty
          ? null
          : ListBlock(
              items: items,
              ordered: (j['ordered'] as bool?) ?? false,
            );

    case 'verse':
      final translation = _str(j, 'translation');
      final reference = _str(j, 'reference');
      return (translation.isEmpty && reference.isEmpty)
          ? null
          : VerseBlock(
              translation: translation,
              reference: reference,
              arabic: _strOrNull(j, 'arabic'),
              transliteration: _strOrNull(j, 'transliteration'),
            );

    case 'hadith':
      final text = _str(j, 'text');
      final narrator = _str(j, 'narrator');
      return (text.isEmpty && narrator.isEmpty)
          ? null
          : HadithBlock(
              text: text,
              narrator: narrator,
              arabic: _strOrNull(j, 'arabic'),
              grade: _strOrNull(j, 'grade'),
            );

    case 'callout':
      final text = _str(j, 'text');
      if (text.isEmpty) return null;
      final variant = _calloutVariant(j['variant'] as String? ?? 'tip');
      return CalloutBlock(
        text: text,
        variant: variant,
        title: _strOrNull(j, 'title'),
      );

    case 'step':
      final title = _str(j, 'title');
      final body = _str(j, 'body');
      if (title.isEmpty) return null;
      return StepBlock(
        number: (j['number'] as int?) ?? 1,
        title: title,
        body: body,
      );

    case 'quote':
      final text = _str(j, 'text');
      return text.isEmpty
          ? null
          : QuoteBlock(text: text, source: _strOrNull(j, 'source'));

    case 'reflection':
      final prompt = _str(j, 'prompt');
      return prompt.isEmpty ? null : ReflectionBlock(prompt: prompt);

    case 'reminder':
      final text = _str(j, 'text');
      return text.isEmpty
          ? null
          : ReminderBlock(text: text, title: _strOrNull(j, 'title'));

    case 'divider':
      return const DividerBlock();

    default:
      return null;
  }
}

CalloutVariant _calloutVariant(String s) => switch (s) {
      'info'    => CalloutVariant.info,
      'warning' => CalloutVariant.warning,
      'success' => CalloutVariant.success,
      _         => CalloutVariant.tip,
    };

// ── Legacy verse / hadith → block converters ─────────────────────────────────

List<VerseBlock> _versesFromJson(Map<String, dynamic> json) {
  final raw = json['quranVerses'] ??
      json['quran_verses'] ??
      json['quranAyahs'] ??
      json['quran_ayahs'] ??
      json['ayahs'];
  final verses = parseQuranVersesFromJson(raw);
  return verses
      .map(
        (v) => VerseBlock(
          translation: v.textEn,
          reference: v.reference,
        ),
      )
      .toList();
}

List<HadithBlock> _hadithFromJson(Map<String, dynamic> json) {
  final raw = json['hadithItems'] ??
      json['hadith_items'] ??
      json['hadith'] ??
      json['hadiths'];
  final items = parseHadithItemsFromJson(raw);
  return items
      .map(
        (h) => HadithBlock(
          text: h.textEn,
          narrator: h.reference,
        ),
      )
      .toList();
}

// ── Markdown → blocks converter ───────────────────────────────────────────────

/// Converts a Markdown string into [LessonBlock]s.
///
/// Supported syntax:
///   # / ## / ###  → [HeadingBlock]
///   > text        → [QuoteBlock]
///   - or * items  → [ListBlock] (unordered)
///   1. items      → [ListBlock] (ordered)
///   ---           → [DividerBlock]
///   (everything else) → [ParagraphBlock] (may contain **bold** / *italic*)
class MarkdownToBlocks {
  MarkdownToBlocks._();

  static final _orderedRe = RegExp(r'^\d+\. (.+)$');

  static List<LessonBlock> convert(String markdown) {
    if (markdown.trim().isEmpty) return const [];

    final blocks = <LessonBlock>[];
    final lines = markdown.split('\n');

    List<String>? listItems;
    bool listOrdered = false;
    final paraLines = <String>[];

    void flushParagraph() {
      if (paraLines.isEmpty) return;
      final text = paraLines.join(' ').trim();
      if (text.isNotEmpty) blocks.add(ParagraphBlock(text: text));
      paraLines.clear();
    }

    void flushList() {
      if (listItems == null || listItems!.isEmpty) return;
      blocks.add(ListBlock(items: List.unmodifiable(listItems!), ordered: listOrdered));
      listItems = null;
    }

    for (final raw in lines) {
      final line = raw.trim();

      if (line.isEmpty) {
        flushParagraph();
        flushList();
        continue;
      }

      // Headings
      if (line.startsWith('### ')) {
        flushParagraph(); flushList();
        blocks.add(HeadingBlock(text: line.substring(4), level: 3));
        continue;
      }
      if (line.startsWith('## ')) {
        flushParagraph(); flushList();
        blocks.add(HeadingBlock(text: line.substring(3), level: 2));
        continue;
      }
      if (line.startsWith('# ')) {
        flushParagraph(); flushList();
        blocks.add(HeadingBlock(text: line.substring(2), level: 1));
        continue;
      }

      // Blockquote → QuoteBlock
      if (line.startsWith('> ')) {
        flushParagraph(); flushList();
        blocks.add(QuoteBlock(text: line.substring(2)));
        continue;
      }

      // Divider
      if (line == '---' || line == '***' || line == '___') {
        flushParagraph(); flushList();
        blocks.add(const DividerBlock());
        continue;
      }

      // Unordered list
      if (line.startsWith('- ') || line.startsWith('* ')) {
        flushParagraph();
        if (listOrdered) { flushList(); }
        listItems ??= [];
        listOrdered = false;
        listItems!.add(line.substring(2));
        continue;
      }

      // Ordered list
      final orderedMatch = _orderedRe.firstMatch(line);
      if (orderedMatch != null) {
        flushParagraph();
        if (!listOrdered) { flushList(); }
        listItems ??= [];
        listOrdered = true;
        listItems!.add(orderedMatch.group(1)!);
        continue;
      }

      // Everything else → paragraph line
      flushList();
      paraLines.add(line);
    }

    flushParagraph();
    flushList();
    return blocks;
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _str(Map<String, dynamic> j, String key) =>
    (j[key] as String? ?? '').trim();

String? _strOrNull(Map<String, dynamic> j, String key) {
  final v = j[key] as String?;
  return (v == null || v.trim().isEmpty) ? null : v.trim();
}

String _contentString(Map<String, dynamic> json) {
  final raw = json['content'];
  if (raw == null) return '';
  final s = (raw is String ? raw : raw.toString());
  return s.replaceAll(r'\n', '\n');
}
