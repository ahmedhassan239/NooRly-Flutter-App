/// Error interceptor for global error handling.
library;

import 'package:dio/dio.dart';
import 'package:flutter_app/core/errors/api_exception.dart';

/// Callback type for handling 401 unauthorized errors.
typedef OnUnauthorized = Future<void> Function();

/// Interceptor that handles errors globally.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({
    this.onUnauthorized,
  });

  /// Callback when 401 unauthorized is received.
  final OnUnauthorized? onUnauthorized;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 unauthorized globally
    if (err.response?.statusCode == 401) {
      await onUnauthorized?.call();
    }

    // Convert DioException to our ApiException
    final apiException = mapDioException(err);

    // Create a new DioException with our ApiException as the error
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
      ),
    );
  }
}
