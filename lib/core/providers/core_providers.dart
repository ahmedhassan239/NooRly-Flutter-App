/// Core dependency injection providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/diagnostics/prod_safety_guard.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/auth/minions/social_auth_service.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';

/// SharedPreferences provider.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be overridden in ProviderScope',
  );
});

/// Token storage provider.
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenStorage(prefs: prefs);
});

/// Router is provided by app/router.dart (routerProvider). Import it from there.

/// Network log service provider.
final networkLogServiceProvider = Provider<NetworkLogService>((ref) {
  return NetworkLogService();
});

/// Prod safety guard provider.
final prodSafetyGuardProvider = Provider<ProdSafetyGuard>((ref) {
  return const ProdSafetyGuard();
});

/// API client provider.
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final authNotifier = ref.read(authProvider.notifier);
  final networkLogService = ref.read(networkLogServiceProvider);

  return ApiClient(
    tokenStorage: tokenStorage,
    networkLogService: networkLogService, // Inject log service
    onUnauthorized: () async {
      // Handle 401 globally - clear auth and redirect to login
      await authNotifier.handleUnauthorized();
    },
  );
});

/// Auth repository provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthRepositoryImpl(
    apiClient: apiClient,
    tokenStorage: tokenStorage,
  );
});

/// Social auth service provider.
final socialAuthServiceProvider = Provider<SocialAuthService>((ref) {
  return SocialAuthService();
});
