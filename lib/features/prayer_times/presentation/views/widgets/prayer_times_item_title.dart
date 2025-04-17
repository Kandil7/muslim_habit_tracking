import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/bloc/language_cubit.dart';
import '/core/utils/colors.dart';
import '/core/utils/helper.dart';
import '/core/utils/styles.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';

import '../../../data/models/prayer_item_model.dart';

class PrayerTimesItemTitle extends StatelessWidget {
  const PrayerTimesItemTitle({
    super.key,
    required this.prayerItemModel,
    required this.isNextPrayer,
  });

  final PrayerItemModel prayerItemModel;

  final bool isNextPrayer;

  @override
  Widget build(BuildContext context) {
    final local =
        context.read<LanguageCubit>().state.locale.languageCode == 'ar';
    return Flexible(
      child: Row(
        children: [
          Image.asset(prayerItemModel.prayerImage, height: 22, width: 20),
          const SizedBox(width: 10),
          Text(
            local ? prayerItemModel.arName : prayerItemModel.enName,
            style: Styles.medium14.copyWith(
              color: isNextPrayer ? AppColors.whiteColor : null,
            ),
          ),
          Spacer(),
          Text(
            local
                ? Helper.convertToArabicNumbers(prayerItemModel.prayerTime)
                : prayerItemModel.prayerTime,
            style: Styles.medium14.copyWith(
              color: isNextPrayer ? AppColors.whiteColor : null,
            ),
          ),
          Spacer(),
          Text(
            context.tr.translate('prayer.time'),
            style: Styles.medium14.copyWith(
              color: isNextPrayer ? AppColors.whiteColor : null,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
