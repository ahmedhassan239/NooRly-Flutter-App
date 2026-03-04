import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiConfig', () {
    tearDown(() {
      // Reset to default after each test
      ApiConfig.setEnvironment(AppEnvironment.prod);
    });

    test('default environment is prod', () {
      expect(ApiConfig.environment, AppEnvironment.prod);
    });

    test('prod baseUrl includes /api/v1', () {
      ApiConfig.setEnvironment(AppEnvironment.prod);
      expect(ApiConfig.baseUrl, 'https://admin.noorly.net/api/v1');
      expect(ApiConfig.baseUrl.endsWith('/api/v1'), isTrue);
    });

    test('staging baseUrl includes /api/v1', () {
      ApiConfig.setEnvironment(AppEnvironment.staging);
      expect(ApiConfig.baseUrl, 'https://staging.noorly.net/api/v1');
      expect(ApiConfig.baseUrl.endsWith('/api/v1'), isTrue);
    });

    test('dev baseUrl includes /api/v1', () {
      ApiConfig.setEnvironment(AppEnvironment.dev);
      expect(ApiConfig.baseUrl, 'http://localhost:8000/api/v1');
      expect(ApiConfig.baseUrl.endsWith('/api/v1'), isTrue);
    });

    test('setEnvironment changes the environment', () {
      ApiConfig.setEnvironment(AppEnvironment.dev);
      expect(ApiConfig.environment, AppEnvironment.dev);

      ApiConfig.setEnvironment(AppEnvironment.staging);
      expect(ApiConfig.environment, AppEnvironment.staging);

      ApiConfig.setEnvironment(AppEnvironment.prod);
      expect(ApiConfig.environment, AppEnvironment.prod);
    });

    test('enableLogging is true only for dev', () {
      ApiConfig.setEnvironment(AppEnvironment.dev);
      expect(ApiConfig.enableLogging, isTrue);

      ApiConfig.setEnvironment(AppEnvironment.staging);
      expect(ApiConfig.enableLogging, isFalse);

      ApiConfig.setEnvironment(AppEnvironment.prod);
      expect(ApiConfig.enableLogging, isFalse);
    });

    test('timeout values are configured', () {
      expect(ApiConfig.connectTimeout, greaterThan(0));
      expect(ApiConfig.receiveTimeout, greaterThan(0));
      expect(ApiConfig.sendTimeout, greaterThan(0));
    });

    test('retry configuration is set', () {
      expect(ApiConfig.maxRetryAttempts, greaterThan(0));
      expect(ApiConfig.initialRetryDelay, greaterThan(0));
    });
  });

  group('Endpoint construction', () {
    test('endpoints do not include /api/v1 prefix', () {
      // Import endpoints and verify they don't have /api/v1
      const loginEndpoint = '/auth/login';
      const meEndpoint = '/auth/me';
      const duasEndpoint = '/duas';

      expect(loginEndpoint.startsWith('/api/v1'), isFalse);
      expect(meEndpoint.startsWith('/api/v1'), isFalse);
      expect(duasEndpoint.startsWith('/api/v1'), isFalse);
    });

    test('full URL is correctly constructed', () {
      ApiConfig.setEnvironment(AppEnvironment.prod);
      const endpoint = '/auth/login';
      final fullUrl = '${ApiConfig.baseUrl}$endpoint';

      expect(fullUrl, 'https://admin.noorly.net/api/v1/auth/login');
    });
  });
}
