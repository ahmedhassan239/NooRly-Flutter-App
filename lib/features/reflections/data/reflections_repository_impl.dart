import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/reflections/domain/reflection_entity.dart';
import 'package:flutter_app/features/reflections/data/reflections_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches reflections from GET /reflections.
class ReflectionsRepositoryImpl implements ReflectionsRepository {
  ReflectionsRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<ReflectionEntity>> getReflections() async {
    final response = await _apiClient.get<List<ReflectionEntity>>(
      ReflectionEndpoints.list,
      fromJson: (data) {
        if (data == null) return <ReflectionEntity>[];
        final list = data is List ? data : (data is Iterable ? data.toList() : <dynamic>[]);
        return list
            .map((e) => e is Map<String, dynamic> ? ReflectionEntity.fromJson(e) : null)
            .whereType<ReflectionEntity>()
            .toList();
      },
    );
    if (!response.status || response.data == null) return [];
    return response.data!;
  }
}

final reflectionsRepositoryProvider = Provider<ReflectionsRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ReflectionsRepositoryImpl(client);
});
