/// Authentication interceptor for attaching Bearer token to requests.
library;

import 'package:dio/dio.dart';
import 'package:flutter_app/core/auth/token_storage.dart';

/// Interceptor that attaches the auth token to all requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage});

  final TokenStorage tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the stored token
    final token = await tokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
