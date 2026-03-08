/// API Endpoints - All paths are relative to BASE_URL.
///
/// BASE_URL already includes `/api/v1`, so endpoints should NOT
/// include that prefix.
///
/// Example:
///   Endpoint: `/auth/login`
///   Full URL: `https://admin.noorly.net/api/v1/auth/login`
library;

/// Authentication endpoints.
abstract class AuthEndpoints {
  /// POST - Login with email/password
  static const String login = '/auth/login';

  /// POST - Register new user
  static const String register = '/auth/register';

  /// POST - Logout (invalidate token)
  static const String logout = '/auth/logout';

  /// GET - Get current authenticated user (profile + onboarding summary)
  static const String me = '/me';

  /// POST - Refresh access token (if supported)
  static const String refresh = '/auth/refresh';

  /// POST - Request password reset
  static const String forgotPassword = '/auth/forgot-password';

  /// POST - Reset password with token
  static const String resetPassword = '/auth/reset-password';

  /// POST - Social login (Google, Apple, Facebook)
  static const String socialLogin = '/auth/social-login';

  /// POST - Send/Resend Email OTP
  static const String sendEmailOtp = '/auth/email/send-otp';

  /// POST - Verify Email OTP
  static const String verifyEmailOtp = '/auth/email/verify-otp';
}

/// App configuration endpoints.
abstract class ConfigEndpoints {
  /// GET - App configuration (home sections, features, etc.)
  static const String appConfig = '/app-config';
}

/// Content scopes endpoints (Library tabs: Duas, Hadith, Verses, Adhkar).
abstract class ContentScopeEndpoints {
  /// GET - List active content scopes (key, label)
  static const String list = '/content-scopes';

  /// GET - Library tabs only (active + show_in_library_tabs), ordered by display_order
  static const String libraryTabs = '/content-scopes?context=library_tabs';
}

/// Library Hadith (collections list + collection details).
abstract class LibraryHadithEndpoints {
  /// GET - List hadith categories (legacy; prefer collections)
  static const String categories = '/library/hadith/categories';
  /// GET - All hadith collections (no category). Sorted by display_order, includes items_count.
  static const String collections = '/library/hadith/collections';
  /// Same as [collections]. Use for "all collections" API (no categories).
  static String get collectionsAll => collections;
  /// GET - Collections for a category (legacy)
  static String collectionsByCategory(int id) =>
      '/library/hadith/categories/$id/collections';
  /// GET - Single hadith collection by id
  static String collection(int id) => '/library/hadith/collections/$id';
}

/// Library Verses (categories → collections → verses).
abstract class LibraryVersesEndpoints {
  static const String categories = '/library/verses/categories';
  /// GET - All verse collections (no category). Sorted by display_order, includes items_count.
  static const String collections = '/library/verses/collections';
  static String get collectionsAll => collections;
  static String collectionsByCategory(int categoryId) =>
      '/library/verses/categories/$categoryId/collections';
  static String collection(int id) => '/library/verses/collections/$id';
}

/// Library unified by scope (hadith, verses, duas, adhkar, etc.).
abstract class LibraryEndpoints {
  static String categories(String scopeKey) =>
      '/library/$scopeKey/categories';
  static String collections(String scopeKey, int categoryId) =>
      '/library/$scopeKey/categories/$categoryId/collections';
  static String collectionDetail(String scopeKey, int collectionId) =>
      '/library/$scopeKey/collections/$collectionId';
}

/// Onboarding endpoints (under authenticated /me).
abstract class OnboardingEndpoints {
  /// GET - Get full onboarding state (shahada_date, goals, completed, current_step)
  static const String get = '/me/onboarding';

  /// PUT - Update onboarding (partial: shahada_date, goals, summary_completed)
  static const String update = '/me/onboarding';
}

/// Home/Dashboard endpoints.
abstract class HomeEndpoints {
  /// GET - Dashboard data (stats, progress, featured)
  static const String dashboard = '/home/dashboard';

  /// GET - Featured content for home
  static const String featured = '/home/featured';

  /// GET - Daily inspiration (one random item: ayah, hadith, dhikr, dua)
  static const String dailyInspiration = '/daily-inspiration';
}

/// Journey/Learning endpoints.
abstract class JourneyEndpoints {
  /// GET - User's learning journey (weeks + lessons + progress)
  static const String journey = '/journey';

  /// GET - Compact journey profile summary (day, streak, milestones, etc.)
  static const String summary = '/journey/summary';

  /// GET - Journey progress/stats
  static const String progress = '/journey/progress';

  /// GET - Saved/bookmarked journey items
  static const String saved = '/journey/saved';

  /// POST - Mark lesson as complete (by lesson id)
  static String completeLesson(String lessonId) => '/lessons/$lessonId/complete';
}

/// Lessons endpoints.
abstract class LessonsEndpoints {
  /// GET - All lessons
  static const String list = '/lessons';

  /// GET - Today's lesson (next in journey for home dashboard)
  static const String today = '/lessons/today';

  /// GET - Single lesson by id
  static String detail(String id) => '/lessons/$id';

  /// GET - Lessons by category
  static String byCategory(String categoryId) => '/lessons/category/$categoryId';
}

/// Prayer times endpoints.
abstract class PrayerEndpoints {
  /// GET - Prayer times for location
  /// Query params: latitude, longitude, date
  static const String times = '/prayer-times';

  /// GET - Prayer times settings
  static const String settings = '/prayer-times/settings';
}

/// Duas endpoints.
abstract class DuasEndpoints {
  /// GET - All duas
  static const String list = '/duas';

