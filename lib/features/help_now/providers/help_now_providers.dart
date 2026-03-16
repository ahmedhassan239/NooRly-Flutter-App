/// Help Now providers - categories and single item (locale-aware via API).
library;

import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/features/help_now/data/help_now_api.dart';
import 'package:flutter_app/features/help_now/data/help_now_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Help Now categories with nested items. Refetches when locale changes.
final helpNowCategoriesProvider =
    FutureProvider.autoDispose<List<HelpCategoryModel>>((ref) async {
  ref.watch(localeControllerProvider);
  return fetchHelpNowCategories(ref);
});

/// Single help item by slug (for detail screen).
final helpNowItemProvider =
    FutureProvider.autoDispose.family<HelpItemModel?, String>((ref, slug) async {
  ref.watch(localeControllerProvider);
  return fetchHelpNowItem(ref, slug);
});
