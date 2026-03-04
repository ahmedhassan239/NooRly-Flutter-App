/// Profile providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      _ref.read(authProvider.notifier).refreshUser();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> uploadAvatar(String filePath) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(profileRepositoryProvider).uploadAvatar(filePath);

      // Refresh profile
      _ref.invalidate(profileProvider);

      final profile = await _ref.read(profileRepositoryProvider).getProfile();
      state = AsyncValue.data(profile);

      // Update auth user
      _ref.read(authProvider.notifier).refreshUser();
    } catch (e, st) {
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
