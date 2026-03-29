import 'package:flutter/material.dart';
import 'package:flutter_app/core/content/library_reference_format.dart';
import 'package:flutter_app/core/content/localized_religious_content.dart';
import 'package:flutter_app/design_system/widgets/library_share_image_card.dart';
import 'package:flutter_app/l10n/generated/app_localizations.dart';
import 'package:flutter_app/features/duas/presentation/duas_mock_data.dart';

/// Shareable image card for a Dua (same template as other Library share images).
class DuaImageCard extends StatelessWidget {
  const DuaImageCard({
    required this.dua,
    super.key,
  });

  final DuaData dua;

  @override
  Widget build(BuildContext context) {
    final lc = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final primary = LocalizedReligiousContent.primaryBody(
      languageCode: lc,
      arabic: dua.arabic,
      translation: dua.translation,
    );
    final sourceLine = formatLooseReligiousSourceLine(
      l10n,
      lc,
      dua.source,
      sourceAr: dua.sourceAr,
    );

    return LibraryShareImageCard(
      badgeLabel: l10n.dua,
      primaryBody: primary,
      sourcePlain: sourceLine,
    );
  }
}
