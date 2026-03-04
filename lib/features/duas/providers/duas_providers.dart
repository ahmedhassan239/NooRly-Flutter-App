import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/duas/data/datasources/duas_local_datasource.dart';
import 'package:flutter_app/features/duas/data/models/dua_model.dart';
import 'package:flutter_app/features/duas/data/repositories/duas_repository_impl.dart';
import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';
import 'package:flutter_app/features/duas/domain/repositories/duas_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data Source Provider
final duasLocalDataSourceProvider = Provider<DuasLocalDataSource>((ref) {
  return DuasLocalDataSource();
});

/// Repository Provider
final duasRepositoryProvider = Provider<DuasRepository>((ref) {
  final dataSource = ref.watch(duasLocalDataSourceProvider);
  return DuasRepositoryImpl(dataSource);
});

/// All Duas Provider
final allDuasProvider = FutureProvider<List<DuaEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getAllDuas();
});

/// Dua categories from Backend API (scope = duas).
/// Rebuilds when invalidated. Use for Library > Duas tab.
/// Accepts both response shapes: top-level array or object with "data"/"categories".
final duaCategoriesFromApiProvider =
    FutureProvider<List<DuaCategoryEntity>>((ref) async {
  ref.keepAlive();
  final client = ref.watch(apiClientProvider);
  List<dynamic> list;
  try {
    // Use raw Dio so we can accept List or Map body (API may return array or { data: [...] }).
    final response = await client.dio.get<dynamic>(DuasEndpoints.categories);
    final body = response.data;
    if (body == null) return _fallbackToLocalCategories(ref);
    if (body is List) {
      list = body;
    } else if (body is Map<String, dynamic>) {
      final raw = body['data'];
      list = raw is List ? raw : (body['categories'] as List? ?? <dynamic>[]);
    } else {
      return _fallbackToLocalCategories(ref);
    }
  } catch (_) {
    return _fallbackToLocalCategories(ref);
  }
  if (list.isEmpty) return _fallbackToLocalCategories(ref);
  return list
      .whereType<Map<String, dynamic>>()
      .map((e) => DuaCategoryModel.fromApiJson(e).toEntity())
      .toList();
});

Future<List<DuaCategoryEntity>> _fallbackToLocalCategories(Ref ref) async {
  final repo = ref.read(duasRepositoryProvider);
  return repo.getCategories();
}

/// All Categories Provider (local-first; use [duaCategoriesFromApiProvider] for Library Duas)
final duaCategoriesProvider = FutureProvider<List<DuaCategoryEntity>>((ref) async {
  final repository = ref.watch(duasRepositoryProvider);
  return repository.getCategories();
});

/// Single category by id from API categories list. Use for category details screen header.
final duaCategoryByIdProvider =
    FutureProvider.family<DuaCategoryEntity?, String>((ref, categoryId) async {
  final categories = await ref.watch(duaCategoriesFromApiProvider.future);
  try {
    return categories.firstWhere((c) => c.id == categoryId);
  } catch (_) {
    return null;
  }
});

/// Duas by Category Provider
final duasByCategoryProvider = FutureProvider.family<List<DuaEntity>, String>(
  (ref, categoryId) async {
    final repository = ref.watch(duasRepositoryProvider);
    return repository.getDuasByCategory(categoryId);
  },
);

/// Single Dua Provider
final duaByIdProvider = FutureProvider.family<DuaEntity?, String>(
  (ref, id) async {
    final repository = ref.watch(duasRepositoryProvider);
    return repository.getDuaById(id);
  },
);

/// Search Duas Provider
final searchDuasProvider = FutureProvider.family<List<DuaEntity>, String>(
  (ref, query) async {
    if (query.isEmpty) {
      return ref.watch(allDuasProvider.future);
    }
    final repository = ref.watch(duasRepositoryProvider);
    return repository.searchDuas(query);
  },
);
