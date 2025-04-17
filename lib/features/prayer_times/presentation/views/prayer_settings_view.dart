import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/prayer/prayer_cubit.dart';

class PrayerSettingsView extends StatelessWidget {
  const PrayerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerCubit = context.read<PrayerCubit>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Settings'),
        centerTitle: true,
      ),
      body: BlocBuilder<PrayerCubit, PrayerState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enable Prayer Time Notifications'),
                  subtitle: const Text(
                      'Receive notifications before prayer times'),
                  value: prayerCubit.notificationsEnabled,
                  onChanged: (value) {
                    prayerCubit.toggleNotifications(value);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Notification Time'),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Minutes before prayer',
                    border: OutlineInputBorder(),
                  ),
                  value: prayerCubit.notificationMinutesBefore,
                  items: [5, 10, 15, 20, 30, 45, 60]
                      .map((minutes) => DropdownMenuItem<int>(
                            value: minutes,
                            child: Text('$minutes minutes'),
                          ))
                      .toList(),
                  onChanged: prayerCubit.notificationsEnabled
                      ? (value) {
                          if (value != null) {
                            prayerCubit.setNotificationTime(value);
                          }
                        }
                      : null,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Location Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    prayerCubit.setLocation();
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Update Location'),
                ),
                if (state is SetLocationError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (state is SetLocationSuccess)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Location updated successfully!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
