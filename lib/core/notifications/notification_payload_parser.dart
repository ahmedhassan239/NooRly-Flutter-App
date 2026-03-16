/// Parses notification tap payloads.
///
/// Every notification stores a JSON payload of the form:
/// ```json
/// { "type": "prayer", "sub_type": "fajr", "route": "/prayer-times", "extra": {} }
/// ```
library;

import 'dart:convert';

class NotificationPayload {
  const NotificationPayload({
    required this.type,
    required this.subType,
    required this.route,
    this.extra = const {},
  });

  final String type;
  final String subType;
  final String route;
  final Map<String, dynamic> extra;

  static NotificationPayload? tryParse(String? rawPayload) {
    if (rawPayload == null || rawPayload.isEmpty) return null;
    try {
      final map = jsonDecode(rawPayload) as Map<String, dynamic>;
      return NotificationPayload(
        type: map['type'] as String? ?? '',
        subType: map['sub_type'] as String? ?? '',
        route: map['route'] as String? ?? '/home',
        extra: (map['extra'] as Map<String, dynamic>?) ?? {},
      );
    } catch (_) {
      return null;
    }
  }

  static String encode({
    required String type,
    required String subType,
    required String route,
    Map<String, dynamic> extra = const {},
  }) {
    return jsonEncode({
      'type': type,
      'sub_type': subType,
      'route': route,
      'extra': extra,
    });
  }
}
