/// Profile feature providers (profile fetch, avatar upload, header helpers).
library;

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_app/features/profile/domain/repositories/profile_repository.dart';

/// Repository provider for profile APIs.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});

/// Cached/network profile payload.
final profileProvider = FutureProvider<ProfileEntity>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile();
});

/// Bumped after avatar upload to force fresh image URL and bypass cache.
final avatarImageCacheNonceProvider = StateProvider<int>((ref) => 0);

/// Resolve avatar path and append cache-busting nonce.
String? avatarImageNetworkUrl(String? avatarUrl, int cacheNonce) {
  final resolved = ApiConfig.resolvePublicUrl(avatarUrl);
  if (resolved == null || resolved.isEmpty) return null;
  if (cacheNonce <= 0) return resolved;
  final sep = resolved.contains('?') ? '&' : '?';
  return '$resolved${sep}v=$cacheNonce';
}

/// State notifier for profile updates (avatar upload).
class UpdateProfileNotifier extends StateNotifier<AsyncValue<void>> {
  UpdateProfileNotifier({
    required Ref ref,
    required ProfileRepository repository,
  })  : _ref = ref,
        _repository = repository,
        super(const AsyncData<void>(null));

  final Ref _ref;
  final ProfileRepository _repository;

  Future<void> uploadAvatar({
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final uploaded = await _repository.uploadAvatar(
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      // Update auth state immediately so UI refreshes before /me roundtrip.
      final current = _ref.read(currentUserProvider);
      final nextUser = current == null
          ? uploaded
          : current.copyWith(
              avatarUrl: uploaded.avatarUrl,
              updatedAt: uploaded.updatedAt,
            );
      _ref.read(authProvider.notifier).updateUser(nextUser);

      // Force Image.network rebuild and URL cache bust.
      _ref.read(avatarImageCacheNonceProvider.notifier).state++;

      // Refresh profile cache + auth payload.
      _ref.invalidate(profileProvider);
      await _ref.read(authProvider.notifier).refreshUser(
            avatarUrlOverride: uploaded.avatarUrl,
          );
    });
  }
}

final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<void>>((ref) {
  return UpdateProfileNotifier(
    ref: ref,
    repository: ref.watch(profileRepositoryProvider),
  );
});

class HomeHeaderDisplay {
  const HomeHeaderDisplay({
    required this.displayName,
  });

  final String displayName;
}

/// Header display model for Home screen.
final homeHeaderDisplayProvider = Provider<HomeHeaderDisplay>((ref) {
  final UserEntity? user = ref.watch(currentUserProvider);
  final raw = user?.displayName ?? '';
  final normalized = raw.trim();
  return HomeHeaderDisplay(displayName: normalized);
});

