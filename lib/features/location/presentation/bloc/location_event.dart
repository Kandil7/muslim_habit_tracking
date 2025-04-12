import 'package:equatable/equatable.dart';

import '../../domain/entities/location_entity.dart';

/// Base class for all location events
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to get the current location
class GetCurrentLocationEvent extends LocationEvent {
  final bool useCache;
  
  const GetCurrentLocationEvent({this.useCache = true});
  
  @override
  List<Object?> get props => [useCache];
}

/// Event to get the saved location
class GetSavedLocationEvent extends LocationEvent {
  final bool useDefaultIfNotFound;
  
  const GetSavedLocationEvent({this.useDefaultIfNotFound = false});
  
  @override
  List<Object?> get props => [useDefaultIfNotFound];
}

/// Event to save a location
class SaveLocationEvent extends LocationEvent {
  final LocationEntity location;
  
  const SaveLocationEvent({required this.location});
  
  @override
  List<Object?> get props => [location];
}

/// Event to get address from coordinates
class GetAddressFromCoordinatesEvent extends LocationEvent {
  final double latitude;
  final double longitude;
  
  const GetAddressFromCoordinatesEvent({
    required this.latitude,
    required this.longitude,
  });
  
  @override
  List<Object?> get props => [latitude, longitude];
}

/// Event to search for a location by address
class SearchLocationEvent extends LocationEvent {
  final String query;
  
  const SearchLocationEvent({required this.query});
  
  @override
  List<Object?> get props => [query];
}

/// Event to start location tracking
class StartLocationTrackingEvent extends LocationEvent {
  const StartLocationTrackingEvent();
}

/// Event to stop location tracking
class StopLocationTrackingEvent extends LocationEvent {
  const StopLocationTrackingEvent();
}

/// Event to check if location tracking is enabled
class CheckLocationTrackingEvent extends LocationEvent {
  const CheckLocationTrackingEvent();
}

/// Event to check if location services are enabled
class CheckLocationServicesEvent extends LocationEvent {
  const CheckLocationServicesEvent();
}

/// Event to request location permission
class RequestLocationPermissionEvent extends LocationEvent {
  const RequestLocationPermissionEvent();
}

/// Event to update location from stream
class UpdateLocationEvent extends LocationEvent {
  final LocationEntity location;
  
  const UpdateLocationEvent({required this.location});
  
  @override
  List<Object?> get props => [location];
}

/// Event to update compass heading from stream
class UpdateCompassHeadingEvent extends LocationEvent {
  final double heading;
  
  const UpdateCompassHeadingEvent({required this.heading});
  
  @override
  List<Object?> get props => [heading];
}

/// Event to handle location error
class LocationErrorEvent extends LocationEvent {
  final String message;
  
  const LocationErrorEvent({required this.message});
  
  @override
  List<Object?> get props => [message];
}
