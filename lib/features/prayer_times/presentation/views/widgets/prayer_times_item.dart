import 'package:flutter/material.dart';
import '/core/utils/colors.dart';

import '../../../data/models/prayer_item_model.dart';
import 'prayer_times_item_title.dart';
import 'prayer_times_item_trailing.dart';

class PrayerTimesItem extends StatelessWidget {
  const PrayerTimesItem(
      {super.key, required this.prayerItemModel, required this.isNextPrayer});
  final PrayerItemModel prayerItemModel;
  final bool isNextPrayer;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isNextPrayer ? AppColors.primaryColor2 : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                blurRadius: isNextPrayer ? 0 : 15,
                color: isNextPrayer
                    ? Colors.transparent
                    : AppColors.blackColor.withValues(alpha: .15))
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            PrayerTimesItemTitle(
                prayerItemModel: prayerItemModel, isNextPrayer: isNextPrayer),
            PrayerTimesItemTrailing(
                prayerItemModel: prayerItemModel, isNextPrayer: isNextPrayer),
            const SizedBox(width: 10),
          ],
        ));
  }
}
