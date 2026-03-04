import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

/// Integration tests for auth flow.
///
/// These tests verify the correct URL construction and endpoint paths.
/// For full integration tests with actual API calls, use a test server.
void main() {
  group('Auth Flow Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('login endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.login}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/login');
    });

    test('register endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.register}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/register');
    });

    test('logout endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.logout}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/logout');
    });

    test('me endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.me}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/me');
    });

    test('refresh endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.refresh}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/refresh');
    });
  });

  group('Content Endpoints Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('duas list endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${DuasEndpoints.list}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/duas');
    });

    test('duas detail endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${DuasEndpoints.detail("123")}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/duas/123');
    });

    test('duas category endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${DuasEndpoints.byCategory("morning")}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/duas/category/morning');
    });

    test('hadith search endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${HadithEndpoints.search}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/hadith/search');
    });

    test('verses search endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${VersesEndpoints.search}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/verses/search');
    });
  });

  group('Home & Config Endpoints Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('app config endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${ConfigEndpoints.appConfig}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/app-config');
    });

    test('home dashboard endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${HomeEndpoints.dashboard}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/home/dashboard');
    });
  });

  group('Journey Endpoints Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('journey endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${JourneyEndpoints.journey}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/journey');
    });

    test('lesson detail endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${LessonsEndpoints.detail('5')}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/lessons/5');
    });

    test('complete lesson endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${JourneyEndpoints.completeLesson('10')}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/lessons/10/complete');
    });
  });

  group('Prayer Endpoints Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('prayer times endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${PrayerEndpoints.times}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/prayer-times');
    });
  });

  group('Profile & Settings Endpoints Integration', () {
    setUp(() {
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('profile endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${ProfileEndpoints.profile}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/profile');
    });

    test('settings endpoint constructs correct URL', () {
      final fullUrl = '${ApiConfig.baseUrl}${SettingsEndpoints.settings}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/settings');
    });
  });

  group('Environment Switching', () {
    test('switching to dev changes base URL', () {
      ApiConfig.setEnvironment(AppEnvironment.dev);
      expect(ApiConfig.baseUrl, 'http://localhost:8000/api/v1');

      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.login}';
      expect(fullUrl, 'http://localhost:8000/api/v1/auth/login');
    });

    test('switching to staging changes base URL', () {
      ApiConfig.setEnvironment(AppEnvironment.staging);
      expect(ApiConfig.baseUrl, 'https://staging.noorly.net/api/v1');

      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.login}';
      expect(fullUrl, 'https://staging.noorly.net/api/v1/auth/login');
    });

    test('switching to prod changes base URL', () {
      ApiConfig.setEnvironment(AppEnvironment.prod);
      expect(ApiConfig.baseUrl, 'https://admin.noorly.net/api/v1');

      final fullUrl = '${ApiConfig.baseUrl}${AuthEndpoints.login}';
      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/login');
    });
  });
}
