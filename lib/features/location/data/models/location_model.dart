import '../../domain/entities/location_entity.dart';

/// A model representing a location with coordinates and optional address
class LocationModel extends LocationEntity {
  /// Creates a location model
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.address,
    super.timestamp,
    super.accuracy,
    super.altitude,
    super.speed,
    super.bearing,
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
  
  /// Creates a location model from a location entity
  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      timestamp: entity.timestamp,
      accuracy: entity.accuracy,
      altitude: entity.altitude,
      speed: entity.speed,
      bearing: entity.bearing,
    );
  }
  
  /// Creates a copy of this location model with the given fields replaced
  @override
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
}
