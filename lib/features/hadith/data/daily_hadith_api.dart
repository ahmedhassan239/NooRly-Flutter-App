/// Daily hadith for home inspiration (GET /hadith/daily).
library;

import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DTO for daily hadith from GET /hadith/daily.
class DailyHadithDto {
  const DailyHadithDto({
    required this.id,
    required this.textAr,
    this.textEn,
    this.transliteration,
    this.collectionName,
    this.reference,
    this.hadithNumber,
  });

  final int id;
  final String textAr;
  final String? textEn;
  final String? transliteration;
  final String? collectionName;
  final String? reference;
  final dynamic hadithNumber;

  factory DailyHadithDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final rawId = data['id'] ?? data['item_id'];
    final id = rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '0') ?? 0;
    return DailyHadithDto(
      id: id,
      textAr: (data['text_ar'] ?? data['arabic'] ?? data['text'] ?? '') as String,
      textEn: data['text_en'] as String? ?? data['translation'] as String?,
      transliteration: data['transliteration'] as String?,
      collectionName: data['collection_name'] as String? ?? data['collection'] as String?,
      reference: data['reference'] as String?,
      hadithNumber: data['hadith_number'],
    );
  }
}

/// Fetches daily hadith (GET /hadith/daily). Returns null on error or 404.
Future<DailyHadithDto?> fetchDailyHadith(Ref ref) async {
  try {
    final client = ref.read(apiClientProvider);
    final response = await client.get<Map<String, dynamic>>(
      HadithEndpoints.daily,
    );
    if (!response.status || response.data == null) return null;
    final data = response.data!;
    if (data.isEmpty) return null;
    return DailyHadithDto.fromJson(data);
  } catch (_) {
    return null;
  }
}
