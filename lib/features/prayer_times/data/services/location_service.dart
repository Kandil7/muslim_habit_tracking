import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

/// Service for getting the user's location
class LocationService {
  final SharedPreferences sharedPreferences;

  LocationService({required this.sharedPreferences});

  /// Get the user's current location
  /// If useCache is true, returns saved location if available
  Future<Map<String, double>> getCurrentLocation({bool useCache = true}) async {
    try {
      // Check if location is saved in preferences and useCache is true
      if (useCache) {
        final savedLatitude = sharedPreferences.getDouble('latitude');
        final savedLongitude = sharedPreferences.getDouble('longitude');

        if (savedLatitude != null && savedLongitude != null) {
          return {
            'latitude': savedLatitude,
            'longitude': savedLongitude,
          };
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
            message: 'Location services are disabled. Please enable them.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
              message: 'Location permissions are denied. Please enable them.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
            message:
                'Location permissions are permanently denied. Please enable them in settings.');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Save location to preferences
      await sharedPreferences.setDouble('latitude', position.latitude);
      await sharedPreferences.setDouble('longitude', position.longitude);

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      if (e is LocationException) {
        rethrow;
      }
      throw LocationException(message: e.toString());
    }
  }

  /// Save location to preferences
  Future<void> saveLocation(double latitude, double longitude) async {
    await sharedPreferences.setDouble('latitude', latitude);
    await sharedPreferences.setDouble('longitude', longitude);
  }

  /// Get saved location from preferences
  /// If no location is saved, returns default location or throws exception based on parameter
  Future<Map<String, double>> getSavedLocation({bool useDefaultIfNotFound = false}) async {
    final latitude = sharedPreferences.getDouble('latitude');
    final longitude = sharedPreferences.getDouble('longitude');

    if (latitude == null || longitude == null) {
      if (useDefaultIfNotFound) {
        // Return default location (Mecca coordinates)
        return getDefaultLocation();
      } else {
        throw LocationException(
            message: 'No saved location found. Please set your location.');
      }
    }

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Get default location (Mecca coordinates)
  Map<String, double> getDefaultLocation() {
    return {
      'latitude': 21.4225,  // Mecca latitude
      'longitude': 39.8262, // Mecca longitude
    };
  }
}
