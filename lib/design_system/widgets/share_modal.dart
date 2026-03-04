import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

/// Share Modal Bottom Sheet
///
/// Reusable modal for sharing Islamic content (Dua, Hadith, Verse, Adhkar)
/// Supports both text and image sharing
class ShareModal extends StatefulWidget {
  const ShareModal({
    required this.title,
    required this.arabicText,
    this.transliteration,
    this.translation,
    this.source,
    super.key,
  });

  final String title;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String? source;

  @override
  State<ShareModal> createState() => _ShareModalState();
}

class _ShareModalState extends State<ShareModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.h3(color: colorScheme.onSurface),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      LucideIcons.x,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(text: 'Text'),
                Tab(text: 'Image'),
              ],
            ),

            // Content
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTextTab(colorScheme),
                  _buildImageTab(colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTab(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildContentPreview(colorScheme, forImage: false),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyText(context),
                  icon: const Icon(LucideIcons.copy, size: 18),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareText(),
                  icon: const Icon(LucideIcons.share2, size: 18),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageTab(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _shareKey,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: _buildContentPreview(colorScheme, forImage: true),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareImage(context),
              icon: const Icon(LucideIcons.share2, size: 18),
              label: const Text('Share as Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreview(ColorScheme colorScheme, {required bool forImage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Arabic Text
        Text(
          widget.arabicText,
          textAlign: TextAlign.center,
          style: AppTypography.h2(color: colorScheme.onSurface).copyWith(
            fontFamily: 'Amiri',
            height: 2.0,
            fontSize: forImage ? 24 : 20,
          ),
        ),
        if (widget.transliteration != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.transliteration!,
            textAlign: TextAlign.center,
            style: AppTypography.body(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        if (widget.translation != null) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              widget.translation!,
              textAlign: TextAlign.center,
              style: AppTypography.body(color: colorScheme.onSurface),
            ),
          ),
        ],
        if (widget.source != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.source!,
            textAlign: TextAlign.center,
            style: AppTypography.caption(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        if (forImage) ...[
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              'NooRly',
              style: AppTypography.body(
                color: colorScheme.primary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }

  void _copyText(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln(widget.arabicText);
    if (widget.transliteration != null) {
      buffer.writeln();
      buffer.writeln(widget.transliteration!);
    }
    if (widget.translation != null) {
      buffer.writeln();
      buffer.writeln(widget.translation!);
    }
    if (widget.source != null) {
      buffer.writeln();
      buffer.writeln('— ${widget.source!}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  void _shareText() {
    final buffer = StringBuffer();
    buffer.writeln(widget.arabicText);
    if (widget.transliteration != null) {
      buffer.writeln();
      buffer.writeln(widget.transliteration!);
    }
    if (widget.translation != null) {
      buffer.writeln();
      buffer.writeln(widget.translation!);
    }
    if (widget.source != null) {
      buffer.writeln();
      buffer.writeln('— ${widget.source!}');
    }
    buffer.writeln();
    buffer.writeln('Shared from NooRly');

    Share.share(buffer.toString());
    Navigator.pop(context);
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      // Find the RenderRepaintBoundary
      final boundary = _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      // Capture the image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Save to temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Share the image
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Shared from NooRly',
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Helper function to show the share modal
void showShareModal(
  BuildContext context, {
  required String title,
  required String arabicText,
  String? transliteration,
  String? translation,
  String? source,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ShareModal(
      title: title,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      source: source,
    ),
  );
}
