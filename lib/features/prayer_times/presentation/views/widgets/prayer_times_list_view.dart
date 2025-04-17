import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/prayer/prayer_cubit.dart';
import 'prayer_times_item.dart';

class PrayerTimesListView extends StatelessWidget {
  const PrayerTimesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final prayer = context.read<PrayerCubit>();
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        return Column(
          spacing: 5,
          children: prayer.prayerList
              .map((e) => PrayerTimesItem(
                    prayerItemModel: e,
                    isNextPrayer: prayer.nextPrayer == e.prayerTime,
                  ))
              .toList(),
        );
      },
    );
  }
}
