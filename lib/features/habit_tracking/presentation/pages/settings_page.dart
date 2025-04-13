import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/services/cache_manager.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/bloc/theme_bloc_exports.dart';
import '../../../../features/prayer_times/presentation/pages/prayer_settings_page.dart';

import '../../../../core/presentation/widgets/section_header.dart';

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('settings.title')),
      ),
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
              // TODO: Show app info dialog
            },
          ),
          const SizedBox(height: 16),

          // Prayer settings section
          SectionHeader(title: context.tr.translate('prayer.settings')),
          SettingsCard(
            title: context.tr.translate('prayer.calculationMethod'),
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
            title: context.tr.translate('prayer.location'),
            subtitle: context.tr.translate('prayer.autoDetectLocation'),
            leading: const Icon(AppIcons.calendar),
            onTap: () {
              // TODO: Navigate to location settings
            },
          ),
          SettingsCard(
            title: context.tr.translate('prayer.notifications'),
            subtitle: '15 ${context.tr.translate('prayer.notificationTime')}',
            leading: const Icon(AppIcons.notification),
            onTap: () {
              // TODO: Navigate to prayer notification settings
            },
          ),
          const SizedBox(height: 16),

          // Appearance section
          SectionHeader(title: context.tr.translate('settings.appearance')),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final isDarkMode = state.themeMode == ThemeMode.dark;
              return SettingsCard(
                title: context.tr.translate('settings.theme'),
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
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) {
              return SettingsCard(
                title: context.tr.translate('settings.language'),
                subtitle: languageProvider.locale.languageCode == 'en' ? 'English' : 'العربية',
                leading: const Icon(AppIcons.language),
                onTap: () {
                  _showLanguageSelectionDialog(context, languageProvider);
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
              // TODO: Implement data export
            },
          ),
          SettingsCard(
            title: context.tr.translate('settings.importData'),
            subtitle: context.tr.translate('settings.importData'),
            leading: const Icon(AppIcons.share),
            onTap: () {
              // TODO: Implement data import
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
              text: context.tr.translate('settings.about') + ' ' + context.tr.translate('app.name'),
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
        title: Text(context.tr.translate('settings.theme')),
        children: [
          RadioListTile<ThemeMode>(
            title: Row(
              children: [
                const Icon(AppIcons.themeLight),
                const SizedBox(width: 16),
                Text(context.tr.translate('settings.lightMode')),
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
            title: Row(
              children: [
                const Icon(AppIcons.themeDark),
                const SizedBox(width: 16),
                Text(context.tr.translate('settings.darkMode')),
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
            title: Row(
              children: [
                const Icon(AppIcons.themeSystem),
                const SizedBox(width: 16),
                Text(context.tr.translate('settings.systemMode')),
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
        return context.tr.translate('settings.lightMode');
      case ThemeMode.dark:
        return context.tr.translate('settings.darkMode');
      case ThemeMode.system:
        return context.tr.translate('settings.systemMode');
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
        title: Text(context.tr.translate('settings.clearCache')),
        content: Text('${context.tr.translate('settings.clearCacheConfirm')} $cacheSizeInMB MB'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.translate('common.cancel')),
          ),
          CustomButton(
            text: context.tr.translate('settings.clearCache'),
            onPressed: () async {
              Navigator.pop(context);
              await cacheManager.clearCache();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr.translate('settings.clearCacheSuccess')),
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
        title: Text(context.tr.translate('settings.deleteData')),
        content: Text(
          context.tr.translate('settings.deleteDataConfirm'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr.translate('common.cancel')),
          ),
          CustomButton(
            text: context.tr.translate('settings.deleteData'),
            onPressed: () {
              // TODO: Implement clear all data functionality
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr.translate('settings.deleteSuccess')),
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

  void _showLanguageSelectionDialog(BuildContext context, LanguageProvider languageProvider) {
    final currentLanguage = languageProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.tr.translate('settings.language')),
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: currentLanguage,
            onChanged: (value) {
              if (value != null) {
                languageProvider.changeLanguage(const Locale('en'));
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: currentLanguage,
            onChanged: (value) {
              if (value != null) {
                languageProvider.changeLanguage(const Locale('ar'));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
