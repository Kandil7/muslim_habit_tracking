import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/localization/bloc/language_bloc_exports.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/services/cache_manager.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

import 'accessibility_settings_page.dart';

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.translate('settings.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App info section
          SectionHeader(title: context.tr.translate('settings.about')),
          SettingsCard(
            title: context.tr.translate('app.name'),
            subtitle: '${context.tr.translate('settings.version')} 1.0.0',
            leading: const Icon(AppIcons.info),
            onTap: () {
              _showAppInfoDialog(context);
            },
          ),
          const SizedBox(height: 16),

          SettingsCard(
            title: context.tr.translate('prayer.notifications'),
            subtitle: '15 ${context.tr.translate('prayer.notificationTime')}',
            leading: const Icon(AppIcons.notification),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccessibilitySettingsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Appearance section
          SectionHeader(title: context.tr.translate('settings.appearance')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr.translate('settings.theme'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const ThemeToggleButton(
                  size: 32,
                  semanticLabel: 'Toggle theme',
                ),
              ],
            ),
          ),
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return SettingsCard(
                title: context.tr.translate('settings.language'),
                subtitle:
                    languageState.locale.languageCode == 'en'
                        ? 'English'
                        : 'العربية',
                leading: const Icon(AppIcons.language),
                onTap: () {
                  _showLanguageSelectionDialog(context);
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Data section
          SectionHeader(title: context.tr.translate('settings.dataManagement')),
          SettingsCard(
            title: context.tr.translate('settings.exportData'),
            subtitle: context.tr.translate('settings.exportData'),
            leading: const Icon(AppIcons.share),
            onTap: () {
              _exportData(context);
            },
          ),
          SettingsCard(
            title: context.tr.translate('settings.importData'),
            subtitle: context.tr.translate('settings.importData'),
            leading: const Icon(AppIcons.share),
            onTap: () {
              _importData(context);
            },
          ),
          SettingsCard(
            title: context.tr.translate('settings.deleteData'),
            subtitle: context.tr.translate('settings.deleteData'),
            leading: const Icon(AppIcons.clearData, color: AppColors.error),
            onTap: () {
              _showClearDataConfirmationDialog(context);
            },
          ),
          SettingsCard(
            title: context.tr.translate('settings.clearCache'),
            subtitle: context.tr.translate('settings.clearCache'),
            leading: const Icon(AppIcons.clearCache),
            onTap: () {
              _clearCache(context);
            },
          ),
          const SizedBox(height: 32),

          // About section
          Center(
            child: CustomButton(
              text:
                  '${context.tr.translate('settings.about')} ${context.tr.translate('app.name')}',
              onPressed: () {
                _showAboutDialog(context);
              },
              buttonType: ButtonType.text,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    final cacheManager = CacheManager();
    final cacheSize = await cacheManager.getCacheSize();
    final cacheSizeInMB = (cacheSize / (1024 * 1024)).toStringAsFixed(2);

    // Guard against context no longer being mounted
    if (!context.mounted) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr.translate('settings.clearCache')),
            content: Text(
              '${context.tr.translate('settings.clearCacheConfirm')} $cacheSizeInMB MB',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(context.tr.translate('common.cancel')),
              ),
              CustomButton(
                text: context.tr.translate('settings.clearCache'),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await cacheManager.clearCache();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.tr.translate('settings.clearCacheSuccess'),
                        ),
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
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr.translate('settings.deleteData')),
            content: Text(context.tr.translate('settings.deleteDataConfirm')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(context.tr.translate('common.cancel')),
              ),
              CustomButton(
                text: context.tr.translate('settings.deleteData'),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _clearAllData(context);
                },
                buttonType: ButtonType.primary,
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
            ],
          ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final languageCubit = context.read<LanguageCubit>();
    final currentLanguage = languageCubit.state.locale.languageCode;

    showDialog(
      context: context,
      builder:
          (dialogContext) => SimpleDialog(
            title: Text(context.tr.translate('settings.language')),
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    languageCubit.changeLanguage(const Locale('en'));
                    Navigator.pop(dialogContext);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('العربية'),
                value: 'ar',
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    languageCubit.changeLanguage(const Locale('ar'));
                    Navigator.pop(dialogContext);
                  }
                },
              ),
            ],
          ),
    );
  }

  /// Show app info dialog
  Future<void> _showAppInfoDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (context.mounted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(context.tr.translate('app.name')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, 'Version', packageInfo.version),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Build', packageInfo.buildNumber),
                  const SizedBox(height: 16),
                  Text(
                    'SunnahTrack is an Islamic-themed habit tracker to help Muslims build and maintain consistent worship practices.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr.translate('common.close')),
                ),
              ],
            ),
      );
    }
  }

  /// Show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AboutDialog(
            applicationName: AppConstants.appName,
            applicationVersion: AppConstants.appVersion,
            applicationIcon: Image.asset(
              'assets/images/app_icon.png',
              width: 48,
              height: 48,
            ),
            children: [
              const SizedBox(height: 16),
              Text(
                'SunnahTrack is an Islamic-themed habit tracker to help Muslims build and maintain consistent worship practices.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '© ${DateTime.now().year} SunnahTrack',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap:
                    () => _launchUrl(
                      'https://github.com/Kandil7/muslim_habit_tracking',
                    ),
                child: Text(
                  'GitHub Repository',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Launch URL helper
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Build info row for app info dialog
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  /// Export app data
  Future<void> _exportData(BuildContext context) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.translate('settings.exportingData'))),
      );

      // Get app directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/sunnah_track_backup_$timestamp.json';

      // Create backup file
      final file = File(filePath);

      // Create backup data
      final backupData = {
        'version': AppConstants.appVersion,
        'timestamp': timestamp,
        'data': {
          'habits': await _getHabitData(),
          'prayers': await _getPrayerData(),
          'quran': await _getQuranData(),
        },
      };

      // Write to file
      await file.writeAsString(backupData.toString());

      // Share the file
      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(filePath)],
          subject: 'SunnahTrack Backup',
          text: 'SunnahTrack data backup created on ${DateTime.now()}',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Import app data
  Future<void> _importData(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.translate('settings.importFeatureComingSoon'),
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Clear all app data
  Future<void> _clearAllData(BuildContext context) async {
    try {
      // Clear all Hive boxes
      await Hive.box(AppConstants.habitsBoxName).clear();
      await Hive.box(AppConstants.habitLogsBoxName).clear();
      await Hive.box(AppConstants.prayerTimesBoxName).clear();
      await Hive.box(AppConstants.settingsBoxName).clear();
      await Hive.box(AppConstants.duaDhikrBoxName).clear();
      await Hive.box(AppConstants.hadithBoxName).clear();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr.translate('settings.deleteSuccess')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Get habit data for backup
  Future<List<Map<String, dynamic>>> _getHabitData() async {
    // This would be implemented to get actual habit data
    // For now, return empty list as placeholder
    return [];
  }

  /// Get prayer data for backup
  Future<List<Map<String, dynamic>>> _getPrayerData() async {
    // This would be implemented to get actual prayer data
    // For now, return empty list as placeholder
    return [];
  }

  /// Get quran data for backup
  Future<List<Map<String, dynamic>>> _getQuranData() async {
    // This would be implemented to get actual quran data
    // For now, return empty list as placeholder
    return [];
  }
}
