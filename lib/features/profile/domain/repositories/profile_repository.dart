/// Profile repository interface.
library;

import 'package:flutter_app/features/profile/domain/entities/profile_entity.dart';

/// Profile repository interface.
abstract class ProfileRepository {
  /// Get user profile.
  Future<ProfileEntity> getProfile();

  /// Update user profile.
  Future<ProfileEntity> updateProfile(UpdateProfileRequest request);

  /// Upload avatar image.
  Future<String> uploadAvatar(String filePath);

  /// Delete user account.
  Future<void> deleteAccount();

  /// Get cached profile.
  Future<ProfileEntity?> getCachedProfile();

  /// Clear cache.
  Future<void> clearCache();
}
