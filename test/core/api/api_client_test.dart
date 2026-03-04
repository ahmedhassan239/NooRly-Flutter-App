import 'package:dio/dio.dart';
import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class MockDio extends Mock implements Dio {}

class MockNetworkLogService extends Mock implements NetworkLogService {}

void main() {
  late MockTokenStorage mockTokenStorage;
  late MockNetworkLogService mockNetworkLogService;
  late ApiClient apiClient;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    mockNetworkLogService = MockNetworkLogService();
    when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);
    when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);
    when(() => mockTokenStorage.isAuthenticated()).thenAnswer((_) async => false);

    apiClient = ApiClient(
      tokenStorage: mockTokenStorage,
      networkLogService: mockNetworkLogService,
    );
  });

  group('ApiClient', () {
    test('baseUrl matches ApiConfig.baseUrl', () {
      expect(apiClient.baseUrl, ApiConfig.baseUrl);
    });

    test('baseUrl includes /api/v1', () {
      expect(apiClient.baseUrl.contains('/api/v1'), isTrue);
    });

    test('dio instance is created with correct baseUrl', () {
      expect(apiClient.dio.options.baseUrl, ApiConfig.baseUrl);
    });

    test('dio has correct default headers', () {
      expect(apiClient.dio.options.headers['Content-Type'], 'application/json');
      expect(apiClient.dio.options.headers['Accept'], 'application/json');
    });

    test('dio has correct timeouts', () {
      expect(
        apiClient.dio.options.connectTimeout?.inMilliseconds,
        ApiConfig.connectTimeout,
      );
      expect(
        apiClient.dio.options.receiveTimeout?.inMilliseconds,
        ApiConfig.receiveTimeout,
      );
    });
  });

  group('Error mapping', () {
    test('maps 401 to UnauthorizedException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<UnauthorizedException>());
      expect(exception.statusCode, 401);
    });

    test('maps 403 to ForbiddenException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<ForbiddenException>());
      expect(exception.statusCode, 403);
    });

    test('maps 404 to NotFoundException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<NotFoundException>());
      expect(exception.statusCode, 404);
    });

    test('maps 422 to ValidationException with errors', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 422,
            data: {
              'message': 'Validation failed',
              'errors': {
                'email': ['Email is required', 'Email must be valid'],
                'password': ['Password is too short'],
              },
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<ValidationException>());
      expect(exception.statusCode, 422);

      final validationException = exception as ValidationException;
      expect(validationException.errors['email'], hasLength(2));
      expect(validationException.errors['password'], hasLength(1));
      expect(validationException.getFieldError('email'), 'Email is required');
    });

    test('maps 429 to RateLimitException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 429,
            data: {'message': 'Too many requests', 'retry_after': 60},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<RateLimitException>());
      expect(exception.statusCode, 429);
      expect((exception as RateLimitException).retryAfter, 60);
    });

    test('maps 5xx to ServerException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<ServerException>());
      expect(exception.statusCode, 500);
    });

    test('maps connection timeout to TimeoutException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(exception, isA<TimeoutException>());
    });

    test('maps connection error to NetworkException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(exception, isA<NetworkException>());
    });

    test('maps cancel to CancelledException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        ),
      );

      expect(exception, isA<CancelledException>());
    });
  });
}