  /// GET - Duas categories
  static const String categories = '/duas/categories';

  /// GET - Single dua by ID
  static String detail(String id) => '/duas/$id';

  /// GET - Duas by category
  static String byCategory(String categoryId) => '/duas/category/$categoryId';

  /// GET - Saved/favorite duas (via unified saved endpoint)
  static String get saved => SavedEndpoints.list;

  /// POST - Save a dua (unified: POST /saved/dua/{id})
  static String save(String id) => SavedEndpoints.save('dua', id);

  /// DELETE - Unsave a dua (unified: DELETE /saved/dua/{id})
  static String unsave(String id) => SavedEndpoints.unsave('dua', id);

  /// GET - Search duas
  /// Query params: q (search query)
  static const String search = '/duas/search';
}

/// Hadith endpoints.
abstract class HadithEndpoints {
  /// GET - All hadith
  static const String list = '/hadith';

  /// GET - Daily hadith (for home inspiration)
  static const String daily = '/hadith/daily';

  /// GET - Hadith categories
  static const String categories = '/hadith/categories';

  /// GET - Single hadith by ID
  static String detail(String id) => '/hadith/$id';

  /// GET - Hadith by category
  static String byCategory(String categoryId) => '/hadith/category/$categoryId';

  /// GET - Saved/favorite hadith (via unified saved endpoint)
  static String get saved => SavedEndpoints.list;

  /// POST - Save a hadith (unified: POST /saved/hadith/{id})
  static String save(String id) => SavedEndpoints.save('hadith', id);

  /// DELETE - Unsave a hadith (unified: DELETE /saved/hadith/{id})
  static String unsave(String id) => SavedEndpoints.unsave('hadith', id);

  /// GET - Search hadith
  /// Query params: q (search query)
  static const String search = '/hadith/search';
}

/// Verses (Quran) endpoints.
abstract class VersesEndpoints {
  /// GET - All verses
  static const String list = '/verses';

  /// GET - Verses categories (themes/topics)
  static const String categories = '/verses/categories';

  /// GET - Single verse by ID
  static String detail(String id) => '/verses/$id';

  /// GET - Verses by category/theme
  static String byCategory(String categoryId) => '/verses/category/$categoryId';

  /// GET - Saved/favorite verses (via unified saved endpoint)
  static String get saved => SavedEndpoints.list;

  /// POST - Save a verse (unified: POST /saved/verse/{id})
  static String save(String id) => SavedEndpoints.save('verse', id);

  /// DELETE - Unsave a verse (unified: DELETE /saved/verse/{id})
  static String unsave(String id) => SavedEndpoints.unsave('verse', id);

  /// GET - Search verses
  /// Query params: q (search query)
  static const String search = '/verses/search';
}

/// Generic categories by scope (GET /categories?scope=adhkar).
abstract class CategoriesEndpoints {
  static const String list = '/categories';
}

/// Adhkar endpoints.
abstract class AdhkarEndpoints {
  /// GET - All adhkar
  static const String list = '/adhkar';

  /// GET - Adhkar categories (key-based: morning, evening, etc.)
  static const String categories = '/adhkar/categories';

  /// GET - Adhkar by admin category ID (Library scope=Adhkar)
  static String byCategoryId(int id) => '/adhkar/by-category/$id';

  /// GET - Single dhikr by ID
  static String detail(String id) => '/adhkar/$id';

  /// GET - Adhkar by category key (legacy)
  static String byCategory(String categoryId) => '/adhkar/category/$categoryId';

  /// GET - Saved/favorite adhkar (via unified saved endpoint)
  static String get saved => SavedEndpoints.list;

  /// POST - Save a dhikr (unified: POST /saved/adhkar/{id})
  static String save(String id) => SavedEndpoints.save('adhkar', id);

  /// DELETE - Unsave a dhikr (unified: DELETE /saved/adhkar/{id})
  static String unsave(String id) => SavedEndpoints.unsave('adhkar', id);
}

/// Profile endpoints (backend uses /me for GET user; profile update is /me/profile).
abstract class ProfileEndpoints {
  /// GET - User profile (use AuthEndpoints.me for full user + profile)
  static const String profile = '/me';

  /// PUT - Update profile
  static const String update = '/me/profile';

  /// POST - Upload avatar
  static const String avatar = '/profile/avatar';

  /// DELETE - Delete account
  static const String delete = '/profile';
}

/// Saved items (bookmarks) — GET list by type, POST/DELETE by type and id.
/// Backend uses /saved (NOT /saved-items).
/// Routes: GET /saved?type=..., POST /saved/{type}/{id}, DELETE /saved/{type}/{id}
const String _savedBase = '/saved';

abstract class SavedEndpoints {
  /// GET /saved?type={type}&page={page}&per_page={perPage}
  static String get list => _savedBase;

  /// POST /saved/{type}/{itemId}
  static String save(String type, String itemId) => '$_savedBase/$type/$itemId';

  /// DELETE /saved/{type}/{itemId}
  static String unsave(String type, String itemId) => '$_savedBase/$type/$itemId';
}

/// Legacy alias — prefer [SavedEndpoints].
typedef SavedItemEndpoints = SavedEndpoints;

/// Settings endpoints.
abstract class SettingsEndpoints {
  /// GET - User settings
  static const String settings = '/settings';

  /// PUT - Update settings
  static const String update = '/settings';

  /// GET - Notification settings
  static const String notifications = '/settings/notifications';

  /// PUT - Update notification settings
  static const String updateNotifications = '/settings/notifications';
}
