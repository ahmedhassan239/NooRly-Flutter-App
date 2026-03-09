/// Persistent locale controller for app language selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/core/providers/core_providers.dart';

const _localeStorageKey = 'app_locale';
const _supportedLanguageCodes = ['en', 'ar'];

/// Manages app locale with SharedPreferences persistence.
class LocaleController extends StateNotifier<Locale> {
  LocaleController(SharedPreferences prefs)
      : _prefs = prefs,
        super(_loadLocale(prefs));

  final SharedPreferences _prefs;

  static Locale _loadLocale(SharedPreferences prefs) {
    final code = prefs.getString(_localeStorageKey);
    if (code != null && _supportedLanguageCodes.contains(code)) {
      return Locale(code);
    }
    return const Locale('en');
  }

  /// Change the app locale and persist the selection.
  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) return;
    if (state.languageCode == locale.languageCode) return;
    state = locale;
    await _prefs.setString(_localeStorageKey, locale.languageCode);
  }

  bool get isArabic => state.languageCode == 'ar';
  bool get isEnglish => state.languageCode == 'en';
}

/// Persistent locale provider — replaces the old raw StateProvider.
///
/// SharedPreferences key: `app_locale`
/// Defaults to `Locale('en')` if no saved value is found.
final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleController(prefs);
});

/// Convenience alias so existing `ref.watch(localeProvider)` calls keep working.
final localeProvider = localeControllerProvider;
