/// Fetches admin campaign deliveries pending app-pull and shows them as local notifications.
///
/// **Not background push**: only runs while the app process is alive (startup / resume).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/notifications/local_notification_scheduler.dart';
import 'package:flutter_app/core/notifications/notification_id_registry.dart';
import 'package:flutter_app/core/notifications/notification_payload_parser.dart';

/// Holds [ApiClient] for mark-read on notification tap (wired from the root `App` widget).
class PendingAdminCampaignBridge {
  PendingAdminCampaignBridge._();
  static final PendingAdminCampaignBridge instance = PendingAdminCampaignBridge._();

  ApiClient? _client;

  void attachClient(ApiClient? client) {
    _client = client;
  }

  Future<void> markRead(int deliveryId) async {
    final c = _client;
    if (c == null) return;
    try {
      await c.post<void>(UserPendingNotificationEndpoints.markRead(deliveryId));
      print('[AdminCampaignSync] mark-read OK delivery_id=$deliveryId');
    } catch (e) {
      print('[AdminCampaignSync] mark-read failed delivery_id=$deliveryId: $e');
    }
  }
}

/// In-memory: avoid re-showing the same delivery in one app session before mark-shown completes.
final Set<int> _sessionShownDeliveryIds = <int>{};

/// GET pending → show local → POST mark-shown.
Future<void> pullAndShowAdminCampaignNotifications(ApiClient client) async {
  if (kIsWeb) {
    print('[AdminCampaignSync] skip: web (no local notifications)');
    return;
  }
  if (!LocalNotificationScheduler.instance.isInitialized) {
    print('[AdminCampaignSync] skip: LocalNotificationScheduler not initialized');
    return;
  }

  try {
    final response = await client.get<Map<String, dynamic>>(
      UserPendingNotificationEndpoints.list,
      fromJson: (data) => data as Map<String, dynamic>,
    );
    if (!response.status || response.data == null) {
      print('[AdminCampaignSync] fetch: no data (status=${response.status})');
      return;
    }
    final items = response.data!['items'];
    if (items is! List) {
      print('[AdminCampaignSync] fetch: items not a list');
      return;
    }

    print('[AdminCampaignSync] fetched ${items.length} pending campaign(s)');

    for (final raw in items) {
      if (raw is! Map<String, dynamic>) continue;
      final idVal = raw['id'];
      final deliveryId = idVal is int ? idVal : int.tryParse(idVal?.toString() ?? '');
      if (deliveryId == null || deliveryId <= 0) continue;

      if (_sessionShownDeliveryIds.contains(deliveryId)) {
        continue;
      }

      final title = raw['title'] as String? ?? '';
      final body = raw['body'] as String? ?? '';
      final type = raw['type'] as String? ?? 'announcement';
      final route = (raw['route'] as String?)?.trim();
      final navRoute = (route != null && route.isNotEmpty) ? route : '/notifications/inbox';

      final notifId = NotificationIds.adminCampaignDelivery(deliveryId);
      final payload = NotificationPayload.encode(
        type: 'admin_campaign',
        subType: type,
        route: navRoute,
        extra: <String, dynamic>{'delivery_id': deliveryId},
      );

      try {
        await LocalNotificationScheduler.instance.showImmediate(
          id: notifId,
          title: title.isEmpty ? ' ' : title,
          body: body.isEmpty ? ' ' : body,
          channelId: LocalNotificationScheduler.channelAdminCampaigns,
          payload: payload,
        );
        print('[AdminCampaignSync] showed local notification id=$notifId delivery_id=$deliveryId');

        await client.post<void>(UserPendingNotificationEndpoints.markShown(deliveryId));
        print('[AdminCampaignSync] mark-shown OK delivery_id=$deliveryId');

        _sessionShownDeliveryIds.add(deliveryId);
      } catch (e) {
        print('[AdminCampaignSync] show/mark-shown failed delivery_id=$deliveryId: $e');
      }
    }
  } catch (e) {
    print('[AdminCampaignSync] fetch failed: $e');
  }
}
