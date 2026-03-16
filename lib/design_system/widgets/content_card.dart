import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Content Type
enum ContentType { dua, hadith, verse, adhkar }

/// Content Card
///
/// Reusable card for displaying duas, hadith, Quran verses, and adhkar
/// with save, copy, share, and listen functionality
class ContentCard extends StatefulWidget {
  const ContentCard({
    required this.id,
    required this.arabic,
    required this.translation,
    required this.source,
    required this.type,
    this.transliteration,
    this.category,
    this.repetitions,
    this.featured = false,
    super.key,
  });

  final String id;
  final String arabic;
  final String? transliteration;
  final String translation;
  final String source;
  final ContentType type;
  final String? category;
  final int? repetitions;
  final bool featured;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _saved = false;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = _getStorageKey();
    final savedItems = prefs.getStringList(storageKey) ?? [];
    if (mounted) {
      setState(() {
        _saved = savedItems.contains(widget.id);
      });
    }
  }

  String _getStorageKey() {
    switch (widget.type) {
      case ContentType.dua:
        return 'savedDuas';
      case ContentType.hadith:
        return 'savedHadith';
      case ContentType.verse:
        return 'savedVerses';
      case ContentType.adhkar:
        return 'savedAdhkar';
    }
  }

  Future<void> _handleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = _getStorageKey();
    final savedItems = prefs.getStringList(storageKey) ?? [];

    if (_saved) {
      savedItems.remove(widget.id);
    } else {
      savedItems.add(widget.id);
    }

    await prefs.setStringList(storageKey, savedItems);

    if (mounted) {
      setState(() {
        _saved = !_saved;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _saved ? 'Saved successfully' : 'Removed from saved',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleCopy() async {
    final text = [
      widget.arabic,
      if (widget.transliteration != null) widget.transliteration!,
      widget.translation,
      '— ${widget.source}',
    ].join('\n\n');

    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      setState(() {
        _copied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Copied to clipboard',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _copied = false;
          });
        }
      });
    }
  }

  void _handleShare() {
    ShareContentDialog.show(
      context,
      ShareableContent(
        id: widget.id,
        arabic: widget.arabic,
        transliteration: widget.transliteration ?? '',
        translation: widget.translation,
        source: widget.source,
        title: 'Share $_typeLabel',
      ),
    );
  }

  String get _typeLabel {
    switch (widget.type) {
      case ContentType.dua:
        return 'Dua';
      case ContentType.hadith:
        return 'Hadith';
      case ContentType.verse:
        return 'Verse';
      case ContentType.adhkar:
        return 'Dhikr';
    }
  }

  Color get _typeColor {
    switch (widget.type) {
      case ContentType.dua:
        return AppColors.primary;
      case ContentType.hadith:
        return const Color(0xFFD97706); // Amber
      case ContentType.verse:
        return const Color(0xFF059669); // Emerald
      case ContentType.adhkar:
        return const Color(0xFF7C3AED); // Purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: widget.featured
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primarySoftPurple.withValues(alpha: 0.05),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              )
            : null,
        color: widget.featured ? null : AppColors.card,
        border: Border.all(
          color: widget.featured
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with type badge and repetitions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  _typeLabel,
                  style: AppTypography.caption(color: _typeColor)
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (widget.repetitions != null)
                Text(
                  'Say ${widget.repetitions}x',
                  style: AppTypography.caption(color: AppColors.mutedForeground),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Arabic text
          Text(
            widget.arabic,
            style: AppTypography.arabicH2(color: AppColors.foreground),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),

          if (widget.transliteration != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.transliteration!,
              style: AppTypography.bodySm(color: AppColors.primary)
                  .copyWith(fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Translation
          Text(
            '"${widget.translation}"',
            style: AppTypography.bodySm(color: AppColors.mutedForeground),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Source
          Text(
            '— ${widget.source}',
            style: AppTypography.caption(
              color: AppColors.mutedForeground.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Action buttons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionButton(
                icon: _saved ? LucideIcons.heart : LucideIcons.heart,
                label: _saved ? 'Saved' : 'Save',
                onPressed: _handleSave,
                filled: _saved,
                color: _saved ? AppColors.accentGreen : null,
              ),
              _ActionButton(
                icon: _copied ? LucideIcons.check : LucideIcons.copy,
                label: _copied ? 'Copied' : 'Copy',
                onPressed: _handleCopy,
              ),
              _ActionButton(
                icon: LucideIcons.share2,
                label: 'Share',
                onPressed: _handleShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.foreground;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveColor,
        backgroundColor:
            filled ? effectiveColor.withValues(alpha: 0.1) : Colors.transparent,
        side: BorderSide(
          color: filled ? effectiveColor : AppColors.border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(70, 32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption(color: effectiveColor)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
