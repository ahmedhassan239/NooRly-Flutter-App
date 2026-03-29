/// Locale interceptor for internationalization.
library;

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that adds locale headers to requests.
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor({
    Locale? locale,
  }) : _locale = locale ?? const Locale('en');

  Locale _locale;

  /// Update the current locale.
  void setLocale(Locale locale) {
    _locale = locale;
    if (kDebugMode) {
      debugPrint('[LocaleInterceptor] Active locale set to ${_locale.languageCode}');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Accept-Language header
    options.headers['Accept-Language'] = _locale.languageCode;
    if (kDebugMode) {
      debugPrint(
        '[LocaleInterceptor] ${options.method} ${options.path} '
        'Accept-Language=${options.headers['Accept-Language']}',
      );
    }

    // Also add as query param for APIs that prefer it
    // Uncomment if needed:
    // options.queryParameters['lang'] = _locale.languageCode;

    handler.next(options);
  }
}
