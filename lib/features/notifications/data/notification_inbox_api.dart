import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';

/// In-app notification inbox (admin campaigns + future sources).
class NotificationInboxItem {
  const NotificationInboxItem({
    required this.id,
    required this.title,
    required this.body,
    this.route,
    required this.isRead,
    this.campaignId,
    this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final String? route;
  final bool isRead;
  final int? campaignId;
  final DateTime? createdAt;

  static NotificationInboxItem? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id == null) return null;
    return NotificationInboxItem(
      id: id is int ? id : int.tryParse(id.toString()) ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      route: json['route'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      campaignId: json['campaign_id'] is int
          ? json['campaign_id'] as int
          : int.tryParse(json['campaign_id']?.toString() ?? ''),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

Future<List<NotificationInboxItem>> fetchNotificationInbox(ApiClient client,
    {int page = 1, int perPage = 30}) async {
  final response = await client.get<Map<String, dynamic>>(
    NotificationInboxEndpoints.list,
    queryParameters: <String, dynamic>{'page': page, 'per_page': perPage},
    fromJson: (data) => data as Map<String, dynamic>,
  );
  if (!response.status || response.data == null) return [];
  final inner = response.data!;
  final items = inner['items'];
  if (items is! List) return [];
  return items
      .map((e) => e is Map<String, dynamic> ? NotificationInboxItem.fromJson(e) : null)
      .whereType<NotificationInboxItem>()
      .toList();
}

Future<void> markNotificationInboxRead(ApiClient client, int id) async {
  await client.patch<void>(NotificationInboxEndpoints.markRead(id));
}
