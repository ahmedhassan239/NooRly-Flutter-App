/// API Configuration for different environments/flavors.
///
/// The base URL already includes `/api/v1` - all endpoints should be relative.
/// Example: `GET /auth/me` becomes `https://admin.noorly.net/api/v1/auth/me`
library;

/// Environment flavors for the app.
enum AppEnvironment {
  /// Development environment (local or dev server)
  dev,

  /// Staging environment (pre-production testing)
  staging,

  /// Production environment
  prod,
}

/// API configuration per environment.
///
/// IMPORTANT: Base URLs already include `/api/v1`.
/// Do NOT add `/api/v1` to endpoint paths.
///
/// Override at build time:
///   flutter build apk --dart-define=API_BASE_URL=https://192.168.1.10/api/v1
///   flutter run --dart-define=ENV=staging
///   flutter run --dart-define=ENV=dev --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
class ApiConfig {
  const ApiConfig._();

  /// Current environment - change this for different builds.
  /// In production, this should be set via build flavors or env variables.
  static AppEnvironment _environment = AppEnvironment.prod;

  /// Get the current environment.
  static AppEnvironment get environment => _environment;

  /// Set the environment (typically called once at app startup).
  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  /// Base URL for API requests (includes /api/v1).
  ///
  /// If [API_BASE_URL] is set via --dart-define, that value is used.
  /// Otherwise uses the URL for the current [environment].
  /// All endpoints should be relative paths without /api/v1 prefix.
  /// Example: Use `/auth/login` not `/api/v1/auth/login`
  static String get baseUrl {
    const fromDefine = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );
    if (fromDefine.isNotEmpty) {
      final url = fromDefine.trim();
      return url.endsWith('/api/v1') ? url : '$url/api/v1';
    }
    switch (_environment) {
      case AppEnvironment.dev:
        return 'http://localhost:8000/api/v1';
      case AppEnvironment.staging:
        return 'https://staging.noorly.net/api/v1';
      case AppEnvironment.prod:
        return 'https://admin.noorly.net/api/v1';
    }
  }

  /// resolvedBaseUrl is an alias for baseUrl to satisfy the ProdSafetyGuard requirements.
  static String get resolvedBaseUrl => baseUrl;

  /// Returns the name of the current environment.
  static String get environmentName => _environment.name;

  /// Connection timeout in milliseconds.
  static const int connectTimeout = 30000;

  /// Receive timeout in milliseconds.
  static const int receiveTimeout = 30000;

  /// Send timeout in milliseconds.
  static const int sendTimeout = 30000;

  /// Maximum retry attempts for transient errors.
  static const int maxRetryAttempts = 3;

  /// Initial retry delay in milliseconds (for exponential backoff).
  static const int initialRetryDelay = 1000;

  /// Whether to enable request/response logging.
  static bool get enableLogging => _environment == AppEnvironment.dev;
}
