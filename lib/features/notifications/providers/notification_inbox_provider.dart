import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/notifications/data/notification_inbox_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationInboxProvider =
    FutureProvider.autoDispose<List<NotificationInboxItem>>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return [];
  final client = ref.watch(apiClientProvider);
  return fetchNotificationInbox(client);
});
