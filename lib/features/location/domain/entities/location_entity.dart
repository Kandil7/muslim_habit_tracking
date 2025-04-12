import 'package:equatable/equatable.dart';

/// A class representing a location with coordinates and optional address
class LocationEntity extends Equatable {
  /// Latitude in degrees
  final double latitude;
  
  /// Longitude in degrees
  final double longitude;
  
  /// Optional address of the location
  final String? address;
  
  /// Optional timestamp when the location was recorded
  final DateTime? timestamp;
  
  /// Optional accuracy of the location in meters
  final double? accuracy;
  
  /// Optional altitude in meters
  final double? altitude;
  
  /// Optional speed in meters per second
  final double? speed;
  
  /// Optional bearing in degrees
  final double? bearing;
  
  /// Creates a location entity
  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.address,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.speed,
    this.bearing,
  });
  
  /// Creates a copy of this location entity with the given fields replaced
  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? speed,
    double? bearing,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      bearing: bearing ?? this.bearing,
    );
  }
  
  /// Returns a string representation of the location
  @override
  String toString() {
    return 'LocationEntity(latitude: $latitude, longitude: $longitude, address: $address)';
  }
  
  /// Returns a list of properties used for equality comparison
  @override
  List<Object?> get props => [
    latitude, 
    longitude, 
    address, 
    timestamp, 
    accuracy, 
    altitude, 
    speed, 
    bearing,
  ];
}
