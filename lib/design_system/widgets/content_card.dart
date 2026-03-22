import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/colors.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_content_dialog.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _saved ? l10n.savedToFavorites : l10n.removedFromSaved,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleCopy() async {
    final lc = Localizations.localeOf(context).languageCode;
    final text = LocalizedReligiousContent.composePlainText(
      languageCode: lc,
      arabic: widget.arabic,
      translation: widget.translation,
      source: widget.source,
    );

    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      setState(() {
        _copied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.copiedToClipboard),
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
    final l10n = AppLocalizations.of(context)!;
    ShareContentDialog.show(
      context,
      ShareableContent(
        id: widget.id,
        arabic: widget.arabic,
        transliteration: widget.transliteration ?? '',
        translation: widget.translation,
        source: widget.source,
        title: '${l10n.share} ${_typeLabel(l10n)}',
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n) {
    switch (widget.type) {
      case ContentType.dua:
        return l10n.dua;
      case ContentType.hadith:
        return l10n.hadith;
      case ContentType.verse:
        return l10n.verse;
      case ContentType.adhkar:
        return l10n.adhkar;
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
    final l10n = AppLocalizations.of(context)!;
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: widget.arabic,
      translation: widget.translation,
    );
    final useArabicStyle = LocalizedReligiousContent.useArabicTypography(lc);

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
      child: Directionality(
        textDirection: dir,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    _typeLabel(l10n),
                    style: AppTypography.caption(color: _typeColor)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                if (widget.repetitions != null)
                  Text(
                    l10n.sayRepetition(widget.repetitions!),
                    style:
                        AppTypography.caption(color: AppColors.mutedForeground),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              primary,
              style: useArabicStyle
                  ? AppTypography.arabicH2(color: AppColors.foreground)
                  : AppTypography.bodySm(color: AppColors.foreground),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              '— ${widget.source}',
              style: AppTypography.caption(
                color: AppColors.mutedForeground.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  icon: _saved ? LucideIcons.heart : LucideIcons.heart,
                  label: _saved ? l10n.actionSaved : l10n.save,
                  onPressed: _handleSave,
                  filled: _saved,
                  color: _saved ? AppColors.accentGreen : null,
                ),
                _ActionButton(
                  icon: _copied ? LucideIcons.check : LucideIcons.copy,
                  label: _copied ? l10n.contentCopiedShort : l10n.copy,
                  onPressed: _handleCopy,
                ),
                _ActionButton(
                  icon: LucideIcons.share2,
                  label: l10n.share,
                  onPressed: _handleShare,
                ),
              ],
            ),
          ],
        ),
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
