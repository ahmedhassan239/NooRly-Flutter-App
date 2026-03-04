import 'package:dio/dio.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';
import 'package:uuid/uuid.dart';

/// Interceptor to add X-Request-Id and log network activity.
class RequestIdInterceptor extends Interceptor {
  final NetworkLogService _logService;
  final _uuid = const Uuid();

  RequestIdInterceptor(this._logService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestId = _uuid.v4();
    options.headers['X-Request-Id'] = requestId;
    
    // We create the log entry start here, but we'll fully populate it on response/error
    // For now, we rely on Response/Error to add the entry to the log service 
    // to have status code and timing.
    // However, to link them, we attach the ID to the options extra.
    options.extra['request_id'] = requestId;
    options.extra['start_time'] = DateTime.now();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logRequest(response.requestOptions, response: response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logRequest(err.requestOptions, error: err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options, {Response? response, DioException? error}) {
    try {
      final requestId = options.extra['request_id'] as String? ?? 'unknown';
      final startTime = options.extra['start_time'] as DateTime? ?? DateTime.now();
      
      String? reqBody;
      if (options.data != null) {
        reqBody = options.data.toString();
        if (reqBody.length > 200) reqBody = '${reqBody.substring(0, 200)}...';
      }

      String? resBody;
      if (response?.data != null) {
        resBody = response!.data.toString();
        if (resBody.length > 200) resBody = '${resBody.substring(0, 200)}...';
      } else if (error != null) {
        resBody = error.message;
      }

      _logService.addLog(NetworkLogEntry(
        id: requestId,
        method: options.method,
        url: options.uri.toString(),
        statusCode: response?.statusCode ?? error?.response?.statusCode,
        timestamp: startTime,
        environment: ApiConfig.environment.name,
        requestBodySummary: reqBody,
        responseBodySummary: resBody,
      ));
    } catch (e) {
      // Fail silently to not impact app flow
      print('Network logging failed: $e');
    }
  }
}
