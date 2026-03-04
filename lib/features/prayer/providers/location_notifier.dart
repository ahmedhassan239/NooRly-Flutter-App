/// Notifier for prayer location: cache-first, request permission only when user taps "Use current location".
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_app/features/prayer/data/location_service.dart';

/// Result of location resolution: lat, lng, and human-readable address.
class LocationResult {
  const LocationResult({required this.lat, required this.lng, required this.address});
  final double lat;
  final double lng;
  final String address;
}

/// Result of requesting current location (permission + GPS + geocode).
enum LocationRequestResult {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  error,
}

/// Loads cache on start; requests location only when [requestLocation] is called.
class LocationNotifier extends StateNotifier<AsyncValue<LocationResult?>> {
  LocationNotifier(this._locationService) : super(const AsyncValue.loading()) {
    _loadFromCache();
  }

  final LocationService _locationService;

  Future<void> _loadFromCache() async {
    try {
      final cached = await _locationService.getCachedLocation();
      if (cached != null) {
        state = AsyncValue.data(LocationResult(
          lat: cached.latitude,
          lng: cached.longitude,
          address: cached.address,
        ));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Call when user taps "Use current location" or "Refresh location". Requests permission, then fetches position and geocodes.
  /// Returns [LocationRequestResult] so UI can show "Open settings" when deniedForever.
  Future<LocationRequestResult> requestLocation() async {
    state = const AsyncValue.loading();
    try {
      await _locationService.setLocationPermissionRequested(true);
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = const AsyncValue.data(null);
        return LocationRequestResult.serviceDisabled;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        state = const AsyncValue.data(null);
        return LocationRequestResult.permissionDeniedForever;
      }
      if (permission == LocationPermission.denied) {
        state = const AsyncValue.data(null);
        return LocationRequestResult.permissionDenied;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      var placemarks = <Placemark>[];
      try {
        placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      } catch (_) {}
      String address;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ].whereType<String>().toList();
        address = parts.isEmpty ? '${position.latitude}, ${position.longitude}' : parts.join(', ');
      } else {
        address = '${position.latitude}, ${position.longitude}';
      }
      await _locationService.saveLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
      state = AsyncValue.data(LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      ));
      return LocationRequestResult.success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return LocationRequestResult.error;
    }
  }

  /// Reload from cache (e.g. after returning from settings).
  Future<void> loadFromCacheIfNeeded() async {
    if (state.isLoading) return;
    await _loadFromCache();
  }
}
