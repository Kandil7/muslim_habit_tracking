import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import 'language_provider.dart';
import 'app_localizations_extension.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.locale.languageCode;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.translate('settings.language'),
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(
              context,
              'English',
              'en',
              currentLanguage,
              languageProvider,
            ),
            const Divider(),
            _buildLanguageOption(
              context,
              'العربية',
              'ar',
              currentLanguage,
              languageProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    String currentLanguage,
    LanguageProvider languageProvider,
  ) {
    return InkWell(
      onTap: () {
        languageProvider.changeLanguage(Locale(languageCode));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              languageName,
              style: AppTextStyles.bodyLarge,
            ),
            const Spacer(),
            if (currentLanguage == languageCode)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
