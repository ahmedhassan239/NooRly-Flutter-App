# Implementation Checklist & Audit Summary

## 0) AUDIT SEARCH RESULTS (before changes)

### authProvider / AuthState / AuthStatus
- **lib/features/auth/providers/auth_provider.dart**: `authProvider`, `AuthNotifier`, `AuthState`, `AuthStatus` (enum: initial, authenticated, unauthenticated, guest, loading, error)
- **lib/features/auth/domain/entities/user_entity.dart**: `AuthStatus` enum, `AuthState` class
- **lib/app/router.dart**: `ref.read(authProvider)`, `auth.status`, `ref.listen<AuthState>(authProvider, ...)`
- **lib/app/app.dart**: `ref.read(authProvider.notifier).initialize()` in initState
- Saved pages, login, register, profile, onboarding: watch/auth checks

### apiClientProvider / Dio / interceptors
- **lib/core/providers/core_providers.dart**: `apiClientProvider` → `ApiClient`
- **lib/core/api/api_client.dart**: Dio with `LoggingInterceptor`, `LocaleInterceptor`, `AuthInterceptor`, `RetryInterceptor`, `ErrorInterceptor`, `RequestIdInterceptor`
- **lib/core/api/interceptors/auth_interceptor.dart**: Attaches `Authorization: Bearer <token>` from `TokenStorage`
- Logging enabled when `ApiConfig.enableLogging` (dev)

### SavedItemEndpoints / Saved / saved-items
- **lib/core/config/endpoints.dart**: `_savedBase = '/saved'`, `SavedEndpoints.list`, `SavedEndpoints.save(type, itemId)`, `SavedEndpoints.unsave(type, itemId)`. **No `/saved-items`** — already aligned with backend `/saved`.
- **lib/features/saved/data/saved_api.dart**: All GET/POST/DELETE use `SavedEndpoints.list` and `SavedEndpoints.save/unsave` (i.e. `/saved`).
- **Backend** (routes/api_v1.php): `GET /saved`, `POST /saved/{type}/{itemId}`, `DELETE /saved/{type}/{itemId}` (auth:sanctum).

### Saved providers
- **lib/features/saved/presentation/providers/saved_providers.dart**: `savedHadithListProvider`, `savedVerseListProvider`, `savedAdhkarListProvider`, `savedDuaListProvider`, `savedLessonListProvider`; IDs providers; `toggleSaveProvider`; invalidates list + IDs on toggle.
- **lib/features/hadith/data/saved_hadith_api.dart**: `savedHadithListProvider` (legacy), uses `SavedEndpoints`.

