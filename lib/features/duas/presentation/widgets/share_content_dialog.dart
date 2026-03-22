import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/widgets/dua_image_card.dart';
import 'package:flutter_app/features/duas/presentation/widgets/dua_text_preview.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_dua_dialog.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_tab_switch.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

/// Shareable Content Interface
///
/// Common interface for all shareable content types (Dua, Hadith, Verse, Adhkar)
class ShareableContent {
  const ShareableContent({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    this.title,
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final String? title;
}

/// Share Content Dialog
///
/// A generic modal dialog for sharing content (Dua, Hadith, Verse, Adhkar)
/// in Text or Image format. Supports dark mode and Flutter Web.
class ShareContentDialog extends StatefulWidget {
  const ShareContentDialog({
    required this.content,
    super.key,
  });

  final ShareableContent content;

  /// Show the share dialog
  static Future<void> show(BuildContext context, ShareableContent content) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ShareContentDialog(content: content),
    );
  }

  @override
  State<ShareContentDialog> createState() => _ShareContentDialogState();
}

class _ShareContentDialogState extends State<ShareContentDialog> {
  ShareMode _selectedMode = ShareMode.text;
  bool _isGeneratingImage = false;
  final GlobalKey _imageCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, colorScheme),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tab Switch
                    ShareTabSwitch(
                      selectedMode: _selectedMode,
                      onModeChanged: (mode) {
                        setState(() {
                          _selectedMode = mode;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Preview Content
                    _buildPreviewContent(context, colorScheme),
                  ],
                ),
              ),
            ),
            // Footer Buttons
            _buildFooter(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.content.title ?? l10n.share;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.h2(color: colorScheme.onSurface),
              textAlign: TextAlign.start,
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, ColorScheme colorScheme) {
    if (_selectedMode == ShareMode.text) {
      return _buildTextPreview(context, colorScheme);
    } else {
      return RepaintBoundary(
        key: _imageCardKey,
        child: _buildImageCard(context, colorScheme),
      );
    }
  }

  Widget _buildTextPreview(BuildContext context, ColorScheme colorScheme) {
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: widget.content.arabic,
      translation: widget.content.translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Directionality(
        textDirection: dir,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              primary,
              textAlign: TextAlign.center,
              style: useArabic
                  ? AppTypography.arabicH1(color: colorScheme.onSurface)
                  : AppTypography.body(
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                    ).copyWith(height: 1.6),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '— ${widget.content.source}',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, ColorScheme colorScheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: widget.content.arabic,
      translation: widget.content.translation,
    );
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);

    final cardBackground = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bodyColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final footerColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Directionality(
        textDirection: dir,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              primary,
              textAlign: TextAlign.center,
              style: useArabic
                  ? AppTypography.arabicH1(color: bodyColor)
                  : AppTypography.body(color: bodyColor).copyWith(height: 1.7, fontSize: 22),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '— ${widget.content.source}',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm(color: footerColor)
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // Copy Button
          Expanded(
            child: OutlinedButton(
              onPressed: _handleCopy,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: Text(l10n.copy),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Share Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isGeneratingImage ? null : _handleShare,
              icon: _isGeneratingImage
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Icon(
                      LucideIcons.share2,
                      size: 18,
                      color: colorScheme.onPrimary,
                    ),
              label: Text(
                _isGeneratingImage ? l10n.shareGeneratingImage : l10n.share,
                style: AppTypography.body(color: colorScheme.onPrimary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCopy() async {
    if (_selectedMode == ShareMode.text) {
      await _copyText();
    } else {
      await _copyImage();
    }
  }

  Future<void> _copyText() async {
    final lc = Localizations.localeOf(context).languageCode;
    final text = LocalizedReligiousContent.composePlainText(
      languageCode: lc,
      arabic: widget.content.arabic,
      translation: widget.content.translation,
      source: widget.content.source,
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.copiedToClipboard),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _copyImage() async {
    if (!mounted) return;

    setState(() {
      _isGeneratingImage = true;
    });

    try {
      final imageBytes = await _generateImageBytes();
      if (imageBytes == null || !mounted) return;

      // On web, share instead of copy
      await _shareImageBytes(imageBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingImage = false;
        });
      }
    }
  }

  Future<void> _handleShare() async {
    if (_selectedMode == ShareMode.text) {
      await _shareText();
    } else {
      await _shareImage();
    }
  }

  Future<void> _shareText() async {
    final lc = Localizations.localeOf(context).languageCode;
    final text = LocalizedReligiousContent.composePlainText(
      languageCode: lc,
      arabic: widget.content.arabic,
      translation: widget.content.translation,
      source: widget.content.source,
    );
    await Share.share(
      text,
      subject: widget.content.title ?? AppLocalizations.of(context)!.share,
    );
  }

  Future<void> _shareImage() async {
    if (!mounted) return;

    setState(() {
      _isGeneratingImage = true;
    });

    try {
      final imageBytes = await _generateImageBytes();
      if (imageBytes == null || !mounted) return;

      await _shareImageBytes(imageBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingImage = false;
        });
      }
    }
  }

  Future<Uint8List?> _generateImageBytes() async {
    try {
      final RenderRepaintBoundary? renderObject =
          _imageCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (renderObject == null) return null;

      final image = await renderObject.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> _shareImageBytes(Uint8List imageBytes) async {
    final xFile = XFile.fromData(
      imageBytes,
      mimeType: 'image/png',
      name: 'content_${widget.content.id}.png',
    );

    await Share.shareXFiles(
      [xFile],
      text: widget.content.title ?? 'Daily Content',
    );
  }
}
