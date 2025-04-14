import 'package:flutter/material.dart';
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
          color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(2)),
      child: Center(
        child: FittedBox(child: Text(time, style: Styles.medium12)),
      ),
    );
  }
}