### Prayer / location / permission
- **lib/features/prayer/presentation/pages/prayer_times_page.dart**: `PrayerTimesPage`, `locationNotifierProvider`, permission handling in `requestLocation()`.
- **lib/features/prayer/providers/location_notifier.dart**: `LocationNotifier`, `requestLocation()`, `Geolocator.checkPermission/requestPermission`, cache via `LocationService`.
- **lib/features/prayer/data/location_service.dart**: `getCachedLocation`, `saveLocation`, TTL 7 days.
- **AndroidManifest.xml**: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` present.

### AppConfig
- **lib/core/config/endpoints.dart**: `ConfigEndpoints.appConfig = '/app-config'`
- **lib/features/remote_config/**: repository, model, entity, providers (`appConfigProvider`, maintenance, features, locales, etc.)

### Settings screen
- **lib/features/settings/presentation/pages/settings_page.dart**: Uses `notificationsEnabledConfigProvider`, `defaultPrayerMethodConfigProvider`, `appNameConfigProvider`, `appVersionConfigProvider`, `supportedLocalesProvider`, etc. from remote_config.

---

## CHANGES MADE

1. **Saved API**
   - Logging: all GET/POST/DELETE log status, URL, query, and first **300 chars** of response body (`[SavedApi]`).
   - Endpoints: already `/saved`; no change.
   - Auth: `AuthInterceptor` already adds Bearer token; saved endpoints require auth.

2. **Saved Duas UI**
   - `SavedDuaItem.fromJson`: fallback title from `text`/`text_en`/`text_ar` (preview 40 chars) when `title` is null/empty.
   - Saved Duas card: display title from `dua.title ?? dua.titleAr ?? dua.source ??` text preview or `'Dua'`.

3. **Prayer**
   - **LocationService**: added `location_permission_requested` (get/set) in SharedPreferences.
   - **LocationNotifier**: set `location_permission_requested` when `requestLocation()` is called.
   - **PrayerTimesPage**: "Refresh location" button; success SnackBar for "Location updated".
   - **PrayerApi**: debug log `address`, `method`, `school`, `timezone`, `Fajr(raw)` after fetch.

4. **Router / Welcome**
   - **WelcomePage**: `ConsumerWidget`; when `auth.status == AuthStatus.initial || loading` show full-screen blue loading (no welcome flicker).
   - When auth resolves to authenticated, existing redirect sends to `/home`.

5. **WelcomePage (new blue background)**
   - Replaced red/orange image with **blue gradient** (`_blueDark`, `_bluePrimary`, `_blueAccent`).
   - Content area uses same blue scaffold; text white/white70.
   - Tagline set to: "Your companion in building a life of faith, step by step."
   - "Continue as Guest" with icon.

6. **Dio logging**
   - **LoggingInterceptor**: response log includes **duration (ms)** from `start_time` in extra.
   - **`_formatBody(data, maxLen)`**: default `maxLen = 300`; request/response bodies truncated to 300 chars.
   - Replaced `print` with `debugPrint` (kDebugMode).

7. **AppConfig / Settings / feature gating**
   - Already implemented in previous work (remote_config, maintenance, feature gates, Settings wired).

---

## MANUAL TEST CHECKLIST

- [ ] **Saved adhkar** – Save an adhkar from library; open Saved Adhkar; item appears. Toggle unsave; list updates.
- [ ] **Saved hadith** – Same flow for hadith.
- [ ] **Saved verses** – Same for verses.
- [ ] **Saved duas** – Same for duas; list shows real titles/text (not only "Dua").
- [ ] **Saved per user** – Logout, login as another user; saved lists are different.
- [ ] **Endpoints** – In debug logs, GET/POST/DELETE saved show `/saved` and `type=...` (not `/saved-items`).
- [ ] **Dio logs** – In debug: `[API] REQUEST`, `[API] RESPONSE status=... duration=...ms`, snippet ≤300 chars.
- [ ] **Prayer Fajr** – Set location; check console for `[PrayerApi] address=... method=... Fajr(raw)=...`; compare with expected method (e.g. 5 = Egyptian).
- [ ] **Location** – Grant location once; restart app; cached location used (no prompt). Tap "Refresh location" to update.
- [ ] **Authenticated startup** – With valid token, cold start shows blue loading then redirect to `/home` (no welcome flash).
- [ ] **App-config & feature gating** – Toggle `maintenance_mode` → maintenance screen; remove `prayer_times` from `features_enabled` → Prayer tab hidden and route blocked.
- [ ] **Welcome background** – Welcome page uses new blue gradient (no red/orange image).

---

## HOW TO VERIFY

| Check | Steps | Expected |
|-------|--------|----------|
| Saved list | Login → save a hadith/verse/dua/adhkar → open corresponding Saved page | Item appears; count in header |
| Saved API | Run app in debug; trigger save or open Saved page | Console: `[SavedApi] GET /saved status=200 ... body={...}` (first 300 chars) |
| Auth on saved | Logout → open Saved page | "Sign in to view saved" or empty; no 401 if you don’t call API when guest |
| Prayer logs | Open Prayer tab, set location | `[PrayerApi] address=... method=5 ... Fajr(raw)=05:xx` |
| Location cache | Set location → kill app → reopen | Prayer times show without asking permission again (if within 7 days) |
| Router | Logged in → cold start | Brief blue loading then `/home` |
| Welcome blue | Logged out → open app | Blue gradient welcome (no red/orange) |
| Dio | Any API call in debug | `[API] REQUEST id=...`, `[API] RESPONSE ... duration=...ms` |

---

## ENDPOINT ALIGNMENT

- **Flutter** uses `SavedEndpoints.list` = `/saved`, `SavedEndpoints.save(type, id)` = `/saved/{type}/{id}` (POST), `SavedEndpoints.unsave(type, id)` = `/saved/{type}/{id}` (DELETE). **Matches backend** `/api/v1/saved` and `/api/v1/saved/{type}/{itemId}`.
- No `/saved-items` references in Flutter.
