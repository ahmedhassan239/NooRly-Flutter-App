import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/reflections/data/reflections_repository_impl.dart';
import 'package:flutter_app/features/reflections/domain/reflection_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// List of saved reflections (from GET /reflections). Refetch when auth or locale changes.
final reflectionsListProvider = FutureProvider<List<ReflectionEntity>>((ref) async {
  final auth = ref.watch(authProvider);
  ref.watch(localeControllerProvider).languageCode; // refetch when locale changes (lesson titles)
  if (!auth.isAuthenticated) return [];
  final repo = ref.watch(reflectionsRepositoryProvider);
  return repo.getReflections();
});
