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
import 'package:flutter_app/features/duas/presentation/widgets/share_tab_switch.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

/// Share Dua Dialog
///
/// A modal dialog for sharing Duas in Text or Image format.
/// Supports dark mode and Flutter Web.
class ShareDuaDialog extends StatefulWidget {
  const ShareDuaDialog({
    required this.dua,
    super.key,
  });

  final DuaData dua;

  /// Show the share dialog
  static Future<void> show(BuildContext context, DuaData dua) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ShareDuaDialog(dua: dua),
    );
  }

  @override
  State<ShareDuaDialog> createState() => _ShareDuaDialogState();
}

class _ShareDuaDialogState extends State<ShareDuaDialog> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${l10n.share} ${l10n.dua}',
              style: AppTypography.h2(color: colorScheme.onSurface),
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
      return DuaTextPreview(dua: widget.dua);
    } else {
      return RepaintBoundary(
        key: _imageCardKey,
        child: DuaImageCard(dua: widget.dua),
      );
    }
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
              child: Text(AppLocalizations.of(context)!.copy),
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
                _isGeneratingImage
                    ? AppLocalizations.of(context)!.shareGeneratingImage
                    : AppLocalizations.of(context)!.share,
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
    final text = DuaShareFormatter.formatText(
      widget.dua,
      lc,
      AppLocalizations.of(context)!,
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

      // On web, copy image as data URL
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // For web, we'll share instead of copy
        await _shareImageBytes(imageBytes);
      } else {
        // For mobile, copy to clipboard (requires image_picker or similar)
        // Fallback to share
        await _shareImageBytes(imageBytes);
      }
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
    final text = DuaShareFormatter.formatText(
      widget.dua,
      lc,
      AppLocalizations.of(context)!,
    );
    final l10n = AppLocalizations.of(context)!;
    await Share.share(
      text,
      subject: '${l10n.share} ${l10n.dua}',
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
      name: 'dua_${widget.dua.id}.png',
    );

    await Share.shareXFiles(
      [xFile],
      text: 'Daily Dua',
    );
  }
}

/// Share mode enum
enum ShareMode {
  text,
  image,
}
