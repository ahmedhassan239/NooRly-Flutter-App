/// Profile repository implementation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/profile/data/models/profile_model.dart';
import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_app/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of [ProfileRepository].
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ProfileEndpoints.profile,
      );

      if (!response.status || response.data == null) {
        final cached = await getCachedProfile();
        if (cached != null) return cached;
        throw UnknownException(message: response.message);
      }

      final profile = ProfileModel.fromJson(response.data!);

      // Cache the profile
      await CacheManager.put(
        box: CacheBoxes.user,
        key: CacheKeys.userProfile,
        data: profile.toJson(),
        expiry: CacheDurations.userProfile,
      );

      return profile.toEntity();
    } on ApiException {
      final cached = await getCachedProfile();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[Profile] Error fetching profile: $e');
      }
      final cached = await getCachedProfile();
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<ProfileEntity> updateProfile(UpdateProfileRequest request) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      ProfileEndpoints.update,
      data: request.toJson(),
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final profile = ProfileModel.fromJson(response.data!);

    // Update cache
    await CacheManager.put(
      box: CacheBoxes.user,
      key: CacheKeys.userProfile,
      data: profile.toJson(),
      expiry: CacheDurations.userProfile,
    );

    return profile.toEntity();
  }

  @override
  Future<UserEntity> uploadAvatar({
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    try {
      final response = await _apiClient.uploadFile<Map<String, dynamic>>(
        ProfileEndpoints.avatar,
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
        fieldName: 'avatar',
      );

      if (!response.status || response.data == null) {
        throw UnknownException(message: response.message);
      }

      final data = response.data!;

      await clearCache();

      return UserModel.fromJson(data).toEntity();
    } on ApiException catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[Avatar] upload API error: type=${e.runtimeType} status=${e.statusCode} message=${e.message} data=${e.data}',
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _apiClient.delete<void>(
      ProfileEndpoints.delete,
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }

    // Clear all user data
    await clearCache();
  }

  @override
  Future<ProfileEntity?> getCachedProfile() async {
    try {
      final cached = await CacheManager.get<Map<String, dynamic>>(
        box: CacheBoxes.user,
        key: CacheKeys.userProfile,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (cached == null) return null;

      return ProfileModel.fromJson(cached).toEntity();
    } catch (e) {
      if (kDebugMode) {
        print('[Profile] Error reading cached profile: $e');
      }
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.delete(
      box: CacheBoxes.user,
      key: CacheKeys.userProfile,
    );
  }
}
