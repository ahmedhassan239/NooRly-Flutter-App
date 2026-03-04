import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';
import 'package:flutter_app/features/duas/presentation/widgets/dua_share_formatter.dart';
import 'package:flutter_app/features/duas/presentation/widgets/dua_image_card.dart';
import 'package:flutter_app/features/duas/presentation/widgets/dua_text_preview.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_dua_dialog.dart';
import 'package:flutter_app/features/duas/presentation/widgets/share_tab_switch.dart';
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
    final title = widget.content.title ?? 'Share';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.h2(color: colorScheme.onSurface),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              LucideIcons.x,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, ColorScheme colorScheme) {
    if (_selectedMode == ShareMode.text) {
      return _buildTextPreview(colorScheme);
    } else {
      return RepaintBoundary(
        key: _imageCardKey,
        child: _buildImageCard(colorScheme),
      );
    }
  }

  Widget _buildTextPreview(ColorScheme colorScheme) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              widget.content.arabic,
              textAlign: TextAlign.center,
              style: AppTypography.arabicH1(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Transliteration
          Text(
            widget.content.transliteration,
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(color: colorScheme.primary)
                .copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Translation
          Text(
            '"${widget.content.translation}"',
            textAlign: TextAlign.center,
            style: AppTypography.body(
              color: colorScheme.onSurface.withValues(alpha: 0.9),
            ).copyWith(height: 1.6),
          ),
          const SizedBox(height: AppSpacing.md),
          // Footer
          Text(
            '— ${widget.content.source}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(ColorScheme colorScheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackground = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final arabicColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final transliterationColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
    final translationColor =
        isDark ? const Color(0xFFE5E7EB) : const Color(0xFF374151);
    final footerColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              widget.content.arabic,
              textAlign: TextAlign.center,
              style: AppTypography.arabicH1(color: arabicColor),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Transliteration
          Text(
            widget.content.transliteration,
            textAlign: TextAlign.center,
            style: AppTypography.body(color: transliterationColor)
                .copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Translation
          Text(
            '"${widget.content.translation}"',
            textAlign: TextAlign.center,
            style: AppTypography.body(color: translationColor)
                .copyWith(height: 1.7),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Footer
          Text(
            '— ${widget.content.source}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm(color: footerColor)
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
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
              child: const Text('Copy'),
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
                _isGeneratingImage ? 'Generating...' : 'Share',
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
    final duaData = DuaData(
      id: widget.content.id,
      arabic: widget.content.arabic,
      transliteration: widget.content.transliteration,
      translation: widget.content.translation,
      source: widget.content.source,
    );
    final text = DuaShareFormatter.formatText(duaData);
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard!'),
          duration: Duration(seconds: 2),
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
    final duaData = DuaData(
      id: widget.content.id,
      arabic: widget.content.arabic,
      transliteration: widget.content.transliteration,
      translation: widget.content.translation,
      source: widget.content.source,
    );
    final text = DuaShareFormatter.formatText(duaData);
    await Share.share(
      text,
      subject: widget.content.title ?? 'Daily Content',
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
