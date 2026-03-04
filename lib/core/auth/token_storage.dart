/// Secure token storage using flutter_secure_storage.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for token storage.
abstract class TokenStorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String userId = 'user_id';
  static const String isGuest = 'is_guest';
}

/// Secure storage for authentication tokens.
///
/// Uses flutter_secure_storage for native platforms and
/// SharedPreferences for web (with a warning about security).
class TokenStorage {
  TokenStorage({
    FlutterSecureStorage? secureStorage,
    SharedPreferences? prefs,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        ),
        _prefs = prefs;

  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences (for web fallback).
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Store access token.
  Future<void> setAccessToken(String token) async {
    if (kIsWeb) {
      await _prefs?.setString(TokenStorageKeys.accessToken, token);
    } else {
      await _secureStorage.write(
        key: TokenStorageKeys.accessToken,
        value: token,
      );
    }
  }

  /// Get access token.
  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return _prefs?.getString(TokenStorageKeys.accessToken);
    }
    return _secureStorage.read(key: TokenStorageKeys.accessToken);
  }

  /// Store refresh token.
  Future<void> setRefreshToken(String token) async {
    if (kIsWeb) {
      await _prefs?.setString(TokenStorageKeys.refreshToken, token);
    } else {
      await _secureStorage.write(
        key: TokenStorageKeys.refreshToken,
        value: token,
      );
    }
  }

  /// Get refresh token.
  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return _prefs?.getString(TokenStorageKeys.refreshToken);
    }
    return _secureStorage.read(key: TokenStorageKeys.refreshToken);
  }

  /// Store token expiry timestamp.
  Future<void> setTokenExpiry(DateTime expiry) async {
    final expiryString = expiry.toIso8601String();
    if (kIsWeb) {
      await _prefs?.setString(TokenStorageKeys.tokenExpiry, expiryString);
    } else {
      await _secureStorage.write(
        key: TokenStorageKeys.tokenExpiry,
        value: expiryString,
      );
    }
  }

  /// Get token expiry timestamp.
  Future<DateTime?> getTokenExpiry() async {
    String? expiryString;
    if (kIsWeb) {
      expiryString = _prefs?.getString(TokenStorageKeys.tokenExpiry);
    } else {
      expiryString = await _secureStorage.read(key: TokenStorageKeys.tokenExpiry);
    }

    if (expiryString == null) return null;
    return DateTime.tryParse(expiryString);
  }

  /// Check if token is expired.
  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  /// Store user ID.
  Future<void> setUserId(String id) async {
    if (kIsWeb) {
      await _prefs?.setString(TokenStorageKeys.userId, id);
    } else {
      await _secureStorage.write(
        key: TokenStorageKeys.userId,
        value: id,
      );
    }
  }

  /// Get user ID.
  Future<String?> getUserId() async {
    if (kIsWeb) {
      return _prefs?.getString(TokenStorageKeys.userId);
    }
    return _secureStorage.read(key: TokenStorageKeys.userId);
  }

  /// Set guest mode.
  Future<void> setGuestMode(bool isGuest) async {
    await _prefs?.setBool(TokenStorageKeys.isGuest, isGuest);
  }

  /// Check if in guest mode.
  Future<bool> isGuestMode() async {
    return _prefs?.getBool(TokenStorageKeys.isGuest) ?? false;
  }

  /// Check if user is authenticated (has valid token).
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    // Optionally check expiry
    final isExpired = await isTokenExpired();
    return !isExpired;
  }

  /// Clear all stored tokens (logout).
  Future<void> clearAll() async {
    if (kIsWeb) {
      await _prefs?.remove(TokenStorageKeys.accessToken);
      await _prefs?.remove(TokenStorageKeys.refreshToken);
      await _prefs?.remove(TokenStorageKeys.tokenExpiry);
      await _prefs?.remove(TokenStorageKeys.userId);
      await _prefs?.remove(TokenStorageKeys.isGuest);
    } else {
      await _secureStorage.delete(key: TokenStorageKeys.accessToken);
      await _secureStorage.delete(key: TokenStorageKeys.refreshToken);
      await _secureStorage.delete(key: TokenStorageKeys.tokenExpiry);
      await _secureStorage.delete(key: TokenStorageKeys.userId);
      // Keep isGuest in prefs for web compatibility
      await _prefs?.remove(TokenStorageKeys.isGuest);
    }
  }

  /// Store all auth data at once.
  Future<void> saveAuthData({
    required String accessToken,
    String? refreshToken,
    DateTime? expiry,
    String? userId,
  }) async {
    await setAccessToken(accessToken);
    if (refreshToken != null) {
      await setRefreshToken(refreshToken);
    }
    if (expiry != null) {
      await setTokenExpiry(expiry);
    }
    if (userId != null) {
      await setUserId(userId);
    }
    await setGuestMode(false);
  }
}
