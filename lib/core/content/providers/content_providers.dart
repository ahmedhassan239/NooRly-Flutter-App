/// Content providers for Duas, Hadith, Verses, Adhkar.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/content/data/models/content_model.dart';
import 'package:flutter_app/core/content/domain/entities/content_entity.dart';
import 'package:flutter_app/core/content/domain/repositories/content_repository.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/adhkar/data/repositories/adhkar_remote_repository.dart';
import 'package:flutter_app/features/duas/data/repositories/duas_remote_repository.dart';
import 'package:flutter_app/features/hadith/data/repositories/hadith_remote_repository.dart';
import 'package:flutter_app/features/verses/data/repositories/verses_remote_repository.dart';

// ============================================================================
// Repository Providers
// ============================================================================

/// Duas repository provider.
final duasRepositoryProvider = Provider<ContentRepository<ContentEntity>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DuasRemoteRepository(apiClient: apiClient);
});

/// Hadith repository provider.
final hadithRepositoryProvider = Provider<ContentRepository<HadithEntity>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HadithRemoteRepository(apiClient: apiClient);
});

/// Verses repository provider.
final versesRepositoryProvider = Provider<ContentRepository<VerseEntity>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VersesRemoteRepository(apiClient: apiClient);
});

/// Adhkar repository provider.
final adhkarRepositoryProvider = Provider<ContentRepository<DhikrEntity>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdhkarRemoteRepository(apiClient: apiClient);
});

// ============================================================================
// Duas Providers
// ============================================================================

/// All duas provider.
final allDuasProvider = FutureProvider<List<ContentEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getAll();
});

/// Duas categories provider.
final duasCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getCategories();
});

/// Duas by category provider.
/// Fetches via API (GET /duas/category/:id). Accepts both response shapes:
/// - Wrapped: { "status", "message", "data": [...] }
/// - Raw array: [...] (avoids TypeError when backend or proxy returns array)
final duasByCategoryProvider =
    FutureProvider.family<List<ContentEntity>, String>((ref, categoryId) async {
  final client = ref.watch(apiClientProvider);
  try {
    final response = await client.dio.get<dynamic>(DuasEndpoints.byCategory(categoryId));
    final body = response.data;
    if (body == null) return [];
    List<dynamic> list;
    if (body is List) {
      list = body;
    } else if (body is Map<String, dynamic>) {
      final raw = body['data'];
      list = raw is List ? raw : (body['items'] as List? ?? <dynamic>[]);
    } else {
      return [];
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => ContentModel.fromJson(e, ContentType.dua).toEntity())
        .toList();
  } catch (_) {
    rethrow;
  }
});

/// Dua detail provider.
final duaDetailProvider =
    FutureProvider.family<ContentEntity, String>((ref, id) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getById(id);
});

/// Saved duas provider.
final savedDuasProvider = FutureProvider<List<ContentEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getSaved();
});

/// Search duas provider.
final searchDuasProvider =
    FutureProvider.family<List<ContentEntity>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(duasRepositoryProvider);
  return repository.search(query);
});

// ============================================================================
// Hadith Providers
// ============================================================================

/// All hadith provider.
final allHadithProvider = FutureProvider<List<HadithEntity>>((ref) async {
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.getAll();
});

/// Hadith categories provider.
final hadithCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.getCategories();
});

/// Hadith by category provider.
final hadithByCategoryProvider =
    FutureProvider.family<List<HadithEntity>, String>((ref, categoryId) async {
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.getByCategory(categoryId);
});

/// Hadith detail provider.
final hadithDetailProvider =
    FutureProvider.family<HadithEntity, String>((ref, id) async {
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.getById(id);
});

/// Saved hadith provider.
final savedHadithProvider = FutureProvider<List<HadithEntity>>((ref) async {
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.getSaved();
});

/// Search hadith provider.
final searchHadithProvider =
    FutureProvider.family<List<HadithEntity>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(hadithRepositoryProvider);
  return repository.search(query);
});

// ============================================================================
// Verses Providers
// ============================================================================

/// All verses provider.
final allVersesProvider = FutureProvider<List<VerseEntity>>((ref) async {
  final repository = ref.watch(versesRepositoryProvider);
  return repository.getAll();
});

/// Verses categories provider.
final versesCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(versesRepositoryProvider);
  return repository.getCategories();
});

/// Verses by category provider.
final versesByCategoryProvider =
    FutureProvider.family<List<VerseEntity>, String>((ref, categoryId) async {
  final repository = ref.watch(versesRepositoryProvider);
  return repository.getByCategory(categoryId);
});

/// Verse detail provider.
final verseDetailProvider =
    FutureProvider.family<VerseEntity, String>((ref, id) async {
  final repository = ref.watch(versesRepositoryProvider);
  return repository.getById(id);
});

/// Saved verses provider.
final savedVersesProvider = FutureProvider<List<VerseEntity>>((ref) async {
  final repository = ref.watch(versesRepositoryProvider);
  return repository.getSaved();
});

/// Search verses provider.
final searchVersesProvider =
    FutureProvider.family<List<VerseEntity>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(versesRepositoryProvider);
  return repository.search(query);
});

// ============================================================================
// Adhkar Providers
// ============================================================================

/// All adhkar provider.
final allAdhkarProvider = FutureProvider<List<DhikrEntity>>((ref) async {
  final repository = ref.watch(adhkarRepositoryProvider);
  return repository.getAll();
});

/// Adhkar categories provider.
final adhkarCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repository = ref.watch(adhkarRepositoryProvider);
  return repository.getCategories();
});

/// Adhkar by category provider.
final adhkarByCategoryProvider =
    FutureProvider.family<List<DhikrEntity>, String>((ref, categoryId) async {
  final repository = ref.watch(adhkarRepositoryProvider);
  return repository.getByCategory(categoryId);
});

/// Dhikr detail provider.
final dhikrDetailProvider =
    FutureProvider.family<DhikrEntity, String>((ref, id) async {
  final repository = ref.watch(adhkarRepositoryProvider);
  return repository.getById(id);
});

/// Saved adhkar provider.
final savedAdhkarProvider = FutureProvider<List<DhikrEntity>>((ref) async {
  final repository = ref.watch(adhkarRepositoryProvider);
  return repository.getSaved();
});

// ============================================================================
// Save/Unsave Actions
// ============================================================================

/// Save content action provider.
class SaveContentNotifier extends StateNotifier<AsyncValue<void>> {
  SaveContentNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> saveDua(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(duasRepositoryProvider).save(id);
      _ref.invalidate(savedDuasProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> unsaveDua(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(duasRepositoryProvider).unsave(id);
      _ref.invalidate(savedDuasProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveHadith(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(hadithRepositoryProvider).save(id);
      _ref.invalidate(savedHadithProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> unsaveHadith(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(hadithRepositoryProvider).unsave(id);
      _ref.invalidate(savedHadithProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveVerse(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(versesRepositoryProvider).save(id);
      _ref.invalidate(savedVersesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> unsaveVerse(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(versesRepositoryProvider).unsave(id);
      _ref.invalidate(savedVersesProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveDhikr(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(adhkarRepositoryProvider).save(id);
      _ref.invalidate(savedAdhkarProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> unsaveDhikr(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(adhkarRepositoryProvider).unsave(id);
      _ref.invalidate(savedAdhkarProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Save content provider.
final saveContentProvider =
    StateNotifierProvider<SaveContentNotifier, AsyncValue<void>>((ref) {
  return SaveContentNotifier(ref);
});
