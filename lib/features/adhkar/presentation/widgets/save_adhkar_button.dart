/// Reusable Save/Saved button for adhkar cards.
/// Uses unified saved feature providers with auth check.
library;

import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved/presentation/widgets/save_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Save/Saved action button for an adhkar card.
/// Delegates to generic [SaveButton] with type='adhkar'.
class SaveAdhkarButton extends ConsumerWidget {
  const SaveAdhkarButton({
    required this.adhkarId,
    super.key,
    this.compact = false,
  });

  /// Adhkar ID (string or int)
  final dynamic adhkarId;

  /// If true, use smaller padding and font.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveButton(
      type: 'adhkar',
      itemId: adhkarId,
      compact: compact,
    );
  }
}
