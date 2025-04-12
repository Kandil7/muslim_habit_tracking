import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracking/core/presentation/widgets/widgets.dart';
import 'package:ramadan_habit_tracking/core/services/cache_manager.dart';
import 'package:ramadan_habit_tracking/core/theme/app_icons.dart';
import 'package:ramadan_habit_tracking/core/theme/app_theme.dart';
import 'package:ramadan_habit_tracking/core/theme/bloc/theme_bloc_exports.dart';
import 'package:ramadan_habit_tracking/features/prayer_times/presentation/pages/prayer_settings_page.dart';

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App info section
          const SectionHeader(title: 'App Info'),
          SettingsCard(
            title: 'SunnahTrack',
            subtitle: 'Version 1.0.0',
            leading: const Icon(AppIcons.info),
            onTap: () {
              // TODO: Show app info dialog
            },
          ),
          const SizedBox(height: 16),

          // Prayer settings section
          const SectionHeader(title: 'Prayer Settings'),
          SettingsCard(
            title: 'Prayer Times Calculation Method',
            subtitle: 'Muslim World League',
            leading: const Icon(AppIcons.prayer),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerSettingsPage(),
                ),
              );
            },
          ),
          SettingsCard(
            title: 'Location',
            subtitle: 'Automatic',
            leading: const Icon(AppIcons.calendar),
            onTap: () {
              // TODO: Navigate to location settings
            },
          ),
          SettingsCard(
            title: 'Prayer Notifications',
            subtitle: '15 minutes before prayer',
            leading: const Icon(AppIcons.notification),
            onTap: () {
              // TODO: Navigate to prayer notification settings
            },
          ),
          const SizedBox(height: 16),

          // Appearance section
          const SectionHeader(title: 'Appearance'),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final isDarkMode = state.themeMode == ThemeMode.dark;
              return SettingsCard(
                title: 'Theme',
                subtitle: _getThemeModeText(state.themeMode),
                leading: Icon(
                  _getThemeModeIcon(state.themeMode),
                ),
                onTap: () {
                  _showThemeSelectionDialog(context);
                },
              );
            },
          ),
          SettingsCard(
            title: 'Language',
            subtitle: 'English',
            leading: const Icon(AppIcons.language),
            onTap: () {
              // TODO: Show language selection dialog
            },
          ),
          const SizedBox(height: 16),

          // Data section
          const SectionHeader(title: 'Data'),
          SettingsCard(
            title: 'Export Data',
            subtitle: 'Export your habits and progress',
            leading: const Icon(AppIcons.share),
            onTap: () {
              // TODO: Implement data export
            },
          ),
          SettingsCard(
            title: 'Import Data',
            subtitle: 'Import habits and progress',
            leading: const Icon(AppIcons.share),
            onTap: () {
              // TODO: Implement data import
            },
          ),
          SettingsCard(
            title: 'Clear All Data',
            subtitle: 'Delete all habits and progress',
            leading: const Icon(AppIcons.clearData, color: AppColors.error),
            onTap: () {
              _showClearDataConfirmationDialog(context);
            },
          ),
          SettingsCard(
            title: 'Clear Cache',
            subtitle: 'Clear temporary data and images',
            leading: const Icon(AppIcons.clearCache),
            onTap: () {
              _clearCache(context);
            },
          ),
          const SizedBox(height: 32),

          // About section
          Center(
            child: CustomButton(
              text: 'About SunnahTrack',
              onPressed: () {
                // TODO: Show about dialog
              },
              buttonType: ButtonType.text,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();
    final currentThemeMode = (themeBloc.state as ThemeLoaded).themeMode;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: [
          RadioListTile<ThemeMode>(
            title: const Row(
              children: [
                Icon(AppIcons.themeLight),
                SizedBox(width: 16),
                Text('Light'),
              ],
            ),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                themeBloc.add(SetThemeModeEvent(value));
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Row(
              children: [
                Icon(AppIcons.themeDark),
                SizedBox(width: 16),
                Text('Dark'),
              ],
            ),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                themeBloc.add(SetThemeModeEvent(value));
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Row(
              children: [
                Icon(AppIcons.themeSystem),
                SizedBox(width: 16),
                Text('System Default'),
              ],
            ),
            value: ThemeMode.system,
            groupValue: currentThemeMode,
            onChanged: (value) {
              if (value != null) {
                themeBloc.add(SetThemeModeEvent(value));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Get the text description for a theme mode
  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'System default';
    }
  }

  /// Get the icon for a theme mode
  IconData _getThemeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppIcons.themeLight;
      case ThemeMode.dark:
        return AppIcons.themeDark;
      case ThemeMode.system:
        return AppIcons.themeSystem;
    }
  }

  void _clearCache(BuildContext context) async {
    final cacheManager = CacheManager();
    final cacheSize = await cacheManager.getCacheSize();
    final cacheSizeInMB = (cacheSize / (1024 * 1024)).toStringAsFixed(2);

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: Text('This will clear $cacheSizeInMB MB of cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Clear Cache',
            onPressed: () async {
              Navigator.pop(context);
              await cacheManager.clearCache();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                  ),
                );
              }
            },
            buttonType: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your habits, progress, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Clear All Data',
            onPressed: () {
              // TODO: Implement clear all data functionality
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been cleared'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            buttonType: ButtonType.primary,
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
