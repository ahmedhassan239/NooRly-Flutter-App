import 'package:flutter_app/features/duas/data/datasources/duas_local_datasource.dart';
import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';
import 'package:flutter_app/features/duas/domain/repositories/duas_repository.dart';

/// Duas Repository Implementation (Data Layer)
///
/// Implements the domain repository contract using local data source
class DuasRepositoryImpl implements DuasRepository {
  DuasRepositoryImpl(this._localDataSource);

  final DuasLocalDataSource _localDataSource;

  @override
  Future<List<DuaEntity>> getAllDuas() async {
    final models = await _localDataSource.getAllDuas();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<DuaCategoryEntity>> getCategories() async {
    final models = await _localDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<DuaEntity>> getDuasByCategory(String categoryId) async {
    final allDuas = await getAllDuas();
    return allDuas.where((dua) => dua.category == categoryId).toList();
  }

  @override
  Future<DuaEntity?> getDuaById(String id) async {
    final allDuas = await getAllDuas();
    try {
      return allDuas.firstWhere((dua) => dua.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DuaEntity>> searchDuas(String query) async {
    final allDuas = await getAllDuas();
    final lowerQuery = query.toLowerCase();

    return allDuas.where((dua) {
      return dua.title.toLowerCase().contains(lowerQuery) ||
          dua.translation.toLowerCase().contains(lowerQuery) ||
          dua.transliteration.toLowerCase().contains(lowerQuery) ||
          dua.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
