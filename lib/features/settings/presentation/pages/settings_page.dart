import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/localization/bloc/language_bloc_exports.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/bloc/theme_bloc_exports.dart';

/// Settings page for the application
class SettingsPage extends StatefulWidget {
  /// Constructor
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Unknown';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.translate('settings.title'))),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                children: [
                  _buildGeneralSection(context),
                  const Divider(),
                  _buildAppearanceSection(context),
                  const Divider(),
                  _buildNotificationsSection(context),
                  const Divider(),
                  _buildDataManagementSection(context),
                  const Divider(),
                  _buildAboutSection(context),
                ],
              ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return _buildSection(
      context,
      title: context.tr.translate('settings.general'),
      icon: Icons.settings,
      children: [_buildLanguageSelector(context)],
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.tr.translate('settings.language')),
          subtitle: Text(
            state.locale.languageCode == 'en' ? 'English' : 'العربية',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(context, state.locale),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, Locale currentLocale) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr.translate('settings.language')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context,
                  'English',
                  const Locale('en'),
                  currentLocale,
                ),
                _buildLanguageOption(
                  context,
                  'العربية',
                  const Locale('ar'),
                  currentLocale,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr.translate('common.cancel')),
              ),
            ],
          ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    Locale locale,
    Locale currentLocale,
  ) {
    final isSelected = locale.languageCode == currentLocale.languageCode;

    return ListTile(
      title: Text(languageName),
      leading:
          isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : const Icon(Icons.circle_outlined),
      onTap: () {
        if (!isSelected) {
          context.read<LanguageCubit>().changeLanguage(locale);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return _buildSection(
      context,
      title: context.tr.translate('settings.appearance'),
      icon: Icons.palette,
      children: [_buildThemeSelector(context)],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(
            state.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : state.themeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.brightness_auto,
          ),
          title: Text(context.tr.translate('settings.theme')),
          subtitle: Text(
            state.themeMode == ThemeMode.dark
                ? context.tr.translate('settings.darkMode')
                : state.themeMode == ThemeMode.light
                ? context.tr.translate('settings.lightMode')
                : context.tr.translate('settings.systemMode'),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showThemeDialog(context, state.themeMode),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentThemeMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr.translate('settings.theme')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.lightMode'),
                  Icons.light_mode,
                  ThemeMode.light,
                  currentThemeMode,
                ),
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.darkMode'),
                  Icons.dark_mode,
                  ThemeMode.dark,
                  currentThemeMode,
                ),
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.systemMode'),
                  Icons.brightness_auto,
                  ThemeMode.system,
                  currentThemeMode,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr.translate('common.cancel')),
              ),
            ],
          ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String themeName,
    IconData icon,
    ThemeMode themeMode,
    ThemeMode currentThemeMode,
  ) {
    final isSelected = themeMode == currentThemeMode;

    return ListTile(
      title: Text(themeName),
      leading: Icon(icon),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : null,
      onTap: () {
        if (!isSelected) {
          context.read<ThemeBloc>().add(SetThemeModeEvent(themeMode));
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      context,
      title: context.tr.translate('settings.notifications'),
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: Text(context.tr.translate('settings.notifications')),
          subtitle: Text(context.tr.translate('settings.enableNotifications')),
          value: true, // This would be controlled by a state
          onChanged: (value) {
            // This would update a state
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notification settings will be implemented soon'),
              ),
            );
          },
          secondary: const Icon(Icons.notifications_active),
        ),
        SwitchListTile(
          title: Text(context.tr.translate('settings.sound')),
          value: true, // This would be controlled by a state
          onChanged: (value) {
            // This would update a state
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sound settings will be implemented soon'),
              ),
            );
          },
          secondary: const Icon(Icons.volume_up),
        ),
        SwitchListTile(
          title: Text(context.tr.translate('settings.vibration')),
          value: true, // This would be controlled by a state
          onChanged: (value) {
            // This would update a state
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Vibration settings will be implemented soon'),
              ),
            );
          },
          secondary: const Icon(Icons.vibration),
        ),
      ],
    );
  }

  Widget _buildDataManagementSection(BuildContext context) {
    return _buildSection(
      context,
      title: context.tr.translate('settings.dataManagement'),
      icon: Icons.storage,
      children: [
        ListTile(
          leading: const Icon(Icons.upload),
          title: Text(context.tr.translate('settings.exportData')),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Export data feature will be implemented soon'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: Text(context.tr.translate('settings.importData')),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Import data feature will be implemented soon'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: Text(
            context.tr.translate('settings.deleteData'),
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () => _showDeleteDataDialog(context),
        ),
      ],
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              context.tr.translate('settings.deleteData'),
              style: const TextStyle(color: Colors.red),
            ),
            content: Text(context.tr.translate('settings.deleteDataConfirm')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.tr.translate('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // This would actually delete the data
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Delete data feature will be implemented soon',
                      ),
                    ),
                  );
                },
                child: Text(
                  context.tr.translate('common.delete'),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      title: context.tr.translate('settings.about'),
      icon: Icons.info,
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(context.tr.translate('settings.version')),
          subtitle: Text(_appVersion),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: Text(context.tr.translate('settings.privacyPolicy')),
          onTap: () => _launchURL('https://example.com/privacy'),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: Text(context.tr.translate('settings.termsOfService')),
          onTap: () => _launchURL('https://example.com/terms'),
        ),
        ListTile(
          leading: const Icon(Icons.mail),
          title: Text(context.tr.translate('settings.contactUs')),
          onTap: () => _launchURL('mailto:support@example.com'),
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: Text(context.tr.translate('settings.rateApp')),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rate app feature will be implemented soon'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: Text(context.tr.translate('settings.shareApp')),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Share app feature will be implemented soon'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: Text(context.tr.translate('settings.feedback')),
          onTap: () => _launchURL('mailto:feedback@example.com'),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
