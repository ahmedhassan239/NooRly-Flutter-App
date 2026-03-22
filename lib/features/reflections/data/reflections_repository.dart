import 'package:flutter_app/features/reflections/domain/reflection_entity.dart';

/// Fetches user's saved reflections from the API.
abstract class ReflectionsRepository {
  Future<List<ReflectionEntity>> getReflections();
}
