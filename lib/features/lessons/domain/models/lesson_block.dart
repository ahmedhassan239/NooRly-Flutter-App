/// Sealed class hierarchy for structured lesson content blocks.
///
/// These are the canonical content types that the lesson renderer supports.
/// Backend sends a `blocks` JSON array; the parser hydrates it into this tree.
/// When blocks are absent (old content) the Markdown-to-blocks converter
/// produces the same types, so the renderer is format-agnostic.
library;

/// All block variants the lesson renderer can render.
sealed class LessonBlock {
  const LessonBlock();
}

// ── Text blocks ──────────────────────────────────────────────────────────────

/// Plain prose paragraph. [text] may contain inline `**bold**` / `*italic*`.
class ParagraphBlock extends LessonBlock {
  const ParagraphBlock({required this.text});
  final String text;
}

/// ATX-style heading (h1–h3). Uses PlayfairDisplay font.
class HeadingBlock extends LessonBlock {
  const HeadingBlock({required this.text, required this.level});
  final String text;

  /// 1 = h1 (24 px), 2 = h2 (20 px), 3 = h3 (18 px).
  final int level;
}

/// Bullet or numbered list.
class ListBlock extends LessonBlock {
  const ListBlock({required this.items, required this.ordered});
  final List<String> items;
  final bool ordered;
}

// ── Islamic content cards ────────────────────────────────────────────────────

/// Quran verse card: emerald palette, right-aligned Arabic, reference footer.
class VerseBlock extends LessonBlock {
  const VerseBlock({
    required this.translation,
    required this.reference,
    this.arabic,
    this.transliteration,
  });
  final String translation;
  final String reference;
  final String? arabic;
  final String? transliteration;
}

/// Hadith card: gold palette, right-aligned Arabic, narrator footer.
class HadithBlock extends LessonBlock {
  const HadithBlock({
    required this.text,
    required this.narrator,
    this.arabic,
    this.grade,
  });
  final String text;
  final String narrator;
  final String? arabic;
  final String? grade;
}

// ── Callout / info blocks ────────────────────────────────────────────────────

enum CalloutVariant { tip, info, warning, success }

/// Tinted left-bordered callout card (tip / info / warning / success).
class CalloutBlock extends LessonBlock {
  const CalloutBlock({
    required this.text,
    required this.variant,
    this.title,
  });
  final String text;
  final CalloutVariant variant;
  final String? title;
}

// ── Pedagogical blocks ───────────────────────────────────────────────────────

/// Numbered action step (Today's Step). Gold counter, bold title, body text.
class StepBlock extends LessonBlock {
  const StepBlock({
    required this.number,
    required this.title,
    required this.body,
  });
  final int number;
  final String title;
  final String body;
}

/// Highlighted pull-quote (gold left bar, italic text).
class QuoteBlock extends LessonBlock {
  const QuoteBlock({required this.text, this.source});
  final String text;
  final String? source;
}

/// Reflection question prompt (pen icon, muted background).
class ReflectionBlock extends LessonBlock {
  const ReflectionBlock({required this.prompt});
  final String prompt;
}

/// Closing reminder / du'a (warm amber, centered, moon icon).
class ReminderBlock extends LessonBlock {
  const ReminderBlock({required this.text, this.title});
  final String text;
  final String? title;
}

// ── Structural blocks ────────────────────────────────────────────────────────

/// Horizontal section divider.
class DividerBlock extends LessonBlock {
  const DividerBlock();
}

// ── Legacy HTML fallback ──────────────────────────────────────────────────────

/// Raw HTML from the backend when no `blocks` key is present.
/// Rendered by [LessonHtmlContent] (flutter_html) as a safe fallback.
/// Will be removed once the backend emits structured `blocks`.
class HtmlBlock extends LessonBlock {
  const HtmlBlock({required this.html});
  final String html;
}
