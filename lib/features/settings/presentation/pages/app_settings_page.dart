import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/localization/language_selector.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/bloc/theme_bloc_exports.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('settings.title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance section
            _buildSectionHeader(context, 'settings.appearance'),
            _buildThemeSelector(context),
            const SizedBox(height: 24),
            
            // Language section
            _buildSectionHeader(context, 'settings.language'),
            const LanguageSelector(),
            const SizedBox(height: 24),
            
            // About section
            _buildSectionHeader(context, 'settings.about'),
            _buildAboutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String titleKey) {
    return SectionHeader(
      title: context.tr.translate(titleKey),
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.translate('settings.theme'),
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.lightMode'),
                  ThemeMode.light,
                  state.themeMode,
                  Icons.light_mode,
                ),
                const Divider(),
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.darkMode'),
                  ThemeMode.dark,
                  state.themeMode,
                  Icons.dark_mode,
                ),
                const Divider(),
                _buildThemeOption(
                  context,
                  context.tr.translate('settings.systemMode'),
                  ThemeMode.system,
                  state.themeMode,
                  Icons.settings_suggest,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String themeName,
    ThemeMode themeMode,
    ThemeMode currentThemeMode,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        context.read<ThemeBloc>().add(ToggleThemeEvent());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Text(
              themeName,
              style: AppTextStyles.bodyLarge,
            ),
            const Spacer(),
            if (currentThemeMode == themeMode)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(context.tr.translate('settings.version')),
              subtitle: const Text('1.0.0'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(context.tr.translate('settings.privacyPolicy')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to privacy policy
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(context.tr.translate('settings.termsOfService')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to terms of service
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(context.tr.translate('settings.contactUs')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to contact page
              },
            ),
          ],
        ),
      ),
    );
  }
}
