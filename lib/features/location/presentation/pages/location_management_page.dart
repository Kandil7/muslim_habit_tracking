import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

/// A page for displaying and managing location information
class LocationManagementPage extends StatefulWidget {
  const LocationManagementPage({super.key});

  @override
  State<LocationManagementPage> createState() => _LocationManagementPageState();
}

class _LocationManagementPageState extends State<LocationManagementPage> {
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Check if location tracking is enabled
    context.read<LocationBloc>().add(const CheckLocationTrackingEvent());
    
    // Check if location services are enabled
    context.read<LocationBloc>().add(const CheckLocationServicesEvent());
    
    // Get current location
    context.read<LocationBloc>().add(const GetCurrentLocationEvent());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshLocation,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const LoadingIndicator(text: 'Loading location...');
          } else if (state is LocationLoaded || state is LocationTracking) {
            final location = state is LocationLoaded
                ? state.location
                : (state as LocationTracking).location;
                
            final address = state is LocationLoaded
                ? state.address
                : (state as LocationTracking).address;
                
            final isTrackingEnabled = state is LocationTracking
                ? state.isTrackingEnabled
                : false;
                
            final compassHeading = state is LocationTracking
                ? state.compassHeading
                : null;
            
            return _buildLocationContent(
              location,
              address,
              isTrackingEnabled,
              compassHeading,
            );
          } else if (state is LocationSearchResults) {
            return _buildSearchResults(state.results, state.query);
          } else {
            return const EmptyState(
              title: 'Location Not Available',
              message: 'Please enable location services and try again',
              icon: Icons.location_off,
            );
          }
        },
      ),
    );
  }
  
  /// Build the main location content
  Widget _buildLocationContent(
    LocationEntity location,
    String? address,
    bool isTrackingEnabled,
    double? compassHeading,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current location card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Current Location',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Latitude',
                    location.latitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Longitude',
                    location.longitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Address',
                    address ?? 'Unknown address',
                  ),
                  if (location.accuracy != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Accuracy',
                      '${location.accuracy!.toStringAsFixed(1)} meters',
                    ),
                  ],
                  if (location.altitude != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Altitude',
                      '${location.altitude!.toStringAsFixed(1)} meters',
                    ),
                  ],
                  if (location.timestamp != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Last Updated',
                      _formatDateTime(location.timestamp!),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: isTrackingEnabled ? 'Stop Tracking' : 'Start Tracking',
                      icon: isTrackingEnabled ? Icons.location_off : Icons.location_on,
                      onPressed: () {
                        if (isTrackingEnabled) {
                          context.read<LocationBloc>().add(const StopLocationTrackingEvent());
                        } else {
                          context.read<LocationBloc>().add(const StartLocationTrackingEvent());
                        }
                      },
                      buttonType: isTrackingEnabled ? ButtonType.secondary : ButtonType.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Compass card
          if (compassHeading != null)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.explore, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Compass',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Compass circle
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                            ),
                          ),
                          // North indicator
                          Positioned(
                            top: 5,
                            child: Text(
                              'N',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // East indicator
                          Positioned(
                            right: 5,
                            child: Text(
                              'E',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // South indicator
                          Positioned(
                            bottom: 5,
                            child: Text(
                              'S',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // West indicator
                          Positioned(
                            left: 5,
                            child: Text(
                              'W',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // Compass needle
                          Transform.rotate(
                            angle: (compassHeading * (math.pi / 180)) * -1,
                            child: Container(
                              width: 4,
                              height: 130,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primary,
                                    AppColors.error,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Center dot
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${compassHeading.toStringAsFixed(1)}°',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      _getDirectionFromHeading(compassHeading),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          
          // Search location
          const SectionHeader(title: 'Search Location'),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by address',
                      hintText: 'Enter an address to search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Search',
                      icon: Icons.search,
                      onPressed: _searchLocation,
                      buttonType: ButtonType.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build search results
  Widget _buildSearchResults(List<LocationEntity> results, String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<LocationBloc>().add(const GetCurrentLocationEvent());
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search Results for "$query"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (results.isEmpty)
          const Expanded(
            child: EmptyState(
              title: 'No Results Found',
              message: 'Try a different search term',
              icon: Icons.search_off,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text(result.address ?? 'Unknown address'),
                  subtitle: Text(
                    '${result.latitude.toStringAsFixed(6)}, ${result.longitude.toStringAsFixed(6)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () => _saveLocation(result),
                    tooltip: 'Save Location',
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
  
  /// Build an info row with a label and value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
  
  /// Format a DateTime to a readable string
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
  
  /// Get direction from compass heading
  String _getDirectionFromHeading(double heading) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    return directions[(heading / 45).round() % 8];
  }
  
  /// Refresh current location
  void _refreshLocation() {
    context.read<LocationBloc>().add(const GetCurrentLocationEvent(useCache: false));
  }
  
  /// Search for a location by address
  void _searchLocation() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    
    context.read<LocationBloc>().add(SearchLocationEvent(query: query));
  }
  
  /// Save a location
  void _saveLocation(LocationEntity location) {
    context.read<LocationBloc>().add(SaveLocationEvent(location: location));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
