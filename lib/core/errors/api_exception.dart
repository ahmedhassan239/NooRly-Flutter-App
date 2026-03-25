/// API Exception classes for unified error handling.
library;

import 'package:dio/dio.dart';

/// Base class for all API exceptions.
sealed class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  /// Human-readable error message.
  final String message;

  /// HTTP status code (if available).
  final int? statusCode;

  /// Additional error data from the server.
  final dynamic data;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Network error (no internet, DNS failure, etc.).
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
    super.data,
  });
}

/// Server error (5xx status codes).
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode,
    super.data,
  });
}

/// Unauthorized error (401 status code).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
    super.data,
  });
}

/// Forbidden error (403 status code).
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
    super.data,
  });
}

/// Not found error (404 status code).
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
    super.data,
  });
}

/// Conflict error (409 status code) – e.g. email already registered.
class ConflictException extends ApiException {
  const ConflictException({
    super.message = 'This resource already exists.',
    super.statusCode = 409,
    super.data,
  });
}

/// Validation error (422 status code).
class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'Validation failed. Please check your input.',
    super.statusCode = 422,
    super.data,
    this.errors = const {},
  });

  /// Field-specific validation errors.
  /// Key: field name, Value: list of error messages.
  final Map<String, List<String>> errors;

  /// Get the first error message for a specific field.
  String? getFieldError(String field) {
    final fieldErrors = errors[field];
    return fieldErrors?.isNotEmpty == true ? fieldErrors!.first : null;
  }

  /// Get all error messages as a single string.
  String get allErrors {
    if (errors.isEmpty) return message;
    return errors.entries
        .map((e) => '${e.key}: ${e.value.join(", ")}')
        .join('\n');
  }
}

/// Rate limit error (429 status code).
class RateLimitException extends ApiException {
  const RateLimitException({
    super.message = 'Too many requests. Please wait and try again.',
    super.statusCode = 429,
    super.data,
    this.retryAfter,
  });

  /// Seconds to wait before retrying.
  final int? retryAfter;
}

/// Request cancelled.
class CancelledException extends ApiException {
  const CancelledException({
    super.message = 'Request was cancelled.',
    super.statusCode,
    super.data,
  });
}

/// Timeout error.
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
    super.data,
  });
}

/// Unknown/generic error.
class UnknownException extends ApiException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
    super.data,
  });
}

/// Email verification required.
class EmailVerificationRequiredException extends ApiException {
  const EmailVerificationRequiredException({
    required this.email,
    super.message = 'Please verify your email.',
    super.statusCode,
    super.data,
  });

  final String email;
}

/// Factory to create appropriate exception from DioException.
ApiException mapDioException(DioException error) {
  final response = error.response;
  final statusCode = response?.statusCode;
  final data = response?.data;

  // Extract message from response if available
  String? serverMessage;
  if (data is Map<String, dynamic>) {
    serverMessage = (data['message'] as String?) ??
        (data['error'] as String?) ??
        (data['meta'] is Map<String, dynamic>
            ? (data['meta'] as Map<String, dynamic>)['message'] as String?
            : null);
  } else if (data is String && data.trim().isNotEmpty) {
    serverMessage = data;
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutException(
        message: serverMessage ?? 'Request timed out. Please try again.',
        statusCode: statusCode,
        data: data,
      );

    case DioExceptionType.connectionError:
      return NetworkException(
        message: serverMessage ?? 'No internet connection. Please check your network.',
        statusCode: statusCode,
        data: data,
      );

    case DioExceptionType.cancel:
      return CancelledException(
        message: serverMessage ?? 'Request was cancelled.',
        statusCode: statusCode,
        data: data,
      );

    case DioExceptionType.badResponse:
      return _mapStatusCodeException(
        statusCode: statusCode,
        message: serverMessage,
        data: data,
      );

    case DioExceptionType.badCertificate:
      return const NetworkException(
        message: 'SSL certificate error. Please contact support.',
      );

    case DioExceptionType.unknown:
      if (error.error.toString().contains('SocketException')) {
        return NetworkException(
          message: serverMessage ?? 'No internet connection.',
          statusCode: statusCode,
          data: data,
        );
      }
      return UnknownException(
        message: serverMessage ??
            error.message ??
            (statusCode != null
                ? 'Request failed with status $statusCode.'
                : 'An unexpected error occurred.'),
        statusCode: statusCode,
        data: data,
      );
  }
}

/// Map HTTP status code to appropriate exception.
ApiException _mapStatusCodeException({
  int? statusCode,
  String? message,
  dynamic data,
}) {
  switch (statusCode) {
    case 401:
      return UnauthorizedException(
        message: message ?? 'Session expired. Please login again.',
        data: data,
      );

    case 403:
      return ForbiddenException(
        message: message ?? 'You do not have permission to perform this action.',
        data: data,
      );

    case 404:
      return NotFoundException(
        message: message ?? 'The requested resource was not found.',
        data: data,
      );

    case 409:
      return ConflictException(
        message: message ?? 'This resource already exists.',
        data: data,
      );

    case 422:
      // Parse validation errors (top-level "errors" or Laravel-style "meta.errors")
      Map<String, List<String>> errors = {};
      if (data is Map<String, dynamic>) {
        final errorsMap = (data['errors'] ?? (data['meta'] is Map ? (data['meta'] as Map)['errors'] : null)) as Map<String, dynamic>?;
        if (errorsMap != null) {
          errors = errorsMap.map((key, value) {
            if (value is List) {
              return MapEntry(key, value.cast<String>());
            }
            return MapEntry(key, [value.toString()]);
          });
        }
      }
      return ValidationException(
        message: message ?? 'Validation failed. Please check your input.',
        data: data,
        errors: errors,
      );

    case 429:
      int? retryAfter;
      if (data is Map<String, dynamic>) {
        retryAfter = data['retry_after'] as int?;
      }
      return RateLimitException(
        message: message ?? 'Too many requests. Please wait and try again.',
        data: data,
        retryAfter: retryAfter,
      );

    default:
      if (statusCode != null && statusCode >= 500) {
        return ServerException(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
          data: data,
        );
      }
      return UnknownException(
        message: message ??
            (statusCode != null
                ? 'Request failed with status $statusCode.'
                : 'An unexpected error occurred.'),
        statusCode: statusCode,
        data: data,
      );
  }
}
