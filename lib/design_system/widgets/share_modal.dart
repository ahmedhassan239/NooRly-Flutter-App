import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/radius.dart';
import 'package:flutter_app/design_system/spacing.dart';
import 'package:flutter_app/design_system/typography.dart';
import 'package:flutter_app/design_system/widgets/library_share_image_card.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

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
              tabs: [
                Tab(text: l10n.shareModeText),
                Tab(text: l10n.shareModeImage),
              ],
            ),

            // Content
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTextTab(context, colorScheme),
                  _buildImageTab(context, colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTab(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildContentPreview(context, colorScheme),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyText(context),
                  icon: const Icon(LucideIcons.copy, size: 18),
                  label: Text(l10n.copy),
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
                  label: Text(l10n.share),
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

  Widget _buildImageTab(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final lc = Localizations.localeOf(context).languageCode;
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: widget.arabicText,
      translation: widget.translation ?? '',
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _shareKey,
              child: LibraryShareImageCard(
                badgeLabel: '',
                primaryBody: primary,
                sourcePlain: widget.source ?? '',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareImage(context),
              icon: const Icon(LucideIcons.share2, size: 18),
              label: Text(l10n.shareAsImage),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreview(BuildContext context, ColorScheme colorScheme) {
    final lc = Localizations.localeOf(context).languageCode;
    final dir = LocalizedReligiousContent.textDirectionFor(lc);
    final useArabic = LocalizedReligiousContent.useArabicTypography(lc);
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: widget.arabicText,
      translation: widget.translation ?? '',
    );

    return Directionality(
      textDirection: dir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            primary,
            textAlign: TextAlign.center,
            style: useArabic
                ? AppTypography.arabicH2(color: colorScheme.onSurface)
                    .copyWith(height: 2.0, fontSize: 20)
                : AppTypography.body(color: colorScheme.onSurface).copyWith(
                    height: 1.65,
                    fontSize: 18,
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
        if (widget.translation != null &&
            widget.translation!.trim().isNotEmpty &&
            useArabic) ...[
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
        if (widget.source != null && widget.source!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            '— ${widget.source!.trim()}',
            textAlign: TextAlign.center,
            style: AppTypography.caption(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    ),
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
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copiedToClipboard),
        duration: const Duration(seconds: 2),
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
