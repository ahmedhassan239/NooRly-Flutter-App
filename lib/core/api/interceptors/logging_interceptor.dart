/// Logging interceptor for debugging (dev only).
/// Logs: method, full url, query params, status, response preview (truncated).
/// Does NOT log request/response headers (Authorization is never printed).
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that logs requests and responses in debug mode (kDebugMode).
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.enabled = true});

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled && kDebugMode) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled && kDebugMode) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled && kDebugMode) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final requestId = options.extra['request_id'] as String? ?? 'no-id';
    final path = options.path;
    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ [API] REQUEST  id=$requestId')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ ${options.method} ${options.uri}')
      ..writeln('║ fullUrl=${options.uri}')
      ..writeln('║ queryParams=${options.queryParameters}');

    if (path.contains('/saved')) {
      final segments = path.split('/');
      if (segments.length >= 3) {
        buffer.writeln('║ [Saved] type=${segments[segments.length - 2]}  itemId=${segments.last}');
      }
    }
    if (path.contains('prayer-times')) {
      buffer.writeln('║ [Prayer] endpoint called with query=${options.queryParameters}');
    }

    if (options.data != null) {
      // Never log token/password for auth reset endpoints
      if (path.contains('reset-password') || path.contains('forgot-password')) {
        buffer.writeln('║ Body: [REDACTED]');
      } else {
        buffer.writeln('║ Body: ${_formatBody(options.data, 300)}');
      }
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════');

    if (kDebugMode) debugPrint(buffer.toString());
  }

  void _logResponse(Response response) {
    final requestId = response.requestOptions.extra['request_id'] as String? ?? 'no-id';
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final durationMs = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;
    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ [API] RESPONSE  id=$requestId  status=${response.statusCode}${durationMs != null ? '  duration=${durationMs}ms' : ''}')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ ${response.requestOptions.method} ${response.requestOptions.uri}')
      ..writeln('║ responseBody: ${_formatBody(response.data, 500)}')
      ..writeln('╚══════════════════════════════════════════════════════════');

    if (kDebugMode) debugPrint(buffer.toString());
  }

  void _logError(DioException err) {
    final requestId = err.requestOptions.extra['request_id'] as String? ?? 'no-id';
    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ [API] ERROR  id=$requestId')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ ${err.requestOptions.method} ${err.requestOptions.uri}')
      ..writeln('║ status=${err.response?.statusCode}  type=${err.type}')
      ..writeln('║ message: ${err.message}');

    if (err.response?.data != null) {
      buffer.writeln('║ errorPayload: ${_formatBody(err.response?.data, 500)}');
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════');

    if (kDebugMode) debugPrint(buffer.toString());
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    // Hide sensitive headers
    final sanitized = Map<String, dynamic>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = '***';
    }
    return sanitized.toString();
  }

  String _formatBody(dynamic data, [int maxLen = 300]) {
    if (data == null) return 'null';

    try {
      if (data is Map || data is List) {
        final encoded = const JsonEncoder.withIndent('  ').convert(data);
        if (encoded.length > maxLen) {
          return '${encoded.substring(0, maxLen)}... (truncated)';
        }
        return encoded;
      }
      final s = data.toString();
      return s.length > maxLen ? '${s.substring(0, maxLen)}...' : s;
    } catch (_) {
      return data.toString();
    }
  }
}
