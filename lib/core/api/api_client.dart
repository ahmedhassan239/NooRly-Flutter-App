/// Main API client using Dio.
///
/// The base URL is configured in [ApiConfig] and already includes `/api/v1`.
/// All endpoint paths should be relative (e.g., `/auth/login`, not `/api/v1/auth/login`).
library;

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/api/api_response.dart';
import 'package:flutter_app/core/api/interceptors/auth_interceptor.dart';
import 'package:flutter_app/core/api/interceptors/error_interceptor.dart';
import 'package:flutter_app/core/api/interceptors/locale_interceptor.dart';
import 'package:flutter_app/core/api/interceptors/logging_interceptor.dart';
import 'package:flutter_app/core/api/interceptors/request_id_interceptor.dart';
import 'package:flutter_app/core/api/interceptors/retry_interceptor.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/features/debug/data/network_log_service.dart';
import 'package:flutter_app/core/errors/api_exception.dart';

/// Callback for handling unauthorized (401) responses.
typedef OnUnauthorizedCallback = Future<void> Function();

/// Main API client for making HTTP requests.
///
/// Usage:
/// ```dart
/// final client = ApiClient(tokenStorage: tokenStorage);
/// final response = await client.get<Map<String, dynamic>>('/auth/me');
/// ```
class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    required NetworkLogService networkLogService,
    OnUnauthorizedCallback? onUnauthorized,
    Dio? dio,
  })  : _tokenStorage = tokenStorage,
        _networkLogService = networkLogService,
        _onUnauthorized = onUnauthorized {
    _dio = dio ?? _createDio();
    _setupInterceptors();
  }

  final TokenStorage _tokenStorage;
  final NetworkLogService _networkLogService;
  final OnUnauthorizedCallback? _onUnauthorized;
  late final Dio _dio;
  late final LocaleInterceptor _localeInterceptor;

  /// Get the underlying Dio instance (for advanced use cases).
  Dio get dio => _dio;

  /// Get the current base URL.
  String get baseUrl => ApiConfig.baseUrl;

  /// Create and configure Dio instance.
  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  /// Setup interceptors in the correct order.
  void _setupInterceptors() {
    _localeInterceptor = LocaleInterceptor();

    // Order matters:
    // 1. Logging (first to log raw request / always logs errors)
    // 2. RequestId (tag every request for correlation)
    // 3. Locale (add language headers)
    // 4. Auth (add token)
    // 5. Retry (retry on transient errors)
    // 6. Error (convert errors last)

    // LoggingInterceptor is added in ALL build modes.
    // In release it logs errors only (verboseSuccess: false).
    // In debug it also logs requests and successful responses.
    _dio.interceptors.add(LoggingInterceptor(verboseSuccess: kDebugMode));

    _dio.interceptors.addAll([
      RequestIdInterceptor(_networkLogService),
      _localeInterceptor,
      AuthInterceptor(tokenStorage: _tokenStorage),
      RetryInterceptor(dio: _dio),
      ErrorInterceptor(onUnauthorized: _onUnauthorized),
    ]);
  }

  /// Update the locale for API requests.
  void setLocale(Locale locale) {
    _localeInterceptor.setLocale(locale);
  }

  // ============================================================================
  // HTTP Methods
  // ============================================================================

  /// Perform a GET request.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a POST request.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a PUT request.
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a PATCH request.
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a DELETE request.
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload a file with multipart form data.
  Future<ApiResponse<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalFields,
    T Function(dynamic json)? fromJson,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalFields,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============================================================================
  // Response Parsing
  // ============================================================================

  /// Parse response into ApiResponse.
  ApiResponse<T> _parseResponse<T>(
    Response<Map<String, dynamic>> response,
    T Function(dynamic json)? fromJson,
  ) {
    final data = response.data;

    if (data == null) {
      return ApiResponse<T>(
        status: response.statusCode == 200 || response.statusCode == 201,
        message: 'No response data',
      );
    }

    // Check for error status codes
    if (response.statusCode != null && response.statusCode! >= 400) {
      final message = data['message'] as String? ?? 'Request failed';
      throw _mapStatusCodeToException(response.statusCode!, message, data);
    }

    return ApiResponse<T>.fromJson(data, fromJson);
  }

  /// Handle DioException and convert to ApiException.
  ApiException _handleError(DioException error) {
    // If error is already an ApiException (from ErrorInterceptor), return it
    if (error.error is ApiException) {
      return error.error as ApiException;
    }
    return mapDioException(error);
  }

  /// Map status code to appropriate exception.
  ApiException _mapStatusCodeToException(
    int statusCode,
    String message,
    Map<String, dynamic> data,
  ) {
    switch (statusCode) {
      case 401:
        return UnauthorizedException(message: message, data: data);
      case 403:
        return ForbiddenException(message: message, data: data);
      case 404:
        return NotFoundException(message: message, data: data);
      case 422:
        Map<String, List<String>> errors = {};
        if (data['errors'] is Map) {
          final errorsMap = data['errors'] as Map<String, dynamic>;
          errors = errorsMap.map((key, value) {
            if (value is List) {
              return MapEntry(key, value.cast<String>());
            }
            return MapEntry(key, [value.toString()]);
          });
        }
        return ValidationException(message: message, data: data, errors: errors);
      case 429:
        return RateLimitException(
          message: message,
          data: data,
          retryAfter: data['retry_after'] as int?,
        );
      case >= 500:
        return ServerException(message: message, statusCode: statusCode, data: data);
      default:
        return UnknownException(message: message, statusCode: statusCode, data: data);
    }
  }
}
