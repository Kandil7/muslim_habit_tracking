import 'package:flutter/material.dart';

import 'prayer_view_default_header.dart';

class PrayerViewHeaderNoAds extends StatelessWidget {
  const PrayerViewHeaderNoAds({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        PrayerViewDefaultHeader(),
        // PrayerViewHeaderShare(),
      ],
    );
  }
}
