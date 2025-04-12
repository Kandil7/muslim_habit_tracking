import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../data/services/location_service.dart';
import '../../data/services/prayer_calculation_service.dart';
import '../../domain/entities/prayer_time.dart';
import '../bloc/prayer_time_bloc.dart';
import '../bloc/prayer_time_event.dart';
import '../bloc/prayer_time_state.dart';

/// Page for prayer time settings
class PrayerSettingsPage extends StatefulWidget {
  const PrayerSettingsPage({super.key});

  @override
  State<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends State<PrayerSettingsPage> {
  String _selectedCalculationMethod = AppConstants.defaultCalculationMethod;
  Map<String, String> _calculationMethods = {};
  bool _isLoading = true;
  double _latitude = 0.0;
  double _longitude = 0.0;
  int _notificationTime = AppConstants.defaultNotificationTime;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationService = di.sl<LocationService>();

      // Try to get saved location with default fallback
      final location = await locationService.getSavedLocation(useDefaultIfNotFound: true);
      setState(() {
        _latitude = location['latitude']!;
        _longitude = location['longitude']!;
      });

      setState(() {
        _notificationTime = prefs.getInt('notificationTime') ?? AppConstants.defaultNotificationTime;
        _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
        _selectedCalculationMethod = prefs.getString('calculationMethod') ?? AppConstants.defaultCalculationMethod;
      });

      // Get calculation methods from the service
      final prayerCalculationService = di.sl<PrayerCalculationService>();
      final methods = prayerCalculationService.getAvailableCalculationMethods();
      setState(() {
        _calculationMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to default calculation methods if service fails
      _calculationMethods = {
        'MWL': 'Muslim World League',
        'ISNA': 'Islamic Society of North America',
        'Egypt': 'Egyptian General Authority of Survey',
        'Makkah': 'Umm Al-Qura University, Makkah',
        'Karachi': 'University of Islamic Sciences, Karachi',
        'Tehran': 'Institute of Geophysics, University of Tehran',
        'Jafari': 'Shia Ithna-Ashari, Leva Institute, Qum',
      };

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationService = di.sl<LocationService>();

      // Save location
      await locationService.saveLocation(_latitude, _longitude);

      // Save other settings
      await prefs.setInt('notificationTime', _notificationTime);
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setString('calculationMethod', _selectedCalculationMethod);

      // Update calculation method
      context.read<PrayerTimeBloc>().add(
        UpdateCalculationMethodEvent(method: _selectedCalculationMethod),
      );

      // Update prayer notifications if enabled
      if (_notificationsEnabled) {
        // Get current prayer times
        context.read<PrayerTimeBloc>().add(
          GetPrayerTimeByDateEvent(date: DateTime.now()),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving settings: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Use the injected LocationService instead of creating a new one
      final locationService = di.sl<LocationService>();

      // Force refresh from GPS by setting useCache to false
      final location = await locationService.getCurrentLocation(useCache: false);

      setState(() {
        _latitude = location['latitude']!;
        _longitude = location['longitude']!;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e is LocationException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Settings'),
      ),
      body: BlocListener<PrayerTimeBloc, PrayerTimeState>(
        listener: (context, state) {
          if (state is CalculationMethodUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Calculation method updated!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is PrayerTimeLoaded && _notificationsEnabled) {
            // Schedule prayer notifications
            final notificationService = NotificationService();
            notificationService.schedulePrayerTimeNotifications(
              state.prayerTime,
              _notificationTime,
            );
          } else if (state is PrayerTimeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: _isLoading
            ? const LoadingIndicator(text: 'Loading settings...')
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calculation method
                    _buildSectionHeader('Calculation Method'),
                    Card(

                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select the calculation method for prayer times',
                                style: AppTextStyles.bodyMedium,
                              ),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedCalculationMethod,
                                decoration: InputDecoration(
                                  labelText: 'Calculation Method',
                                  border: OutlineInputBorder(),
                                ),
                                items: _calculationMethods.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedCalculationMethod = value;
                                    });
                                  }
                                },
                              ),
                              Text(
                                'Different regions use different calculation methods',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Location
                    _buildSectionHeader('Location'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set your location for accurate prayer times',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _latitude.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Latitude',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.location_on),
                                    ),
                                    onChanged: (value) {
                                      final latitude = double.tryParse(value);
                                      if (latitude != null) {
                                        setState(() {
                                          _latitude = latitude;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _longitude.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Longitude',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.location_on),
                                    ),
                                    onChanged: (value) {
                                      final longitude = double.tryParse(value);
                                      if (longitude != null) {
                                        setState(() {
                                          _longitude = longitude;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'Auto-detect Location',
                                icon: Icons.my_location,
                                onPressed: _getCurrentLocation,
                                buttonType: ButtonType.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This will use your device GPS to get your current location',
                              style: AppTextStyles.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Notifications
                    _buildSectionHeader('Notifications'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Enable Notifications',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                Switch(
                                  value: _notificationsEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _notificationsEnabled = value;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Notification Time',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              value: _notificationTime,
                              decoration: const InputDecoration(
                                labelText: 'Minutes before prayer',
                                border: OutlineInputBorder(),
                              ),
                              items: [5, 10, 15, 20, 30, 45, 60].map((minutes) {
                                return DropdownMenuItem<int>(
                                  value: minutes,
                                  child: Text('$minutes minutes before'),
                                );
                              }).toList(),
                              onChanged: _notificationsEnabled
                                  ? (value) {
                                      if (value != null) {
                                        setState(() {
                                          _notificationTime = value;
                                        });
                                      }
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Save Settings',
                        onPressed: _saveSettings,
                        buttonType: ButtonType.primary,
                        icon: Icons.save,
                      ),
                    ),

                  ],

                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SectionHeader(
      title: title,
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
    );
  }
}
