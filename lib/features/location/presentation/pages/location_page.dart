import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/location_model.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/providers/location_provider.dart';
import '../../../../core/theme/app_theme.dart';

/// A page for displaying and managing location information
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;
  
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
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          final currentLocation = locationProvider.currentLocation;
          final currentAddress = locationProvider.currentAddress;
          final isTrackingEnabled = locationProvider.isTrackingEnabled;
          final compassHeading = locationProvider.compassHeading;
          
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
                        if (currentLocation != null) ...[
                          _buildInfoRow(
                            'Latitude',
                            currentLocation.latitude.toStringAsFixed(6),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Longitude',
                            currentLocation.longitude.toStringAsFixed(6),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Address',
                            currentAddress ?? 'Unknown address',
                          ),
                          if (currentLocation.accuracy != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Accuracy',
                              '${currentLocation.accuracy!.toStringAsFixed(1)} meters',
                            ),
                          ],
                          if (currentLocation.altitude != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Altitude',
                              '${currentLocation.altitude!.toStringAsFixed(1)} meters',
                            ),
                          ],
                          if (currentLocation.timestamp != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Last Updated',
                              _formatDateTime(currentLocation.timestamp!),
                            ),
                          ],
                        ] else ...[
                          const Center(
                            child: Text('Location not available'),
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
                                locationProvider.stopTracking();
                              } else {
                                locationProvider.startTracking();
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
                        if (_isSearching)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          )
                        else if (_searchResults.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Search Results',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
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
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
  Future<void> _refreshLocation() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.refreshLocation();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location refreshed successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh location: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  /// Search for a location by address
  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    
    setState(() {
      _isSearching = true;
      _searchResults = [];
    });
    
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      final results = await locationProvider.searchLocation(query);
      
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to search location: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  /// Save a location
  Future<void> _saveLocation(LocationModel location) async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.saveLocation(location);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save location: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
