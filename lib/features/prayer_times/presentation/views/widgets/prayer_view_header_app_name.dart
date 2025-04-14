import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/bloc/language_cubit.dart';
import '../../../../../core/localization/bloc/language_state.dart';
import '../../../data/models/app_name_model.dart';
import 'arabic_and_english_app_name.dart';

class PrayerViewHeaderAppName extends StatelessWidget {
  const PrayerViewHeaderAppName({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        if (context.read<LanguageCubit>().state.locale.languageCode == 'ar') {
          return ArabicAndEnglihAppName(
            appNameModel:
                AppNameModel(right: width <= 375 ? 74 : 94, isArabic: true),
          );
        }
        return ArabicAndEnglihAppName(
          appNameModel: AppNameModel(
              top: width <= 375 ? 24 : 24, left: width <= 375 ? 30 : 54),
        );
      },
    );
  }
}
