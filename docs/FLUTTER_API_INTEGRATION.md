# NooRly Flutter API Integration

## Overview

This document describes the API integration architecture for the NooRly Flutter app. The app connects to a Laravel backend at `https://admin.noorly.net/api/v1`.

## Table of Contents

1. [Configuration](#configuration)
2. [API Client](#api-client)
3. [Authentication](#authentication)
4. [Endpoints Matrix](#endpoints-matrix)
5. [Data Flow](#data-flow)
6. [Caching](#caching)
7. [Error Handling](#error-handling)
8. [Testing](#testing)

---

## Configuration

### Environment Setup

The app supports three environments:

| Environment | Base URL |
|-------------|----------|
| `dev` | `http://localhost:8000/api/v1` |
| `staging` | `https://staging.noorly.net/api/v1` |
| `prod` | `https://admin.noorly.net/api/v1` |

**Important:** The base URL already includes `/api/v1`. All endpoint paths should be relative.

### Setting Environment

```dart
// In main.dart
import 'package:flutter_app/core/config/api_config.dart';

void main() {
  // Set environment based on build mode
  if (kDebugMode) {
    ApiConfig.setEnvironment(AppEnvironment.dev);
  } else {
    ApiConfig.setEnvironment(AppEnvironment.prod);
  }
  // ...
}
```

### Configuration File

Location: `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  static String get baseUrl {
    switch (_environment) {
      case AppEnvironment.dev:
        return 'http://localhost:8000/api/v1';
      case AppEnvironment.staging:
        return 'https://staging.noorly.net/api/v1';
      case AppEnvironment.prod:
        return 'https://admin.noorly.net/api/v1';
    }
  }
}
```

---

## API Client

### Architecture

```
lib/core/
├── api/
│   ├── api_client.dart          # Main Dio client
│   ├── api_response.dart        # Response models
│   └── interceptors/
│       ├── auth_interceptor.dart     # Adds Bearer token
│       ├── error_interceptor.dart    # Error mapping
│       ├── retry_interceptor.dart    # Retry with backoff
│       ├── logging_interceptor.dart  # Dev logging
│       └── locale_interceptor.dart   # Accept-Language header
├── auth/
│   └── token_storage.dart       # Secure token storage
├── cache/
│   └── cache_manager.dart       # Hive caching
├── config/
│   ├── api_config.dart          # Environment config
│   └── endpoints.dart           # All API endpoints
└── errors/
    └── api_exception.dart       # Exception classes
```

### Making Requests

```dart
// Get the API client from provider
final apiClient = ref.read(apiClientProvider);

// GET request
final response = await apiClient.get<Map<String, dynamic>>(
  '/duas',
  queryParameters: {'page': 1, 'per_page': 20},
);

// POST request
final response = await apiClient.post<Map<String, dynamic>>(
  '/auth/login',
  data: {'email': email, 'password': password},
);

// PUT request
final response = await apiClient.put<Map<String, dynamic>>(
  '/profile',
  data: {'name': 'New Name'},
);

// DELETE request
final response = await apiClient.delete<void>('/duas/123/save');
```

### Response Format

All API responses follow this structure:

```json
{
  "status": true,
  "message": "Success",
  "data": { ... },
  "meta": {
    "pagination": {
      "current_page": 1,
      "last_page": 5,
      "per_page": 15,
      "total": 75
    }
  }
}
```

---

## Authentication

### Token Storage

Tokens are stored securely using `flutter_secure_storage` (native) or `SharedPreferences` (web).

```dart
// Store auth data after login
await tokenStorage.saveAuthData(
  accessToken: response.accessToken,
  refreshToken: response.refreshToken,
  expiry: response.expiryDateTime,
  userId: response.user.id,
);

// Check authentication
final isAuth = await tokenStorage.isAuthenticated();

// Clear on logout
await tokenStorage.clearAll();
```

### Auth Flow

1. **Login/Register** → Store tokens → Navigate to home
2. **App Start** → Check token → Fetch user or redirect to login
3. **401 Response** → Try refresh token → If fails, redirect to login
4. **Logout** → Call logout API → Clear tokens → Navigate to login

### Guest Mode

```dart
// Enter guest mode
await ref.read(authProvider.notifier).enterGuestMode();

// Check if guest
final isGuest = ref.read(isGuestProvider);

// Guest can access content but not save/favorite
if (authState.canAccessContent) {
  // Show content
}
```

### Auth Provider Usage

```dart
// Login
await ref.read(authProvider.notifier).login(
  email: email,
  password: password,
);

// Register
await ref.read(authProvider.notifier).register(
  email: email,
  password: password,
  passwordConfirmation: passwordConfirmation,
  name: name,
);

// Logout
await ref.read(authProvider.notifier).logout();

// Get current user
final user = ref.watch(currentUserProvider);
```

---

## Endpoints Matrix

### Authentication

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Login | POST | `/auth/login` | Email/password login |
| Register | POST | `/auth/register` | Create account |
| Logout | POST | `/auth/logout` | Invalidate token |
| Profile | GET | `/auth/me` | Get current user |
| Refresh | POST | `/auth/refresh` | Refresh access token |
| Social | POST | `/auth/social-login` | Google/Apple/Facebook |

### Onboarding

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Save | POST | `/onboarding` | Save onboarding data |
| Status | GET | `/onboarding/status` | Check completion |

### Home

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Dashboard | GET | `/home/dashboard` | Home data |
| Featured | GET | `/home/featured` | Featured content |
| Config | GET | `/app-config` | Remote config |

### Journey & Lessons

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Journey | GET | `/journey` | User's journey |
| Progress | GET | `/journey/progress` | Progress stats |
| Saved | GET | `/journey/saved` | Saved lessons |
| Lesson | GET | `/lessons/:day` | Lesson detail |
| Complete | POST | `/journey/lessons/:day/complete` | Mark complete |

### Content (Duas, Hadith, Verses, Adhkar)

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| List | GET | `/{type}` | All items |
| Categories | GET | `/{type}/categories` | Categories |
| By Category | GET | `/{type}/category/:id` | Items in category |
| Detail | GET | `/{type}/:id` | Single item |
| Saved | GET | `/{type}/saved` | Saved items |
| Save | POST | `/{type}/:id/save` | Save item |
| Unsave | DELETE | `/{type}/:id/save` | Unsave item |
| Search | GET | `/{type}/search?q=` | Search items |

Where `{type}` is one of: `duas`, `hadith`, `verses`, `adhkar`

### Prayer Times

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Times | GET | `/prayer-times?lat=&lng=` | Prayer times |
| Settings | GET | `/prayer-times/settings` | Notification settings |
| Update | PUT | `/prayer-times/settings` | Update settings |

### Profile & Settings

| Screen | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| Profile | GET | `/profile` | User profile |
| Update | PUT | `/profile` | Update profile |
| Avatar | POST | `/profile/avatar` | Upload avatar |
| Delete | DELETE | `/profile` | Delete account |
| Settings | GET | `/settings` | User settings |
| Update | PUT | `/settings` | Update settings |

---

## Data Flow

### Repository Pattern

```
UI (Page/Widget)
    ↓
Provider (Riverpod)
    ↓
Repository (Interface)
    ↓
Repository Implementation
    ↓
API Client (Dio)
    ↓
Backend API
```

### Example: Fetching Duas

```dart
// 1. Provider watches repository
final allDuasProvider = FutureProvider<List<ContentEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getAll();
});

// 2. Repository fetches from API
class DuasRemoteRepository extends BaseContentRepository<ContentEntity> {
  @override
  Future<List<ContentEntity>> getAll() async {
    final response = await _apiClient.get('/duas');
    // Parse and cache
    return items;
  }
}

// 3. UI consumes provider
class DuasHubPage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final duasAsync = ref.watch(allDuasProvider);
    
    return duasAsync.when(
      data: (duas) => ListView(...),
      loading: () => LoadingWidget(),
      error: (e, st) => ErrorWidget(e),
    );
  }
}
```

---

## Caching

### Cache Strategy

- **Remote Config**: 1 hour
- **Home Data**: 30 minutes
- **Content Lists**: 24 hours
- **Content Details**: 7 days
- **User Profile**: 1 hour
- **Prayer Times**: 24 hours
- **Categories**: 7 days

### Cache Usage

```dart
// Store in cache
await CacheManager.put(
  box: CacheBoxes.content,
  key: CacheKeys.duasList,
  data: duasJson,
  expiry: CacheDurations.contentList,
);

// Get from cache
final cached = await CacheManager.get<List<dynamic>>(
  box: CacheBoxes.content,
  key: CacheKeys.duasList,
);

// Check if cached
final hasCached = await CacheManager.has(
  box: CacheBoxes.content,
  key: CacheKeys.duasList,
);

// Clear cache
await CacheManager.clearBox(CacheBoxes.content);
```

### Offline Support

Repositories automatically fall back to cached data when API fails:

```dart
Future<List<T>> getAll() async {
  try {
    final response = await _apiClient.get(endpoint);
    // Cache and return
  } catch (e) {
    // Return cached data if available
    final cached = await getCached();
    if (cached != null) return cached;
    rethrow;
  }
}
```

---

## Error Handling

### Exception Types

| Exception | Status Code | Description |
|-----------|-------------|-------------|
| `NetworkException` | - | No internet |
| `TimeoutException` | - | Request timeout |
| `UnauthorizedException` | 401 | Invalid/expired token |
| `ForbiddenException` | 403 | No permission |
| `NotFoundException` | 404 | Resource not found |
| `ValidationException` | 422 | Validation errors |
| `RateLimitException` | 429 | Too many requests |
| `ServerException` | 5xx | Server error |

### Handling Errors

```dart
try {
  await ref.read(authProvider.notifier).login(email, password);
} on ValidationException catch (e) {
  // Show field errors
  final emailError = e.getFieldError('email');
  final passwordError = e.getFieldError('password');
} on UnauthorizedException catch (e) {
  // Invalid credentials
  showError('Invalid email or password');
} on NetworkException catch (e) {
  // No internet
  showError('Please check your connection');
} on ApiException catch (e) {
  // Generic error
  showError(e.message);
}
```

### Global 401 Handling

The `ErrorInterceptor` handles 401 globally:

```dart
ErrorInterceptor(
  onUnauthorized: () async {
    // Try refresh token, then logout if failed
    await authNotifier.handleUnauthorized();
  },
)
```

---

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/config/api_config_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── core/
│   ├── api/
│   │   └── api_client_test.dart
│   ├── auth/
│   │   └── token_storage_test.dart
│   └── config/
│       └── api_config_test.dart
├── features/
│   ├── auth/
│   │   └── auth_models_test.dart
│   └── content/
│       └── content_models_test.dart
└── integration/
    └── auth_flow_test.dart
```

### Key Test Cases

1. **API Config**: Base URL includes `/api/v1` for all environments
2. **Error Mapping**: Correct exception types for status codes
3. **Token Storage**: Secure storage and retrieval
4. **Models**: JSON parsing and serialization
5. **Endpoints**: Correct URL construction

---

## Internationalization

### Setting Locale

```dart
// In API client
apiClient.setLocale(Locale('ar'));

// Or via provider
ref.read(localeProvider.notifier).state = Locale('ar');
```

### Accept-Language Header

The `LocaleInterceptor` automatically adds the header:

```
Accept-Language: ar
```

### Localized Content

Models support localized fields:

```dart
// Get localized title
final title = dua.getTitle(locale); // Returns titleAr for 'ar'

// Get localized category
final category = dua.getCategoryName(locale);
```

---

## Best Practices

### DO

- ✅ Use relative endpoints (e.g., `/auth/login`)
- ✅ Handle errors gracefully with fallback to cache
- ✅ Use providers for dependency injection
- ✅ Test API configuration and error mapping
- ✅ Use secure storage for tokens

### DON'T

- ❌ Hardcode `/api/v1` in endpoints
- ❌ Store tokens in plain SharedPreferences (use secure storage)
- ❌ Ignore 401 responses (handle globally)
- ❌ Skip caching for frequently accessed data
- ❌ Make API calls directly from UI (use repositories)

---

## File Structure

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart
│   │   ├── api_response.dart
│   │   └── interceptors/
│   ├── auth/
│   │   └── token_storage.dart
│   ├── cache/
│   │   └── cache_manager.dart
│   ├── config/
│   │   ├── api_config.dart
│   │   └── endpoints.dart
│   ├── content/
│   │   ├── data/
│   │   ├── domain/
│   │   └── providers/
│   ├── errors/
│   │   └── api_exception.dart
│   └── providers/
│       └── core_providers.dart
└── features/
    ├── auth/
    ├── home/
    ├── journey/
    ├── prayer/
    ├── profile/
    ├── remote_config/
    ├── settings/
    ├── duas/
    ├── hadith/
    ├── verses/
    └── adhkar/
```

---

## Changelog

### v1.0.0

- Initial API integration
- Full auth flow with secure token storage
- Content modules (Duas, Hadith, Verses, Adhkar)
- Journey and Lessons API
- Prayer Times API
- Profile and Settings API
- Hive caching layer
- Comprehensive error handling
- Unit and integration tests
