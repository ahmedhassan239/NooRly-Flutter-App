/// AlAdhan Prayer Times API client.
/// Base: https://api.aladhan.com/v1
/// Uses standalone Dio (different base URL from app backend).
library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String _baseUrl = 'https://api.aladhan.com/v1';

/// Default calculation method: 5 = Egyptian General Authority of Survey (Cairo/Egypt).
/// Use this for Egypt and areas that follow Egyptian timings (matches Google ~Cairo).
/// See https://api.aladhan.com/v1/methods — EGYPT id=5.
const int defaultMethod = 5;

/// Default school: 0 = Shafi (Hanbali, Maliki, etc.); 1 = Hanafi. Affects Asr only.
const int defaultSchool = 0;

bool _debugPrayerApi = kDebugMode;
void _log(String msg) {
  if (_debugPrayerApi) debugPrint('[PrayerApi] $msg');
}

String _truncate(dynamic body, [int maxLen = 800]) {
  final s = body is String ? body : body.toString();
  return s.length <= maxLen ? s : '${s.substring(0, maxLen)}...';
}

/// Raw response from GET /timingsByAddress/{date}.
/// Response shape: { data: { timings: { Fajr: "05:12 (PST)", ... }, date: {...}, meta: {... } } }
class AlAdhanTimingsResponse {
  const AlAdhanTimingsResponse({
    required this.timings,
    this.date,
    this.meta,
  });
  final Map<String, String> timings;
  final Map<String, dynamic>? date;
  final Map<String, dynamic>? meta;

  static AlAdhanTimingsResponse? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final data = json['data'];
    if (data is! Map<String, dynamic>) return null;
    final timingsRaw = data['timings'];
    if (timingsRaw is! Map) return null;
    final timings = <String, String>{};
    for (final e in timingsRaw.entries) {
      if (e.value is String) timings[e.key.toString()] = e.value as String;
    }
    return AlAdhanTimingsResponse(
      timings: timings,
      date: data['date'] is Map<String, dynamic> ? data['date'] as Map<String, dynamic> : null,
      meta: data['meta'] is Map<String, dynamic> ? data['meta'] as Map<String, dynamic> : null,
    );
  }
}

/// Raw response from GET /nextPrayerByAddress/{date}.
/// Response may include next prayer name and time.
class AlAdhanNextPrayerResponse {
  const AlAdhanNextPrayerResponse({
    this.data,
  });
  final Map<String, dynamic>? data;

  static AlAdhanNextPrayerResponse? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AlAdhanNextPrayerResponse(
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
    );
  }
}

/// Dio client for AlAdhan API (no auth).
Dio _createDio() {
  return Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ),
  );
}

/// GET /timingsByAddress/{date}?address=...&method=5&school=0
Future<AlAdhanTimingsResponse?> getTimingsByAddress({
  required String dateDDMMYYYY,
  required String address,
  int method = defaultMethod,
  int school = defaultSchool,
  Dio? dio,
}) async {
  final client = dio ?? _createDio();
  final path = '/timingsByAddress/$dateDDMMYYYY';
  final query = {
    'address': address,
    'method': method,
    'school': school,
  };
  final uri = Uri.parse(_baseUrl).replace(path: path, queryParameters: query.map((k, v) => MapEntry(k, v.toString())));
  _log('GET $uri');

  try {
    final res = await client.get<dynamic>(path, queryParameters: query);
    _log('GET $path status=${res.statusCode} body=${_truncate(res.data)}');

    if (res.data is! Map<String, dynamic>) return null;
    final parsed = AlAdhanTimingsResponse.fromJson(res.data as Map<String, dynamic>);
    if (parsed != null) {
      final fajr = parsed.timings['Fajr'];
      _log('address=$address method=$method school=$school timezone=${parsed.meta?['timezone']} Fajr(raw)=$fajr');
      if (parsed.meta != null) _log('meta: timezone=${parsed.meta!['timezone']} method=${parsed.meta!['method']}');
    }
    return parsed;
  } on DioException catch (e) {
    _log('GET $path FAILED status=${e.response?.statusCode} body=${_truncate(e.response?.data)}');
    rethrow;
  }
}

/// GET /nextPrayerByAddress (optional; next prayer is computed locally from timings).
Future<AlAdhanNextPrayerResponse?> getNextPrayerByAddress({
  required String dateDDMMYYYY,
  required String address,
  int method = defaultMethod,
  int school = defaultSchool,
  Dio? dio,
}) async {
  final client = dio ?? _createDio();
  final path = '/nextPrayerByAddress/$dateDDMMYYYY';
  final query = {'address': address, 'method': method, 'school': school};
  _log('GET nextPrayer $path query=$query');

  try {
    final res = await client.get<dynamic>(path, queryParameters: query);
    _log('GET $path status=${res.statusCode}');

    if (res.data is! Map<String, dynamic>) return null;
    return AlAdhanNextPrayerResponse.fromJson(res.data as Map<String, dynamic>);
  } on DioException catch (e) {
    _log('GET $path FAILED status=${e.response?.statusCode}');
    rethrow;
  }
}
