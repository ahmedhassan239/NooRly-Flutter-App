/// Deep link parsing for auth flows.
///
/// Supported formats:
/// - Custom: `noorly://reset-password?token=...&email=...`
/// - Universal/App Link: `https://noorly.net/reset-password?token=...&email=...`
/// Parses to app path: `/reset-password?email=...&token=...` for GoRouter.
library;

/// Custom URL scheme for reset-password (used by web landing redirect).
const String kResetPasswordScheme = 'noorly';

/// Host/path for custom scheme: noorly://reset-password
const String kResetPasswordHostPath = 'reset-password';

/// HTTPS host for Universal Links / App Links.
const String kResetPasswordHttpsHost = 'noorly.net';

/// Path prefix for reset-password on noorly.net.
const String kResetPasswordHttpsPath = '/reset-password';

/// Converts a deep link [Uri] to a GoRouter path if it is a reset-password link.
/// Returns null if the URI is not a supported deep link.
///
/// Supports:
///   noorly://reset-password?token=...&email=...
///   https://noorly.net/reset-password?token=...&email=...
String? parseResetPasswordPath(Uri uri) {
  final scheme = uri.scheme.toLowerCase();
  final host = uri.host.toLowerCase();
  final path = uri.path;

  final bool isResetPasswordRoute;
  if (scheme == kResetPasswordScheme) {
    final pathSegment = host.isNotEmpty ? host : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null);
    isResetPasswordRoute = pathSegment == kResetPasswordHostPath;
  } else if (scheme == 'https' && host == kResetPasswordHttpsHost) {
    isResetPasswordRoute = path == kResetPasswordHttpsPath || path.startsWith('$kResetPasswordHttpsPath/');
  } else {
    isResetPasswordRoute = false;
  }

  if (!isResetPasswordRoute) return null;

  final query = uri.queryParameters;
  final email = query['email']?.trim();
  final token = query['token']?.trim();
  if (email == null || token == null || email.isEmpty || token.isEmpty) return null;

  final queryString = Uri(queryParameters: {'email': email, 'token': token}).query;
  return '/reset-password?$queryString';
}
