import 'package:dio/dio.dart';
import 'package:flutter_app/core/api/interceptors/request_id_interceptor.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'request_id_interceptor_test.mocks.dart';

@GenerateMocks([NetworkLogService, ErrorInterceptorHandler, ResponseInterceptorHandler, RequestInterceptorHandler])
void main() {
  late RequestIdInterceptor interceptor;
  late MockNetworkLogService mockLogService;

  setUp(() {
    mockLogService = MockNetworkLogService();
    interceptor = RequestIdInterceptor(mockLogService);
  });

  test('onRequest adds X-Request-Id header', () {
    final options = RequestOptions(path: '/test', baseUrl: 'http://test.com');
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(options, handler);

    expect(options.headers['X-Request-Id'], isNotNull);
    expect(options.headers['X-Request-Id'], isNotEmpty);
  });

  test('onResponse adds log entry', () {
    final options = RequestOptions(path: '/test', method: 'GET', baseUrl: 'http://test.com');
    // Simulate onRequest having run
    options.headers['X-Request-Id'] = 'test-id';
    options.extra['request_id'] = 'test-id';
    options.extra['start_time'] = DateTime.now();

    final response = Response(requestOptions: options, statusCode: 200, data: {'key': 'value'});
    final handler = ResponseInterceptorHandler();

    interceptor.onResponse(response, handler);

    verify(mockLogService.addLog(any)).called(1);
  });

  test('onError adds log entry', () {
    final options = RequestOptions(path: '/test', method: 'GET', baseUrl: 'http://test.com');
    options.headers['X-Request-Id'] = 'test-id';
    options.extra['request_id'] = 'test-id';
    options.extra['start_time'] = DateTime.now();

    final error = DioException(
      requestOptions: options,
      message: 'Error',
      type: DioExceptionType.unknown,
    );
    final handler = MockErrorInterceptorHandler();

    interceptor.onError(error, handler);

    verify(mockLogService.addLog(any)).called(1);
    verify(handler.next(error)).called(1);
  });
}
