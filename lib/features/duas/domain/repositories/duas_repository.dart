import 'package:flutter_app/features/duas/domain/entities/dua_entity.dart';

/// Duas Repository Interface (Domain Layer)
///
/// Abstract contract for data access
abstract class DuasRepository {
  /// Get all duas
  Future<List<DuaEntity>> getAllDuas();

  /// Get all categories
  Future<List<DuaCategoryEntity>> getCategories();

  /// Get duas by category
  Future<List<DuaEntity>> getDuasByCategory(String categoryId);

  /// Get single dua by ID
  Future<DuaEntity?> getDuaById(String id);

  /// Search duas
  Future<List<DuaEntity>> searchDuas(String query);
}
