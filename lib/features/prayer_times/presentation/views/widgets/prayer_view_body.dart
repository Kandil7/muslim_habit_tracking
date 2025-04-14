import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/prayer_times/presentation/views/widgets/prayer_view_header_no_ads.dart';

import 'prayer_date_hijri_and_milad.dart';
import 'prayer_times_header.dart';
import 'prayer_times_list_view.dart';
import 'prayer_view_header.dart';

class PrayerViewBody extends StatelessWidget {
  const PrayerViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const PrayerViewHeaderNoAds(),
            const SizedBox(height: 12),
            const PrayerTimesHeader(),
            const SizedBox(height: 4),
            const PrayerDateHijriAndMilad(),
            const SizedBox(height: 20),
            const PrayerTimesListView()
          ],
        ),
      ),
    );
  }
}
