import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/core/cache/cache_manager.dart';
import 'package:flutter_app/core/config/api_config.dart';
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

  // Set environment based on build mode
  if (kDebugMode) {
    ApiConfig.setEnvironment(AppEnvironment.dev);
    print('[App] Starting Noor Journey...');
    print('[App] Platform: ${kIsWeb ? 'Web' : 'Native'}');
    print('[App] Environment: ${ApiConfig.environment.name}');
    print('[App] API Base URL: ${ApiConfig.baseUrl}');
  } else {
    ApiConfig.setEnvironment(AppEnvironment.prod);
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Hive cache
  await CacheManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences with initialized instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}
