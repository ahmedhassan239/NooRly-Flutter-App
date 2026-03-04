/// Reusable Save/Saved button for hadith cards.
/// Uses unified saved feature providers with auth check.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved/presentation/widgets/save_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Save/Saved action button for a hadith card.
/// Delegates to generic [SaveButton] with type='hadith'.
class SaveHadithButton extends ConsumerWidget {
  const SaveHadithButton({
    required this.hadithId,
    super.key,
    this.compact = false,
  });

  final int hadithId;

  /// If true, use smaller padding and font (e.g. for collection list cards).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveButton(
      type: 'hadith',
      itemId: hadithId,
      compact: compact,
    );
  }
}
