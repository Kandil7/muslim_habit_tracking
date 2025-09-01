import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/settings/domain/entities/enhanced/user_preferences.dart';
import 'package:muslim_habbit/features/settings/presentation/bloc/enhanced/enhanced_settings_bloc.dart';

/// Enhanced Settings Page
class EnhancedSettingsPage extends StatelessWidget {
  const EnhancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<EnhancedSettingsBloc>()
                  .add(LoadUserPreferences());
            },
          ),
        ],
      ),
      body: BlocBuilder<EnhancedSettingsBloc, EnhancedSettingsState>(
        builder: (context, state) {
          if (state is EnhancedSettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EnhancedSettingsLoaded) {
            return _SettingsContent(preferences: state.preferences);
          } else if (state is EnhancedSettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<EnhancedSettingsBloc>()
                          .add(LoadUserPreferences());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Widget to display the settings content
class _SettingsContent extends StatelessWidget {
  final UserPreferences preferences;

  const _SettingsContent({required this.preferences});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme settings
            _ThemeSettingsSection(theme: preferences.theme),
            const SizedBox(height: 20),
            
            // Notification settings
            _NotificationSettingsSection(
                notificationPreferences: preferences.notificationPreferences),
            const SizedBox(height: 20),
            
            // Privacy settings
            _PrivacySettingsSection(privacySettings: preferences.privacySettings),
            const SizedBox(height: 20),
            
            // Accessibility settings
            _AccessibilitySettingsSection(
                accessibilitySettings: preferences.accessibilitySettings),
            const SizedBox(height: 20),
            
            // Daily planner settings
            _DailyPlannerSettingsSection(
                dailyPlannerSettings: preferences.dailyPlannerSettings),
            const SizedBox(height: 20),
            
            // Ibadah settings
            _IbadahSettingsSection(ibadahSettings: preferences.ibadahSettings),
            const SizedBox(height: 20),
            
            // Skills settings
            _SkillsSettingsSection(skillsSettings: preferences.skillsSettings),
            const SizedBox(height: 20),
            
            // Self-development settings
            _SelfDevelopmentSettingsSection(
                selfDevelopmentSettings: preferences.selfDevelopmentSettings),
            const SizedBox(height: 20),
            
            // Action buttons
            _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

/// Widget to display theme settings section
class _ThemeSettingsSection extends StatelessWidget {
  final ThemePreference theme;

  const _ThemeSettingsSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: theme.mode,
              decoration: const InputDecoration(labelText: 'Theme Mode'),
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
                DropdownMenuItem(value: 'system', child: Text('System Default')),
              ],
              onChanged: (value) {
                // TODO: Update theme preference
              },
            ),
            const SizedBox(height: 12),
            Slider(
              value: theme.textScaleFactor,
              min: 0.8,
              max: 2.0,
              divisions: 12,
              label: 'Text Scale: ${theme.textScaleFactor.toStringAsFixed(1)}',
              onChanged: (value) {
                // TODO: Update text scale factor
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('High Contrast Mode'),
              value: theme.highContrastMode,
              onChanged: (value) {
                // TODO: Update high contrast mode
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display notification settings section
class _NotificationSettingsSection extends StatelessWidget {
  final NotificationPreferences notificationPreferences;

  const _NotificationSettingsSection({required this.notificationPreferences});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: true, // This would come from a higher level setting
              onChanged: (value) {
                // TODO: Update notifications enabled
              },
            ),
            SwitchListTile(
              title: const Text('Prayer Reminders'),
              value: notificationPreferences.prayerReminders,
              onChanged: (value) {
                // TODO: Update prayer reminders
              },
            ),
            SwitchListTile(
              title: const Text('Habit Reminders'),
              value: notificationPreferences.habitReminders,
              onChanged: (value) {
                // TODO: Update habit reminders
              },
            ),
            SwitchListTile(
              title: const Text('Task Reminders'),
              value: notificationPreferences.taskReminders,
              onChanged: (value) {
                // TODO: Update task reminders
              },
            ),
            SwitchListTile(
              title: const Text('Adhkar Reminders'),
              value: notificationPreferences.adhkarReminders,
              onChanged: (value) {
                // TODO: Update adhkar reminders
              },
            ),
            SwitchListTile(
              title: const Text('Mindfulness Reminders'),
              value: notificationPreferences.mindfulnessReminders,
              onChanged: (value) {
                // TODO: Update mindfulness reminders
              },
            ),
            SwitchListTile(
              title: const Text('Goal Reminders'),
              value: notificationPreferences.goalReminders,
              onChanged: (value) {
                // TODO: Update goal reminders
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display privacy settings section
class _PrivacySettingsSection extends StatelessWidget {
  final PrivacySettings privacySettings;

  const _PrivacySettingsSection({required this.privacySettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Analytics Collection'),
              value: privacySettings.analyticsCollection,
              onChanged: (value) {
                // TODO: Update analytics collection
              },
            ),
            SwitchListTile(
              title: const Text('Crash Reporting'),
              value: privacySettings.crashReporting,
              onChanged: (value) {
                // TODO: Update crash reporting
              },
            ),
            SwitchListTile(
              title: const Text('Location Sharing'),
              value: privacySettings.locationSharing,
              onChanged: (value) {
                // TODO: Update location sharing
              },
            ),
            SwitchListTile(
              title: const Text('Backup Encryption'),
              value: privacySettings.backupEncryption,
              onChanged: (value) {
                // TODO: Update backup encryption
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display accessibility settings section
class _AccessibilitySettingsSection extends StatelessWidget {
  final AccessibilitySettings accessibilitySettings;

  const _AccessibilitySettingsSection({required this.accessibilitySettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accessibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Reduce Motion'),
              value: accessibilitySettings.reduceMotion,
              onChanged: (value) {
                // TODO: Update reduce motion
              },
            ),
            SwitchListTile(
              title: const Text('Bold Text'),
              value: accessibilitySettings.boldText,
              onChanged: (value) {
                // TODO: Update bold text
              },
            ),
            SwitchListTile(
              title: const Text('Increase Contrast'),
              value: accessibilitySettings.increaseContrast,
              onChanged: (value) {
                // TODO: Update increase contrast
              },
            ),
            SwitchListTile(
              title: const Text('Larger Text'),
              value: accessibilitySettings.largerText,
              onChanged: (value) {
                // TODO: Update larger text
              },
            ),
            Slider(
              value: accessibilitySettings.fontSizeScale,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label:
                  'Font Scale: ${accessibilitySettings.fontSizeScale.toStringAsFixed(1)}',
              onChanged: (value) {
                // TODO: Update font size scale
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display daily planner settings section
class _DailyPlannerSettingsSection extends StatelessWidget {
  final DailyPlannerSettings dailyPlannerSettings;

  const _DailyPlannerSettingsSection({required this.dailyPlannerSettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Planner',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Time Blocking'),
              value: dailyPlannerSettings.enableTimeBlocking,
              onChanged: (value) {
                // TODO: Update enable time blocking
              },
            ),
            SwitchListTile(
              title: const Text('Show Completed Tasks'),
              value: dailyPlannerSettings.showCompletedTasks,
              onChanged: (value) {
                // TODO: Update show completed tasks
              },
            ),
            SwitchListTile(
              title: const Text('Enable Task Dependencies'),
              value: dailyPlannerSettings.enableTaskDependencies,
              onChanged: (value) {
                // TODO: Update enable task dependencies
              },
            ),
            SwitchListTile(
              title: const Text('Enable Recurring Tasks'),
              value: dailyPlannerSettings.enableRecurringTasks,
              onChanged: (value) {
                // TODO: Update enable recurring tasks
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display Ibadah settings section
class _IbadahSettingsSection extends StatelessWidget {
  final IbadahSettings ibadahSettings;

  const _IbadahSettingsSection({required this.ibadahSettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ibadah Hub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Khushu Reminders'),
              value: ibadahSettings.enableKhushuReminders,
              onChanged: (value) {
                // TODO: Update enable khushu reminders
              },
            ),
            TextFormField(
              initialValue:
                  ibadahSettings.prePrayerReminderMinutes.toString(),
              decoration: const InputDecoration(
                labelText: 'Pre-Prayer Reminder (minutes)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // TODO: Update pre-prayer reminder minutes
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Adhkar Tracking'),
              value: ibadahSettings.enableAdhkarTracking,
              onChanged: (value) {
                // TODO: Update enable adhkar tracking
              },
            ),
            SwitchListTile(
              title: const Text('Enable Quran Reflections'),
              value: ibadahSettings.enableQuranReflections,
              onChanged: (value) {
                // TODO: Update enable quran reflections
              },
            ),
            SwitchListTile(
              title: const Text('Enable Lecture Notes'),
              value: ibadahSettings.enableLectureNotes,
              onChanged: (value) {
                // TODO: Update enable lecture notes
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display skills settings section
class _SkillsSettingsSection extends StatelessWidget {
  final SkillsSettings skillsSettings;

  const _SkillsSettingsSection({required this.skillsSettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills Hub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Time Tracking'),
              value: skillsSettings.enableTimeTracking,
              onChanged: (value) {
                // TODO: Update enable time tracking
              },
            ),
            SwitchListTile(
              title: const Text('Enable Resource Tagging'),
              value: skillsSettings.enableResourceTagging,
              onChanged: (value) {
                // TODO: Update enable resource tagging
              },
            ),
            SwitchListTile(
              title: const Text('Enable Challenge Difficulty Tracking'),
              value: skillsSettings.enableChallengeDifficultyTracking,
              onChanged: (value) {
                // TODO: Update enable challenge difficulty tracking
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display self-development settings section
class _SelfDevelopmentSettingsSection extends StatelessWidget {
  final SelfDevelopmentSettings selfDevelopmentSettings;

  const _SelfDevelopmentSettingsSection({required this.selfDevelopmentSettings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Self Development Hub',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Goal Tracking'),
              value: selfDevelopmentSettings.enableGoalTracking,
              onChanged: (value) {
                // TODO: Update enable goal tracking
              },
            ),
            SwitchListTile(
              title: const Text('Enable Reflection Reminders'),
              value: selfDevelopmentSettings.enableReflectionReminders,
              onChanged: (value) {
                // TODO: Update enable reflection reminders
              },
            ),
            SwitchListTile(
              title: const Text('Enable Mindfulness Sessions'),
              value: selfDevelopmentSettings.enableMindfulnessSessions,
              onChanged: (value) {
                // TODO: Update enable mindfulness sessions
              },
            ),
            SwitchListTile(
              title: const Text('Enable Mood Tracking'),
              value: selfDevelopmentSettings.enableMoodTracking,
              onChanged: (value) {
                // TODO: Update enable mood tracking
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display action buttons
class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<EnhancedSettingsBloc>()
                  .add(ResetToDefaultSettings());
            },
            child: const Text('Reset to Default'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Export settings
            },
            child: const Text('Export Settings'),
          ),
        ),
      ],
    );
  }
}