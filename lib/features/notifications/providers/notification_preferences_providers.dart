/// Riverpod providers for notification preferences.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/notifications/data/notification_preferences_repository_impl.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_entity.dart';
import 'package:flutter_app/features/notifications/domain/notification_preferences_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repository provider.
final notificationPreferencesRepositoryProvider =
    Provider<NotificationPreferencesRepository>((ref) {
  return NotificationPreferencesRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

/// Load preferences from API + cache.
final notificationPreferencesProvider =
    FutureProvider<NotificationPreferencesEntity>((ref) async {
  final repo = ref.watch(notificationPreferencesRepositoryProvider);
  return repo.getPreferences();
});

/// Mutable notifier for editing notification preferences.
class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferencesEntity> {
  NotificationPreferencesNotifier(this._ref)
      : super(const NotificationPreferencesEntity()) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final repo = _ref.read(notificationPreferencesRepositoryProvider);
    state = await repo.getLocalPreferences();
  }

  /// Update state locally, then sync to API + reschedule notifications.
  Future<void> update(NotificationPreferencesEntity prefs) async {
    state = prefs;
    final repo = _ref.read(notificationPreferencesRepositoryProvider);
    await repo.saveLocalPreferences(prefs);
    repo.updatePreferences(prefs).ignore();

    // Reschedule all local notifications to reflect new prefs
    // (imported lazily to avoid circular deps)
    await _reschedule(prefs);
  }

  Future<void> _reschedule(NotificationPreferencesEntity prefs) async {
    if (kIsWeb) return;
    // Reschedule non-prayer notifications immediately.
    // Prayer notifications need live prayer times; those are passed from
    // notification_settings_page when the user explicitly saves, or from
    // the prayer page when it triggers a full reschedule.
    await NotificationService.instance.rescheduleNonPrayer(prefs);
  }
}

final notificationPreferencesNotifierProvider = StateNotifierProvider<
    NotificationPreferencesNotifier, NotificationPreferencesEntity>((ref) {
  return NotificationPreferencesNotifier(ref);
});
