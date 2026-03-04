/// Persists user location/address so we don't request permission on every app open.
/// Cache valid for [locationCacheTTL] (default 7 days).
library;

import 'package:shared_preferences/shared_preferences.dart';

const String _keyLat = 'prayer_location_lat';
const String _keyLng = 'prayer_location_lng';
const String _keyAddress = 'prayer_location_address';
const String _keySavedAt = 'prayer_location_saved_at';
const String _keyMethod = 'prayer_calculation_method';
const String _keyPermissionRequested = 'location_permission_requested';

/// Default TTL for cached location: 7 days.
const Duration locationCacheTTL = Duration(days: 7);

/// Cached location entry.
class CachedLocation {
  const CachedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.savedAt,
  });

  final double latitude;
  final double longitude;
  final String address;
  final DateTime savedAt;

  bool isStale(Duration ttl) => DateTime.now().difference(savedAt) > ttl;
}

/// Service to read/write last known location and address (SharedPreferences).
class LocationService {
  LocationService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Returns cached location if present and not stale. Otherwise null.
  Future<CachedLocation?> getCachedLocation({Duration ttl = locationCacheTTL}) async {
    final prefs = await _getPrefs();
    final lat = prefs.getDouble(_keyLat);
    final lng = prefs.getDouble(_keyLng);
    final address = prefs.getString(_keyAddress);
    final savedAtMillis = prefs.getInt(_keySavedAt);
    if (lat == null || lng == null || address == null || savedAtMillis == null) return null;
    final savedAt = DateTime.fromMillisecondsSinceEpoch(savedAtMillis);
    final cached = CachedLocation(latitude: lat, longitude: lng, address: address, savedAt: savedAt);
    if (cached.isStale(ttl)) return null;
    return cached;
  }

  /// Save location and address (call after successful GPS + geocode).
  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_keyLat, latitude);
    await prefs.setDouble(_keyLng, longitude);
    await prefs.setString(_keyAddress, address);
    await prefs.setInt(_keySavedAt, DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear cached location (e.g. on logout or user action).
  Future<void> clearLocation() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyLat);
    await prefs.remove(_keyLng);
    await prefs.remove(_keyAddress);
    await prefs.remove(_keySavedAt);
  }

  /// Persist calculation method (optional). Default 5 (Egypt).
  Future<void> setCalculationMethod(int method) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyMethod, method);
  }

  /// Get saved calculation method, or null if not set.
  Future<int?> getCalculationMethod() async {
    final prefs = await _getPrefs();
    final v = prefs.getInt(_keyMethod);
    return v;
  }

  /// Whether we have already requested location permission (avoid asking repeatedly).
  Future<bool> getLocationPermissionRequested() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyPermissionRequested) ?? false;
  }

  Future<void> setLocationPermissionRequested(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyPermissionRequested, value);
  }
}
