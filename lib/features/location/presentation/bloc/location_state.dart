import 'package:equatable/equatable.dart';

import '../../domain/entities/location_entity.dart';

/// Base class for all location states
abstract class LocationState extends Equatable {
  const LocationState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class LocationInitial extends LocationState {
  const LocationInitial();
}

/// Loading state
class LocationLoading extends LocationState {
  const LocationLoading();
}

/// Location loaded state
class LocationLoaded extends LocationState {
  final LocationEntity location;
  final String? address;
  
  const LocationLoaded({
    required this.location,
    this.address,
  });
  
  @override
  List<Object?> get props => [location, address];
}

/// Location tracking state
class LocationTracking extends LocationState {
  final LocationEntity location;
  final String? address;
  final bool isTrackingEnabled;
  final double? compassHeading;
  
  const LocationTracking({
    required this.location,
    this.address,
    required this.isTrackingEnabled,
    this.compassHeading,
  });
  
  /// Create a copy with updated values
  LocationTracking copyWith({
    LocationEntity? location,
    String? address,
    bool? isTrackingEnabled,
    double? compassHeading,
  }) {
    return LocationTracking(
      location: location ?? this.location,
      address: address ?? this.address,
      isTrackingEnabled: isTrackingEnabled ?? this.isTrackingEnabled,
      compassHeading: compassHeading ?? this.compassHeading,
    );
  }
  
  @override
  List<Object?> get props => [location, address, isTrackingEnabled, compassHeading];
}

/// Search results state
class LocationSearchResults extends LocationState {
  final List<LocationEntity> results;
  final String query;
  
  const LocationSearchResults({
    required this.results,
    required this.query,
  });
  
  @override
  List<Object?> get props => [results, query];
}

/// Error state
class LocationError extends LocationState {
  final String message;
  
  const LocationError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
