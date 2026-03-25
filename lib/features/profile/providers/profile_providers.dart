/// Profile providers.
library;

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_app/features/profile/domain/repositories/profile_repository.dart';

/// Profile repository provider.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepositoryImpl(apiClient: apiClient);
});

/// Bumped after avatar upload to bust browser/image cache for the same base URL.
final avatarImageCacheNonceProvider = StateProvider<int>((ref) => 0);

/// Public URL for avatar widgets; increment [cacheNonce] after uploads to bust web image cache.
String? avatarImageNetworkUrl(String? avatarPathOrUrl, int cacheNonce) {
  if (avatarPathOrUrl == null) return null;
  final trimmed = avatarPathOrUrl.trim();
  if (trimmed.isEmpty) return null;
  final base = ApiConfig.resolvePublicUrl(trimmed) ?? trimmed;
  if (cacheNonce <= 0) return base;
  final sep = base.contains('?') ? '&' : '?';
  return '$base${sep}_nc=$cacheNonce';
}

/// Profile provider.
final profileProvider = FutureProvider<ProfileEntity>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);

  // Try cached data first
  final cached = await repository.getCachedProfile();
  if (cached != null) {
    // Refresh in background
    repository.getProfile().ignore();
    return cached;
  }

  return repository.getProfile();
});

/// Profile stats provider.
final profileStatsProvider = Provider<ProfileStatsEntity?>((ref) {
  final profileAsync = ref.watch(profileProvider);
  return profileAsync.maybeWhen(
    data: (profile) => profile.stats,
    orElse: () => null,
  );
});

/// Update profile notifier.
class UpdateProfileNotifier extends StateNotifier<AsyncValue<ProfileEntity?>> {
  UpdateProfileNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> update(UpdateProfileRequest request) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _ref.read(profileRepositoryProvider).updateProfile(request);
      state = AsyncValue.data(profile);

      // Refresh profile provider
      _ref.invalidate(profileProvider);

      // Update auth user if needed
      await _ref.read(authProvider.notifier).refreshUser();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> uploadAvatar({
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    state = const AsyncValue.loading();
    var stage = 'start';
    try {
      stage = 'uploadAvatar(api)';
      final uploaded = await _ref.read(profileRepositoryProvider).uploadAvatar(
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      if (kDebugMode) {
        debugPrint('[Avatar] upload response uploaded.avatarUrl: ${uploaded.avatarUrl}');
        debugPrint(
          '[Avatar] currentUser.avatarUrl before updateUser: ${_ref.read(currentUserProvider)?.avatarUrl}',
        );
      }

      final current = _ref.read(currentUserProvider);
      if (current != null) {
        stage = 'auth.updateUser(local)';
        _ref.read(authProvider.notifier).updateUser(
              current.copyWith(
                avatarUrl: uploaded.avatarUrl,
                updatedAt: uploaded.updatedAt ?? current.updatedAt,
              ),
            );
      }

      if (kDebugMode) {
        debugPrint(
          '[Avatar] currentUser.avatarUrl after updateUser: ${_ref.read(currentUserProvider)?.avatarUrl}',
        );
      }

      // Bump cache nonce immediately so avatar widgets request a fresh URL.
      stage = 'avatar.cacheNonce.bump';
      _ref.read(avatarImageCacheNonceProvider.notifier).state++;

      stage = 'profile.invalidate';
      _ref.invalidate(profileProvider);

      stage = 'profile.getProfile(refresh)';
      final profile = await _ref.read(profileRepositoryProvider).getProfile();
      state = AsyncValue.data(profile);

      if (kDebugMode) {
        debugPrint(
          '[Avatar] profile refreshed avatarUrl: ${profile.avatarUrl}',
        );
      }

      final authoritativeAvatar = uploaded.avatarUrl?.trim();
      stage = 'auth.refreshUser(server)';
      await _ref.read(authProvider.notifier).refreshUser(
            avatarUrlOverride:
                authoritativeAvatar != null && authoritativeAvatar.isNotEmpty
                    ? uploaded.avatarUrl
                    : null,
          );

      if (kDebugMode) {
        debugPrint(
          '[Avatar] currentUser.avatarUrl after refreshUser: ${_ref.read(currentUserProvider)?.avatarUrl}',
        );
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Avatar] uploadAvatar failed at stage=$stage');
        debugPrint('[Avatar] exception type=${e.runtimeType} message=$e');
        debugPrint('[Avatar] stack=$st');
      }
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(profileRepositoryProvider).deleteAccount();
      state = const AsyncValue.data(null);

      // Logout user
      await _ref.read(authProvider.notifier).logout();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Update profile provider.
final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<ProfileEntity?>>((ref) {
  return UpdateProfileNotifier(ref);
});

/// Refresh profile provider.
final refreshProfileProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(profileProvider);
  };
});

/// Home header display: display name and gender from current user (for greeting/title).
/// Rebuilds when auth/profile state changes. Use with getGreeting() and getDisplayNameWithTitle().
final homeHeaderDisplayProvider = Provider<HomeHeaderDisplay>((ref) {
  final user = ref.watch(currentUserProvider);
  final auth = ref.watch(authProvider);
  return HomeHeaderDisplay(
    displayName: user?.displayName ?? '',
    gender: user?.gender,
    isLoading: auth.isLoading,
  );
});

/// Data for the home screen header (name + title, greeting).
class HomeHeaderDisplay {
  const HomeHeaderDisplay({
    required this.displayName,
    this.gender,
    this.isLoading = false,
  });

  final String displayName;
  final String? gender;
  final bool isLoading;
}
