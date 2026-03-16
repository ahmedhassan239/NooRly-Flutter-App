import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/api_config.dart';
import 'package:flutter_app/core/notifications/notification_service.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use path-based URL strategy for Flutter Web (clean URLs without #)
  // This enables URLs like /home instead of /#/home
  // IMPORTANT: Requires server-side rewrite rules for direct URL access
  usePathUrlStrategy();

  // Set environment: --dart-define=ENV=dev|staging|prod, or debug=dev / release=prod
  const envDefine = String.fromEnvironment('ENV', defaultValue: '');
  if (envDefine.isNotEmpty) {
    switch (envDefine.toLowerCase()) {
      case 'dev':
        ApiConfig.setEnvironment(AppEnvironment.dev);
        break;
      case 'staging':
        ApiConfig.setEnvironment(AppEnvironment.staging);
        break;
      case 'prod':
        ApiConfig.setEnvironment(AppEnvironment.prod);
        break;
      default:
        if (kDebugMode) {
          print('[App] Unknown ENV=$envDefine, using prod');
        }
        ApiConfig.setEnvironment(AppEnvironment.prod);
    }
  } else if (kDebugMode) {
    ApiConfig.setEnvironment(AppEnvironment.dev);
  } else {
    ApiConfig.setEnvironment(AppEnvironment.prod);
  }
  if (kDebugMode) {
    print('[App] Starting Noor Journey...');
    print('[App] Platform: ${kIsWeb ? 'Web' : 'Native'}');
    print('[App] Environment: ${ApiConfig.environment.name}');
    print('[App] API Base URL: ${ApiConfig.baseUrl}');
  }

  try {
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize Hive cache
    await CacheManager.initialize();

    // Initialize local notification service (no-op on web)
    if (!kIsWeb) {
      await NotificationService.instance.initialize();
    }

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const App(),
      ),
    );
  } catch (e, st) {
    if (kDebugMode) {
      print('[App] Startup failed: $e');
      print(st);
    }
    runApp(_StartupErrorApp(message: _safeStartupMessage(e)));
  }
}

/// User-facing message for startup failure (no tokens or internal details).
String _safeStartupMessage(Object e) {
  final s = e.toString().toLowerCase();
  if (s.contains('shared_preferences') || s.contains('preferences')) {
    return 'Storage could not be initialized. Restart the app.';
  }
  return 'App failed to start. Please restart the app.';
}

/// Shown when main() initialization throws (e.g. SharedPreferences / cache init).
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Startup failed',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                const Text(
                  'Please close and reopen the app.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
