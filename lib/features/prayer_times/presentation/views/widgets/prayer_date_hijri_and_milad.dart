import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/localization/bloc/language_bloc_exports.dart';
import '/core/utils/helper.dart';

class PrayerDateHijriAndMilad extends StatelessWidget {
  const PrayerDateHijriAndMilad({super.key});

  @override
  Widget build(BuildContext context) {
    final local =
        context.watch<LanguageCubit>().state.locale.languageCode == 'ar';
    return Row(
      children: [
        SizedBox(width: local ? 50 : 60),
        Flexible(
          child: FittedBox(
            child: Text(Helper.formatDateTime(local ? 'ar' : 'en')),
          ),
        ),
      ],
    );
  }
}
