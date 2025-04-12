import 'package:equatable/equatable.dart';

/// A model representing a location with coordinates and optional address
class LocationModel extends Equatable {
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
  
  /// Creates a location model
  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.speed,
    this.bearing,
  });
  
  /// Creates a location model from a map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String?,
      timestamp: map['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int) 
          : null,
      accuracy: map['accuracy'] as double?,
      altitude: map['altitude'] as double?,
      speed: map['speed'] as double?,
      bearing: map['bearing'] as double?,
    );
  }
  
  /// Converts the location model to a map
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'bearing': bearing,
    };
  }
  
  /// Creates a copy of this location model with the given fields replaced
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? speed,
    double? bearing,
  }) {
    return LocationModel(
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
    return 'LocationModel(latitude: $latitude, longitude: $longitude, address: $address)';
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
