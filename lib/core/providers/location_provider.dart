import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';

/// A provider for location data that can be used throughout the app
class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  
  /// Current location
  LocationModel? _currentLocation;
  
  /// Last known address
  String? _currentAddress;
  
  /// Current compass heading in degrees
  double? _compassHeading;
  
  /// Whether location tracking is enabled
  bool _isTrackingEnabled = false;
  
  /// Whether location services are available
  bool _isLocationAvailable = false;
  
  /// Whether location permissions are granted
  bool _hasLocationPermission = false;
  
  /// Subscription to location updates
  StreamSubscription<Position>? _locationSubscription;
  
  /// Subscription to compass updates
  StreamSubscription<double>? _compassSubscription;
  
  /// Creates a location provider
  LocationProvider(this._locationService) {
    _init();
  }
  
  /// Current location
  LocationModel? get currentLocation => _currentLocation;
  
  /// Current address
  String? get currentAddress => _currentAddress;
  
  /// Current compass heading in degrees
  double? get compassHeading => _compassHeading;
  
  /// Whether location tracking is enabled
  bool get isTrackingEnabled => _isTrackingEnabled;
  
  /// Whether location services are available
  bool get isLocationAvailable => _isLocationAvailable;
  
  /// Whether location permissions are granted
  bool get hasLocationPermission => _hasLocationPermission;
  
  /// Initialize the provider
  Future<void> _init() async {
    // Check if location services are enabled
    _isLocationAvailable = await _locationService.isLocationServiceEnabled();
    
    // Check if location permissions are granted
    final permission = await _locationService.checkPermission();
    _hasLocationPermission = permission == LocationPermission.always || 
                            permission == LocationPermission.whileInUse;
    
    // Check if tracking is enabled
    _isTrackingEnabled = _locationService.isLocationTrackingEnabled();
    
    // Get last saved address
    _currentAddress = _locationService.getLastSavedAddress();
    
    // Try to get current location
    if (_isLocationAvailable && _hasLocationPermission) {
      try {
        final location = await _locationService.getCurrentLocation();
        _updateLocation(
          LocationModel(
            latitude: location['latitude']!,
            longitude: location['longitude']!,
            timestamp: DateTime.now(),
          ),
        );
        
        // Start tracking if enabled
        if (_isTrackingEnabled) {
          await startTracking();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting current location: $e');
        }
      }
    }
    
    notifyListeners();
  }
  
  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await _locationService.requestPermission();
    _hasLocationPermission = permission == LocationPermission.always || 
                            permission == LocationPermission.whileInUse;
    
    notifyListeners();
    return _hasLocationPermission;
  }
  
  /// Start tracking location and compass
  Future<void> startTracking() async {
    if (!_isLocationAvailable) {
      _isLocationAvailable = await _locationService.isLocationServiceEnabled();
      if (!_isLocationAvailable) {
        throw Exception('Location services are not available');
      }
    }
    
    if (!_hasLocationPermission) {
      final granted = await requestLocationPermission();
      if (!granted) {
        throw Exception('Location permission not granted');
      }
    }
    
    // Start location tracking
    await _locationService.startLocationTracking();
    
    // Subscribe to location updates
    _locationSubscription = _locationService.locationStream.listen(
      (position) {
        _updateLocation(
          LocationModel(
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: DateTime.now(),
            accuracy: position.accuracy,
            altitude: position.altitude,
            speed: position.speed,
            bearing: position.heading,
          ),
        );
      },
      onError: (error) {
        if (kDebugMode) {
          print('Location stream error: $error');
        }
      },
    );
    
    // Start compass tracking
    try {
      await _locationService.startCompassTracking();
      
      // Subscribe to compass updates
      _compassSubscription = _locationService.compassStream.listen(
        (heading) {
          _compassHeading = heading;
          notifyListeners();
        },
        onError: (error) {
          if (kDebugMode) {
            print('Compass stream error: $error');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Compass not available: $e');
      }
    }
    
    _isTrackingEnabled = true;
    notifyListeners();
  }
  
  /// Stop tracking location and compass
  Future<void> stopTracking() async {
    await _locationService.stopLocationTracking();
    await _locationService.stopCompassTracking();
    
    _locationSubscription?.cancel();
    _locationSubscription = null;
    
    _compassSubscription?.cancel();
    _compassSubscription = null;
    
    _isTrackingEnabled = false;
    notifyListeners();
  }
  
  /// Update current location
  Future<void> _updateLocation(LocationModel location) async {
    _currentLocation = location;
    
    // Get address if not available
    if (_currentAddress == null || _currentAddress!.isEmpty) {
      try {
        _currentAddress = await _locationService.getAddressFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        // Update location with address
        _currentLocation = _currentLocation!.copyWith(address: _currentAddress);
      } catch (e) {
        if (kDebugMode) {
          print('Error getting address: $e');
        }
      }
    }
    
    notifyListeners();
  }
  
  /// Refresh current location
  Future<void> refreshLocation() async {
    try {
      final location = await _locationService.getCurrentLocation(useCache: false);
      
      _updateLocation(
        LocationModel(
          latitude: location['latitude']!,
          longitude: location['longitude']!,
          timestamp: DateTime.now(),
        ),
      );
      
      // Also refresh the address
      _currentAddress = await _locationService.getAddressFromCoordinates(
        location['latitude']!,
        location['longitude']!,
      );
      
      // Update location with address
      _currentLocation = _currentLocation!.copyWith(address: _currentAddress);
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing location: $e');
      }
      rethrow;
    }
  }
  
  /// Search for a location by address
  Future<List<LocationModel>> searchLocation(String address) async {
    try {
      final locations = await _locationService.getCoordinatesFromAddress(address);
      
      return locations.map((location) => LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
      )).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching location: $e');
      }
      rethrow;
    }
  }
  
  /// Calculate distance to another location in kilometers
  double? distanceTo(LocationModel destination) {
    if (_currentLocation == null) return null;
    
    return _locationService.calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      destination.latitude,
      destination.longitude,
    );
  }
  
  /// Calculate bearing to another location in degrees
  double? bearingTo(LocationModel destination) {
    if (_currentLocation == null) return null;
    
    return _locationService.calculateBearing(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      destination.latitude,
      destination.longitude,
    );
  }
  
  /// Save a location
  Future<void> saveLocation(LocationModel location) async {
    await _locationService.saveLocation(
      location.latitude,
      location.longitude,
    );
  }
  
  @override
  void dispose() {
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }
}
