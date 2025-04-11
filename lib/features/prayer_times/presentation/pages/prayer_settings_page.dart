import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_theme.dart';
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
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _latitude = prefs.getDouble('latitude') ?? 0.0;
      _longitude = prefs.getDouble('longitude') ?? 0.0;
      _notificationTime = prefs.getInt('notificationTime') ?? AppConstants.defaultNotificationTime;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });

    // Load calculation methods
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

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('latitude', _latitude);
    await prefs.setDouble('longitude', _longitude);
    await prefs.setInt('notificationTime', _notificationTime);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);

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
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calculation method
                    _buildSectionHeader('Calculation Method'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select the calculation method for prayer times',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedCalculationMethod,
                              decoration: const InputDecoration(
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
                            const SizedBox(height: 8),
                            Text(
                              'Different regions use different calculation methods',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
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
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implement auto-detect location
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Auto-detect location not implemented yet'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.my_location),
                                label: const Text('Auto-detect Location'),
                              ),
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
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        child: const Text('Save Settings'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.headingSmall,
      ),
    );
  }
}
