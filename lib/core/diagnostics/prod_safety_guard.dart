import 'package:flutter_app/core/config/api_config.dart';

/// Exceptions for Production Safety Violations.
class ProdSafetyException implements Exception {
  final String message;
  ProdSafetyException(this.message);
  @override
  String toString() => 'ProdSafetyException: $message';
}

/// Guard to prevent accidental usage of non-production APIs in Production mode.
class ProdSafetyGuard {
  const ProdSafetyGuard();

  /// The expected production URL.
  static const String _expectedProdUrl = 'https://admin.noorly.net/api/v1';

  /// Checks if the current configuration is safe.
  /// 
  /// Returns `true` if:
  /// - Env is NOT prod (Dev/Staging can use any URL)
  /// - Env IS prod AND URL matches `_expectedProdUrl`
  /// 
  /// Returns `false` if:
  /// - Env IS prod BUT URL does not match `_expectedProdUrl`
  bool get isSafeToProceed {
    if (ApiConfig.environment != AppEnvironment.prod) {
      return true; // Dev/Staging are always "safe" to use whatever URL
    }
    
    // In PROD, we must match the official URL
    return ApiConfig.resolvedBaseUrl == _expectedProdUrl;
  }

  /// Diagnostics message explaining the safety state.
  String get diagnostics {
    final env = ApiConfig.environment;
    final url = ApiConfig.resolvedBaseUrl;
    
    if (env == AppEnvironment.prod && url != _expectedProdUrl) {
      return 'CRITICAL: Production Environment configured with non-production URL: $url';
    }
    
    return 'Safety Check Passed. Env: ${env.name}, URL: $url';
  }

  /// Throws [ProdSafetyException] if the configuration is unsafe.
  /// 
  /// Call this before critical actions like Login/Register.
  void ensureSafety() {
    if (!isSafeToProceed) {
      throw ProdSafetyException(
        'Action Blocked by ProdSafetyGuard. You are in PRODUCTION mode but using a non-production API URL: ${ApiConfig.resolvedBaseUrl}. This is strictly forbidden.',
      );
    }
  }
}
