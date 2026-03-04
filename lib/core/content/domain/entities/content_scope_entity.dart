/// Content scope entity (e.g. Duas, Hadith, Verses, Adhkar for Library tabs).
library;

import 'package:flutter/foundation.dart';

@immutable
class ContentScopeEntity {
  const ContentScopeEntity({
    required this.key,
    required this.label,
    this.iconKey,
    this.iconColor,
  });

  final String key;
  final String label;
  final String? iconKey;
  final String? iconColor;
}
