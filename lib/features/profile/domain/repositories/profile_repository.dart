/// Profile repository interface.
library;

import 'dart:typed_data';

import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';

/// Profile repository interface.
abstract class ProfileRepository {
  /// Get user profile.
  Future<ProfileEntity> getProfile();

  /// Update user profile.
  Future<ProfileEntity> updateProfile(UpdateProfileRequest request);

  /// Upload avatar image. Returns parsed user payload from API (authoritative avatar fields).
  Future<UserEntity> uploadAvatar({
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  });

  /// Delete user account.
  Future<void> deleteAccount();

  /// Get cached profile.
  Future<ProfileEntity?> getCachedProfile();

  /// Clear cache.
  Future<void> clearCache();
}
