import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TokenStorage tokenStorage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    tokenStorage = TokenStorage(prefs: prefs);
    await tokenStorage.init();
  });

  group('TokenStorage', () {
    test('stores and retrieves access token', () async {
      await tokenStorage.setAccessToken('test_token');
      final token = await tokenStorage.getAccessToken();
      expect(token, 'test_token');
    });

    test('stores and retrieves refresh token', () async {
      await tokenStorage.setRefreshToken('refresh_token');
      final token = await tokenStorage.getRefreshToken();
      expect(token, 'refresh_token');
    });

    test('stores and retrieves user ID', () async {
      await tokenStorage.setUserId('user_123');
      final userId = await tokenStorage.getUserId();
      expect(userId, 'user_123');
    });

    test('stores and retrieves token expiry', () async {
      final expiry = DateTime.now().add(const Duration(hours: 1));
      await tokenStorage.setTokenExpiry(expiry);
      final storedExpiry = await tokenStorage.getTokenExpiry();

      expect(storedExpiry, isNotNull);
      // Compare with some tolerance for serialization
      expect(
        storedExpiry!.difference(expiry).inSeconds.abs(),
        lessThan(2),
      );
    });

    test('isTokenExpired returns true for expired token', () async {
      final expiry = DateTime.now().subtract(const Duration(hours: 1));
      await tokenStorage.setTokenExpiry(expiry);

      final isExpired = await tokenStorage.isTokenExpired();
      expect(isExpired, isTrue);
    });

    test('isTokenExpired returns false for valid token', () async {
      final expiry = DateTime.now().add(const Duration(hours: 1));
      await tokenStorage.setTokenExpiry(expiry);

      final isExpired = await tokenStorage.isTokenExpired();
      expect(isExpired, isFalse);
    });

    test('isTokenExpired returns true when no expiry set', () async {
      final isExpired = await tokenStorage.isTokenExpired();
      expect(isExpired, isTrue);
    });

    test('isAuthenticated returns true when token exists and not expired', () async {
      await tokenStorage.setAccessToken('valid_token');
      await tokenStorage.setTokenExpiry(
        DateTime.now().add(const Duration(hours: 1)),
      );

      final isAuth = await tokenStorage.isAuthenticated();
      expect(isAuth, isTrue);
    });

    test('isAuthenticated returns false when no token', () async {
      final isAuth = await tokenStorage.isAuthenticated();
      expect(isAuth, isFalse);
    });

    test('isAuthenticated returns false when token expired', () async {
      await tokenStorage.setAccessToken('expired_token');
      await tokenStorage.setTokenExpiry(
        DateTime.now().subtract(const Duration(hours: 1)),
      );

      final isAuth = await tokenStorage.isAuthenticated();
      expect(isAuth, isFalse);
    });

    test('guest mode can be set and retrieved', () async {
      await tokenStorage.setGuestMode(true);
      final isGuest = await tokenStorage.isGuestMode();
      expect(isGuest, isTrue);

      await tokenStorage.setGuestMode(false);
      final isNotGuest = await tokenStorage.isGuestMode();
      expect(isNotGuest, isFalse);
    });

    test('clearAll removes all stored data', () async {
      await tokenStorage.setAccessToken('token');
      await tokenStorage.setRefreshToken('refresh');
      await tokenStorage.setUserId('user');
      await tokenStorage.setGuestMode(true);

      await tokenStorage.clearAll();

      expect(await tokenStorage.getAccessToken(), isNull);
      expect(await tokenStorage.getRefreshToken(), isNull);
      expect(await tokenStorage.getUserId(), isNull);
      expect(await tokenStorage.isGuestMode(), isFalse);
    });

    test('saveAuthData stores all auth data at once', () async {
      await tokenStorage.saveAuthData(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiry: DateTime.now().add(const Duration(hours: 1)),
        userId: 'user_123',
      );

      expect(await tokenStorage.getAccessToken(), 'access');
      expect(await tokenStorage.getRefreshToken(), 'refresh');
      expect(await tokenStorage.getUserId(), 'user_123');
      expect(await tokenStorage.isGuestMode(), isFalse);
      expect(await tokenStorage.isAuthenticated(), isTrue);
    });
  });
}
