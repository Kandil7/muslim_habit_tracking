import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

/// BLoC for managing location state
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;
  
  // Stream subscriptions
  StreamSubscription? _locationSubscription;
  StreamSubscription? _compassSubscription;
  
  /// Creates a location bloc
  LocationBloc({required this.locationRepository}) : super(const LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<GetSavedLocationEvent>(_onGetSavedLocation);
    on<SaveLocationEvent>(_onSaveLocation);
    on<GetAddressFromCoordinatesEvent>(_onGetAddressFromCoordinates);
    on<SearchLocationEvent>(_onSearchLocation);
    on<StartLocationTrackingEvent>(_onStartLocationTracking);
    on<StopLocationTrackingEvent>(_onStopLocationTracking);
    on<CheckLocationTrackingEvent>(_onCheckLocationTracking);
    on<CheckLocationServicesEvent>(_onCheckLocationServices);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<UpdateCompassHeadingEvent>(_onUpdateCompassHeading);
    on<LocationErrorEvent>(_onLocationError);
  }
  
  /// Handle getting the current location
  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    
    final result = await locationRepository.getCurrentLocation(useCache: event.useCache);
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (location) async {
        // Get address if available
        final addressResult = await locationRepository.getAddressFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        final address = addressResult.fold(
          (failure) => null,
          (address) => address,
        );
        
        emit(LocationLoaded(location: location, address: address));
      },
    );
  }
  
  /// Handle getting the saved location
  Future<void> _onGetSavedLocation(
    GetSavedLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    
    final result = await locationRepository.getSavedLocation(
      useDefaultIfNotFound: event.useDefaultIfNotFound,
    );
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (location) => emit(LocationLoaded(location: location, address: location.address)),
    );
  }
  
  /// Handle saving a location
  Future<void> _onSaveLocation(
    SaveLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await locationRepository.saveLocation(event.location);
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (_) => emit(LocationLoaded(location: event.location, address: event.location.address)),
    );
  }
  
  /// Handle getting address from coordinates
  Future<void> _onGetAddressFromCoordinates(
    GetAddressFromCoordinatesEvent event,
    Emitter<LocationState> emit,
  ) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;
      
      final result = await locationRepository.getAddressFromCoordinates(
        event.latitude,
        event.longitude,
      );
      
      result.fold(
        (failure) => emit(LocationError(message: failure.message)),
        (address) => emit(LocationLoaded(location: currentState.location, address: address)),
      );
    } else if (state is LocationTracking) {
      final currentState = state as LocationTracking;
      
      final result = await locationRepository.getAddressFromCoordinates(
        event.latitude,
        event.longitude,
      );
      
      result.fold(
        (failure) => emit(LocationError(message: failure.message)),
        (address) => emit(currentState.copyWith(address: address)),
      );
    }
  }
  
  /// Handle searching for a location by address
  Future<void> _onSearchLocation(
    SearchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    
    final result = await locationRepository.getCoordinatesFromAddress(event.query);
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (locations) => emit(LocationSearchResults(results: locations, query: event.query)),
    );
  }
  
  /// Handle starting location tracking
  Future<void> _onStartLocationTracking(
    StartLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    // Get current location first
    final locationResult = await locationRepository.getCurrentLocation();
    
    final location = locationResult.fold(
      (failure) {
        emit(LocationError(message: failure.message));
        return null;
      },
      (location) => location,
    );
    
    if (location == null) return;
    
    // Get address
    final addressResult = await locationRepository.getAddressFromCoordinates(
      location.latitude,
      location.longitude,
    );
    
    final address = addressResult.fold(
      (failure) => null,
      (address) => address,
    );
    
    // Start tracking
    final result = await locationRepository.startLocationTracking();
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (_) {
        // Subscribe to location updates
        _locationSubscription?.cancel();
        _locationSubscription = locationRepository.getLocationUpdates().listen(
          (result) {
            result.fold(
              (failure) => add(LocationErrorEvent(message: failure.message)),
              (location) => add(UpdateLocationEvent(location: location)),
            );
          },
        );
        
        // Subscribe to compass updates
        _compassSubscription?.cancel();
        _compassSubscription = locationRepository.getCompassUpdates().listen(
          (result) {
            result.fold(
              (failure) => add(LocationErrorEvent(message: failure.message)),
              (heading) => add(UpdateCompassHeadingEvent(heading: heading)),
            );
          },
        );
        
        emit(LocationTracking(
          location: location,
          address: address,
          isTrackingEnabled: true,
        ));
      },
    );
  }
  
  /// Handle stopping location tracking
  Future<void> _onStopLocationTracking(
    StopLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await locationRepository.stopLocationTracking();
    
    // Cancel subscriptions
    _locationSubscription?.cancel();
    _locationSubscription = null;
    
    _compassSubscription?.cancel();
    _compassSubscription = null;
    
    if (state is LocationTracking) {
      final currentState = state as LocationTracking;
      
      result.fold(
        (failure) => emit(LocationError(message: failure.message)),
        (_) => emit(LocationLoaded(
          location: currentState.location,
          address: currentState.address,
        )),
      );
    }
  }
  
  /// Handle checking if location tracking is enabled
  Future<void> _onCheckLocationTracking(
    CheckLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await locationRepository.isLocationTrackingEnabled();
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (isEnabled) {
        if (isEnabled) {
          add(const StartLocationTrackingEvent());
        }
      },
    );
  }
  
  /// Handle checking if location services are enabled
  Future<void> _onCheckLocationServices(
    CheckLocationServicesEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await locationRepository.isLocationServiceEnabled();
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (isEnabled) {
        if (!isEnabled) {
          emit(const LocationError(message: 'Location services are disabled'));
        }
      },
    );
  }
  
  /// Handle requesting location permission
  Future<void> _onRequestLocationPermission(
    RequestLocationPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await locationRepository.requestLocationPermission();
    
    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (isGranted) {
        if (!isGranted) {
          emit(const LocationError(message: 'Location permission denied'));
        }
      },
    );
  }
  
  /// Handle updating location from stream
  void _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationTracking) {
      final currentState = state as LocationTracking;
      emit(currentState.copyWith(location: event.location));
      
      // Get address for the new location
      add(GetAddressFromCoordinatesEvent(
        latitude: event.location.latitude,
        longitude: event.location.longitude,
      ));
    }
  }
  
  /// Handle updating compass heading from stream
  void _onUpdateCompassHeading(
    UpdateCompassHeadingEvent event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationTracking) {
      final currentState = state as LocationTracking;
      emit(currentState.copyWith(compassHeading: event.heading));
    }
  }
  
  /// Handle location error
  void _onLocationError(
    LocationErrorEvent event,
    Emitter<LocationState> emit,
  ) {
    emit(LocationError(message: event.message));
  }
  
  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    return super.close();
  }
}
