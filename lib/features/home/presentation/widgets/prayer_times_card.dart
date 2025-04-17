import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../prayer_times/data/models/prayer_item_model.dart';
import 'dashboard_card.dart';

/// Card widget displaying prayer times
class PrayerTimesCard extends StatelessWidget {
  final List<PrayerItemModel> prayerList;
  final String nextPrayer;

  const PrayerTimesCard({
    super.key,
    required this.prayerList,
    required this.nextPrayer,
  });

  @override
  Widget build(BuildContext context) {
    // Find the next prayer
    PrayerItemModel? nextPrayerItem;
    if (prayerList.isNotEmpty) {
      nextPrayerItem = prayerList.firstWhere(
        (prayer) => !prayer.isPrayerPassed,
        orElse: () => prayerList.first,
      );
    }

    return DashboardCard(
      title: 'Prayer Times',
      icon: AppIcons.prayer,
      onTap: () {
        // Navigate to prayer times page or switch to prayer tab
        // This would be handled by the parent HomePage
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nextPrayerItem != null) ...[
            _buildNextPrayerSection(nextPrayerItem),
            const Divider(height: 32),
          ],
          _buildPrayerTimesList(),
        ],
      ),
    );
  }

  Widget _buildNextPrayerSection(PrayerItemModel nextPrayer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next Prayer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.access_time, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nextPrayer.enName, style: AppTextStyles.headingSmall),
                Text(
                  nextPrayer.prayerTime,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Remaining',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatRemainingTime(nextPrayer.remainingTime),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerTimesList() {
    return Column(
      children: [
        for (int i = 0; i < prayerList.length; i++)
          if (i < 3) // Show only first 3 prayers to save space
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _getPrayerColor(
                            prayerList[i].enName,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          _getPrayerIcon(prayerList[i].enName),
                          color: _getPrayerColor(prayerList[i].enName),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(prayerList[i].enName),
                    ],
                  ),
                  Text(prayerList[i].prayerTime),
                ],
              ),
            ),
        if (prayerList.length > 3)
          TextButton(
            onPressed: () {
              // Navigate to prayer times page or switch to prayer tab
              // This would be handled by the parent HomePage
            },
            child: const Text('View All Prayer Times'),
          ),
      ],
    );
  }

  String _formatRemainingTime(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.sunny;
      case 'asr':
        return Icons.sunny_snowing;
      case 'maghrib':
        return Icons.nights_stay_outlined;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return AppColors.fajrColor;
      case 'sunrise':
        return AppColors.asrColor;
      case 'dhuhr':
        return AppColors.dhuhrColor;
      case 'asr':
        return AppColors.asrColor;
      case 'maghrib':
        return AppColors.maghribColor;
      case 'isha':
        return AppColors.ishaColor;
      default:
        return AppColors.primary;
    }
  }
}
