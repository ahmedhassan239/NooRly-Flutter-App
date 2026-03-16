/// Routes notification taps to the correct screen using go_router.
library;

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'notification_payload_parser.dart';

class NotificationRouter {
  NotificationRouter._();
  static final NotificationRouter instance = NotificationRouter._();

  GoRouter? _router;

  void init(GoRouter router) {
    _router = router;
  }

  void handleTap(NotificationPayload payload) {
    if (kIsWeb) return;
    final router = _router;
    if (router == null) {
      debugPrint('[NotificationRouter] Router not initialized yet; tap ignored');
      return;
    }

    debugPrint('[NotificationRouter] Routing tap: ${payload.type}/${payload.subType} → ${payload.route}');

    try {
      switch (payload.type) {
        case 'prayer':
          router.go('/prayer-times');
        case 'lesson':
          final lessonId = payload.extra['lesson_id'] as String?;
          if (lessonId != null && lessonId.isNotEmpty) {
            router.go('/lessons/$lessonId');
          } else {
            router.go('/home');
          }
        case 'dhikr':
          router.go('/adhkar');
        case 'occasion':
          if (payload.subType == 'friday') {
            router.go('/home');
          } else if (payload.subType == 'ramadan_approaching') {
            router.go('/ramadan');
          } else {
            router.go('/home');
          }
        case 'milestone':
          router.go('/home');
        case 'support':
          router.go('/need-help');
        default:
          router.go(payload.route.isNotEmpty ? payload.route : '/home');
      }
    } catch (e) {
      debugPrint('[NotificationRouter] Error routing: $e');
    }
  }
}
