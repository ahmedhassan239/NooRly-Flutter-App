/// Ramadan Guide providers - list and single item (locale-aware via API).
library;

import 'package:flutter_app/app/locale_provider.dart';
import 'package:flutter_app/features/ramadan_guide/data/ramadan_guide_api.dart';
import 'package:flutter_app/features/ramadan_guide/data/ramadan_guide_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ramadan guide list. Refetches when locale changes (Accept-Language sent by API client).
final ramadanGuideListProvider =
    FutureProvider.autoDispose<List<RamadanGuideItemModel>>((ref) async {
      ref.watch(localeControllerProvider);
      return fetchRamadanGuideList(ref);
    });

/// Single Ramadan guide item by slug.
final ramadanGuideItemProvider = FutureProvider.autoDispose
    .family<RamadanGuideItemModel?, String>((ref, slug) async {
      ref.watch(localeControllerProvider);
      return fetchRamadanGuideItem(ref, slug);
    });
