/// Reusable Save/Saved button for dua cards.
/// Uses unified saved feature providers with auth check.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved/presentation/widgets/save_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Save/Saved action button for a dua card.
/// Delegates to generic [SaveButton] with type='dua'.
class SaveDuaButton extends ConsumerWidget {
  const SaveDuaButton({
    required this.duaId,
    super.key,
    this.compact = false,
  });

  /// Dua ID (string or int)
  final dynamic duaId;

  /// If true, use smaller padding and font.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveButton(
      type: 'dua',
      itemId: duaId,
      compact: compact,
    );
  }
}
