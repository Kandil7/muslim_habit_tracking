import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import '/core/utils/styles.dart';

class PrayerTimeRemainingWidget extends StatelessWidget {
  const PrayerTimeRemainingWidget({super.key, required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: FittedBox(child: Text(time, style: Styles.medium12)),
      ),
    );
  }
}
