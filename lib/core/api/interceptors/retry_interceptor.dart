/// Retry interceptor with exponential backoff for transient errors.
library;

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/config/api_config.dart';

/// Interceptor that retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = ApiConfig.maxRetryAttempts,
    this.initialDelay = ApiConfig.initialRetryDelay,
  });

  final Dio dio;
  final int maxRetries;
  final int initialDelay;

  /// Status codes that should trigger a retry.
  static const _retryableStatusCodes = {408, 429, 500, 502, 503, 504};

  /// DioException types that should trigger a retry.
  static const _retryableTypes = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    // Check if we should retry
    if (!_shouldRetry(err, retryCount)) {
      handler.next(err);
      return;
    }

    // Calculate delay with exponential backoff + jitter
    final delay = _calculateDelay(retryCount);

    if (kDebugMode) {
      print(
        '[Retry] Attempt ${retryCount + 1}/$maxRetries '
        'for ${err.requestOptions.path} after ${delay}ms',
      );
    }

    // Wait before retrying
    await Future<void>.delayed(Duration(milliseconds: delay));

    // Clone the request with updated retry count
    final options = err.requestOptions;
    options.extra['retryCount'] = retryCount + 1;

    try {
      // Retry the request
      final response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      // If retry fails, continue with error handling
      handler.next(e);
    }
  }

  /// Check if the request should be retried.
  bool _shouldRetry(DioException err, int retryCount) {
    // Don't retry if we've exceeded max retries
    if (retryCount >= maxRetries) return false;

    // Don't retry if request was cancelled
    if (err.type == DioExceptionType.cancel) return false;

    // Retry on retryable exception types
    if (_retryableTypes.contains(err.type)) return true;

    // Retry on retryable status codes
    final statusCode = err.response?.statusCode;
    if (statusCode != null && _retryableStatusCodes.contains(statusCode)) {
      return true;
    }

    return false;
  }

  /// Calculate delay with exponential backoff and jitter.
  int _calculateDelay(int retryCount) {
    // Exponential backoff: initialDelay * 2^retryCount
    final exponentialDelay = initialDelay * pow(2, retryCount).toInt();

    // Add jitter (random 0-25% of delay)
    final jitter = Random().nextInt((exponentialDelay * 0.25).toInt());

    return exponentialDelay + jitter;
  }
}
