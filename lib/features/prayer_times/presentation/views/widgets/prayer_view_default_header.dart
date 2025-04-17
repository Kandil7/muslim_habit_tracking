import 'package:flutter/material.dart';
import '/core/utils/assets.dart';

import 'prayer_view_header_app_name.dart';

class PrayerViewDefaultHeader extends StatelessWidget {
  const PrayerViewDefaultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.imagesMosque),
        ),
      ),
      child: PrayerViewHeaderAppName(),
    );
  }
}
