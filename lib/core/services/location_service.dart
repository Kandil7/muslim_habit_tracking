import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';

/// A comprehensive service for handling location-related functionality
class LocationService {
  final SharedPreferences sharedPreferences;
  
  // Stream controllers
  final _locationStreamController = StreamController<Position>.broadcast();
  final _compassStreamController = StreamController<double>.broadcast();
  
  // Subscription for location updates
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  
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
  
  /// Stream of location updates
  Stream<Position> get locationStream => _locationStreamController.stream;
  
  /// Stream of compass heading updates (in degrees)
  Stream<double> get compassStream => _compassStreamController.stream;
  
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
  Future<Map<String, double>> getCurrentLocation({bool useCache = true}) async {
    try {
      // Check if location is saved in preferences and useCache is true
      if (useCache) {
        final savedLatitude = sharedPreferences.getDouble(_latitudeKey);
        final savedLongitude = sharedPreferences.getDouble(_longitudeKey);

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
      await saveLocation(position.latitude, position.longitude);

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
    await sharedPreferences.setDouble(_latitudeKey, latitude);
    await sharedPreferences.setDouble(_longitudeKey, longitude);
  }
  
  /// Get saved location from preferences
  /// If no location is saved, returns default location or throws exception based on parameter
  Future<Map<String, double>> getSavedLocation({bool useDefaultIfNotFound = false}) async {
    final latitude = sharedPreferences.getDouble(_latitudeKey);
    final longitude = sharedPreferences.getDouble(_longitudeKey);

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
  
  /// Start tracking location updates
  Future<void> startLocationTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // in meters
  }) async {
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
    
    // Stop any existing subscription
    await stopLocationTracking();
    
    // Start new subscription
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    ).listen(
      (Position position) {
        // Add to stream
        _locationStreamController.add(position);
        
        // Save to preferences
        saveLocation(position.latitude, position.longitude);
      },
      onError: (error) {
        if (kDebugMode) {
          print('Location tracking error: $error');
        }
      },
    );
    
    // Save tracking state
    await sharedPreferences.setBool(_locationTrackingEnabledKey, true);
  }
  
  /// Stop tracking location updates
  Future<void> stopLocationTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    
    // Save tracking state
    await sharedPreferences.setBool(_locationTrackingEnabledKey, false);
  }
  
  /// Check if location tracking is enabled
  bool isLocationTrackingEnabled() {
    return sharedPreferences.getBool(_locationTrackingEnabledKey) ?? false;
  }
  
  /// Start compass tracking
  Future<void> startCompassTracking() async {
    if (FlutterCompass.events == null) {
      throw LocationException(message: 'Compass is not available on this device');
    }
    
    // Stop any existing subscription
    await stopCompassTracking();
    
    // Start new subscription
    _compassSubscription = FlutterCompass.events!.listen(
      (CompassEvent event) {
        if (event.heading != null) {
          _compassStreamController.add(event.heading!);
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Compass tracking error: $error');
        }
      },
    );
  }
  
  /// Stop compass tracking
  Future<void> stopCompassTracking() async {
    await _compassSubscription?.cancel();
    _compassSubscription = null;
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
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    // Check cache first
    if (_geocodingCache.containsKey(address)) {
      return _geocodingCache[address]!;
    }
    
    try {
      final locations = await locationFromAddress(address);
      
      // Cache the result
      _geocodingCache[address] = locations;
      
      return locations;
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
  
  /// Dispose of resources
  void dispose() {
    _positionStreamSubscription?.cancel();
    _compassSubscription?.cancel();
    _locationStreamController.close();
    _compassStreamController.close();
  }
}
