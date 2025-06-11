import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import 'app_localizations_extension.dart';
import 'bloc/language_bloc_exports.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final currentLanguage = state.locale.languageCode;

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
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                _buildLanguageOption(context, 'English', 'en', currentLanguage),
                const Divider(),
                _buildLanguageOption(context, 'العربية', 'ar', currentLanguage),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    String currentLanguage,
  ) {
    return InkWell(
      onTap: () {
        context.read<LanguageCubit>().changeLanguage(Locale(languageCode));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(languageName, style: AppTextStyles.bodyLarge),
            const Spacer(),
            if (currentLanguage == languageCode)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
