/// Reusable Save/Saved button for verse cards.
/// Uses unified saved feature providers with auth check.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved/presentation/widgets/save_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Save/Saved action button for a verse card.
/// Delegates to generic [SaveButton] with type='verse'.
class SaveVerseButton extends ConsumerWidget {
  const SaveVerseButton({
    required this.verseId,
    super.key,
    this.compact = false,
  });

  final int verseId;

  /// If true, use smaller padding and font (e.g. for collection list cards).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveButton(
      type: 'verse',
      itemId: verseId,
      compact: compact,
    );
  }
}
