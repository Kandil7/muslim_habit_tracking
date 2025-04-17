import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/helper.dart';
import 'package:muslim_habbit/core/localization/bloc/language_bloc_exports.dart';

import '../../../data/models/prayer_item_model.dart';
import 'prayer_time_remaining_widget.dart';
import 'prayer_times_interval_widget.dart';

class PrayerTimesItemTrailing extends StatelessWidget {
  const PrayerTimesItemTrailing({
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          // PrayerTimeRemainingWidget(
          //     time: Helper.formatRemaingTime(
          //         prayerItemModel.remainingTime.inSeconds,
          //         local: local)),
          // const PrayerTimesIntervalWidget(),
          PrayerTimeRemainingWidget(
            time: Helper.formatRemaingTime(
              prayerItemModel.remainingTime.inMinutes,
              local: local,
            ),
          ),
          const PrayerTimesIntervalWidget(),
          PrayerTimeRemainingWidget(
            time:
                prayerItemModel.isPrayerPassed
                    ? "${Helper.formatRemaingTime(prayerItemModel.remainingTime.inHours, local: local)}-"
                    : Helper.formatRemaingTime(
                      prayerItemModel.remainingTime.inHours,
                      local: local,
                    ),
          ),
        ],
      ),
    );
  }
}
