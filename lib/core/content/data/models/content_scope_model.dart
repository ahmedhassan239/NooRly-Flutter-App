/// Content scope model with fromJson (snake_case and camelCase).
library;

import 'package:flutter_app/core/content/domain/entities/content_scope_entity.dart';

class ContentScopeModel {
  ContentScopeModel({
    required this.key,
    required this.label,
    this.iconKey,
    this.iconColor,
  });

  factory ContentScopeModel.fromJson(Map<String, dynamic> json) {
    return ContentScopeModel(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      iconKey: json['icon'] as String? ??
          json['icon_key'] as String? ??
          json['iconKey'] as String?,
      iconColor: json['color'] as String? ??
          json['icon_color'] as String? ??
          json['iconColor'] as String?,
    );
  }

  final String key;
  final String label;
  final String? iconKey;
  final String? iconColor;

  ContentScopeEntity toEntity() => ContentScopeEntity(
        key: key,
        label: label,
        iconKey: iconKey,
        iconColor: iconColor,
      );
}
