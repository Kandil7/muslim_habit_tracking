import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/bloc/language_cubit.dart';
import '/core/utils/assets.dart';
import '/core/utils/styles.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';

class PrayerTimesHeader extends StatelessWidget {
  const PrayerTimesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LanguageCubit>().state.locale.languageCode == 'ar';
    return Row(
      spacing: 4,
      children: [
        const SizedBox(width: 16),
        Image.asset(Assets.imagesTime, height: 30, width: 30),
        if (!local) const SizedBox(width: 4),
        Text(context.tr.translate('prayer.title'),
            style: Styles.medium18)
      ],
    );
  }
}
