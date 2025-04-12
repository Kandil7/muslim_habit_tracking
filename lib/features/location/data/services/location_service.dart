import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/location_model.dart';

/// A service for handling location-related functionality
class LocationService {
  final SharedPreferences sharedPreferences;
  
  // Cache for geocoding results
  final Map<String, List<Location>> _geocodingCache = {};
  final Map<String, String> _reverseGeocodingCache = {};
  
  // Keys for SharedPreferences
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';
  static const String _lastAddressKey = 'last_address';
  static const String _locationTrackingEnabledKey = 'location_tracking_enabled';
  
  /// Default constructor
  LocationService({required this.sharedPreferences});
  
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
  
  /// Check current location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }
  
  /// Get the user's current location
  /// If useCache is true, returns saved location if available
  Future<LocationModel> getCurrentLocation({bool useCache = true}) async {
    try {
      // Check if location is saved in preferences and useCache is true
      if (useCache) {
        final savedLatitude = sharedPreferences.getDouble(_latitudeKey);
        final savedLongitude = sharedPreferences.getDouble(_longitudeKey);
        final savedAddress = sharedPreferences.getString(_lastAddressKey);

        if (savedLatitude != null && savedLongitude != null) {
          return LocationModel(
            latitude: savedLatitude,
            longitude: savedLongitude,
            address: savedAddress,
            timestamp: DateTime.now(),
          );
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

      // Create location model
      final locationModel = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        bearing: position.heading,
      );

      // Save location to preferences
      await saveLocation(locationModel);

      return locationModel;
    } catch (e) {
      if (e is LocationException) {
        rethrow;
      }
      throw LocationException(message: e.toString());
    }
  }
  
  /// Save location to preferences
  Future<void> saveLocation(LocationModel location) async {
    await sharedPreferences.setDouble(_latitudeKey, location.latitude);
    await sharedPreferences.setDouble(_longitudeKey, location.longitude);
    
    if (location.address != null) {
      await sharedPreferences.setString(_lastAddressKey, location.address!);
    }
  }
  
  /// Get saved location from preferences
  /// If no location is saved, returns default location or throws exception based on parameter
  Future<LocationModel> getSavedLocation({bool useDefaultIfNotFound = false}) async {
    final latitude = sharedPreferences.getDouble(_latitudeKey);
    final longitude = sharedPreferences.getDouble(_longitudeKey);
    final address = sharedPreferences.getString(_lastAddressKey);

    if (latitude == null || longitude == null) {
      if (useDefaultIfNotFound) {
        // Return default location (Mecca coordinates)
        return getDefaultLocation();
      } else {
        throw LocationException(
            message: 'No saved location found. Please set your location.');
      }
   }

    return LocationModel(
      latitude: latitude,
      longitude: longitude,
      address: address,
      timestamp: DateTime.now(),
    );
  }
  
  /// Get default location (Mecca coordinates)
  LocationModel getDefaultLocation() {
    return const LocationModel(
      latitude: 31.1675877,  // Mecca latitude
      longitude: 30.8892849, // Mecca longitude
      address: 'Kafr el-Sheikh, Egypt',
    );
  }
  
  /// Start tracking location updates
  Stream<LocationModel> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // in meters
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    ).map((position) {
      final locationModel = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        bearing: position.heading,
      );
      
      // Save location to preferences
      saveLocation(locationModel);
      
      return locationModel;
    });
  }
  
  /// Get compass heading stream
  Stream<double>? getCompassStream() {
    if (FlutterCompass.events == null) {
      return null;
    }
    
    return FlutterCompass.events!
      .where((event) => event.heading != null)
      .map((event) => event.heading!);
  }
  
  /// Set location tracking enabled state
  Future<void> setLocationTrackingEnabled(bool enabled) async {
    await sharedPreferences.setBool(_locationTrackingEnabledKey, enabled);
  }
  
  /// Check if location tracking is enabled
  bool isLocationTrackingEnabled() {
    return sharedPreferences.getBool(_locationTrackingEnabledKey) ?? false;
  }
  
  /// Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    final cacheKey = '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';
    
    // Check cache first
    if (_reverseGeocodingCache.containsKey(cacheKey)) {
      return _reverseGeocodingCache[cacheKey]!;
    }
    
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = _formatPlacemark(placemark);
        
        // Cache the result
        _reverseGeocodingCache[cacheKey] = address;
        
        // Save last address
        await sharedPreferences.setString(_lastAddressKey, address);
        
        return address;
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Reverse geocoding error: $e');
      }
      return 'Unknown location';
    }
  }
  
  /// Get coordinates from address (geocoding)
  Future<List<LocationModel>> getCoordinatesFromAddress(String address) async {
    // Check cache first
    if (_geocodingCache.containsKey(address)) {
      return _geocodingCache[address]!.map((location) => LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
        timestamp: DateTime.now(),
      )).toList();
    }
    
    try {
      final locations = await locationFromAddress(address);
      
      // Cache the result
      _geocodingCache[address] = locations;
      
      return locations.map((location) => LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
        timestamp: DateTime.now(),
      )).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Geocoding error: $e');
      }
      throw LocationException(message: 'Could not find location for address: $address');
    }
  }
  
  /// Get the last saved address
  String? getLastSavedAddress() {
    return sharedPreferences.getString(_lastAddressKey);
  }
  
  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convert meters to kilometers
  }
  
  /// Calculate bearing between two coordinates in degrees
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    // Convert to radians
    final startLat = _degreesToRadians(startLatitude);
    final startLng = _degreesToRadians(startLongitude);
    final endLat = _degreesToRadians(endLatitude);
    final endLng = _degreesToRadians(endLongitude);
    
    final dLng = endLng - startLng;
    
    final y = math.sin(dLng) * math.cos(endLat);
    final x = math.cos(startLat) * math.sin(endLat) -
              math.sin(startLat) * math.cos(endLat) * math.cos(dLng);
    
    final bearing = _radiansToDegrees(math.atan2(y, x));
    
    // Normalize to 0-360
    return (bearing + 360) % 360;
  }
  
  /// Format a placemark into a readable address
  String _formatPlacemark(Placemark placemark) {
    final components = <String>[];
    
    if (placemark.name != null && placemark.name!.isNotEmpty) {
      components.add(placemark.name!);
    }
    
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      components.add(placemark.street!);
    }
    
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      components.add(placemark.subLocality!);
    }
    
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      components.add(placemark.locality!);
    }
    
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      components.add(placemark.administrativeArea!);
    }
    
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      components.add(placemark.country!);
    }
    
    return components.join(', ');
  }
  
  /// Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
  
  /// Convert radians to degrees
  double _radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }
}
