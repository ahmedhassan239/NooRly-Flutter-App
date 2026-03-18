/// Logging interceptor.
///
/// Request/response SUCCESS logs: debug builds only (kDebugMode).
/// ERROR logs: ALL builds — always visible in `adb logcat | grep flutter`
///   so release APK failures can be diagnosed without a debug build.
///   Authorization header is never printed; response body is truncated.
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that logs requests, responses, and errors.
///
/// [verboseSuccess] — also log successful request/response pairs (debug only).
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.verboseSuccess = kDebugMode});

  /// When true, requests and successful responses are also logged.
  /// Errors are ALWAYS logged regardless of this flag.
  final bool verboseSuccess;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (verboseSuccess) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (verboseSuccess) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Always log errors — this is the primary diagnostic tool for release APKs.
    _logError(err);
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
    final req  = err.requestOptions;
    final res  = err.response;

    // Sanitised request headers — hide Authorization token.
    final safeHeaders = <String, dynamic>{
      for (final e in req.headers.entries)
        e.key: e.key.toLowerCase() == 'authorization' ? '***REDACTED***' : e.value,
    };

    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ [API] ❌ ERROR  id=$requestId')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║  method      : ${req.method}')
      ..writeln('║  fullUrl     : ${req.uri}')
      ..writeln('║  baseUrl     : ${req.baseUrl}')
      ..writeln('║  path        : ${req.path}')
      ..writeln('║  dioType     : ${err.type}')
      ..writeln('║  statusCode  : ${res?.statusCode ?? "—"}')
      ..writeln('║  message     : ${err.message ?? "—"}')
      ..writeln('║  errorObject : ${err.error?.runtimeType ?? "—"} — ${err.error}');

    if (safeHeaders.isNotEmpty) {
      buffer.writeln('║  reqHeaders  : $safeHeaders');
    }

    if (res?.data != null) {
      buffer.writeln('║  respBody    : ${_formatBody(res!.data, 800)}');
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════');

    // Always print — NOT gated by kDebugMode.
    // Visible via:  adb logcat | grep flutter
    // ignore: avoid_print
    print(buffer.toString());
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
