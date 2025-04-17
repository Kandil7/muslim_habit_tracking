import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../../core/theme/app_theme.dart';
import 'animated_dashboard_card.dart';

/// Card widget for Islamic calendar
class IslamicCalendarCard extends StatelessWidget {
  final VoidCallback? onReorder;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;
  final bool isReorderable;

  const IslamicCalendarCard({
    super.key,
    this.onReorder,
    this.onVisibilityToggle,
    this.isVisible = true,
    this.isReorderable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get current Hijri date
    final HijriCalendar today = HijriCalendar.now();
    final String hijriDate = '${today.hDay} ${today.hMonth} ${today.hYear}';
    final String hijriMonthName = _getHijriMonthName(today.hMonth);
    
    // Get current Gregorian date
    final DateTime now = DateTime.now();
    final String gregorianDate = DateFormat('d MMMM yyyy').format(now);
    
    // Check if today is a significant Islamic date
    final String? specialDay = _getSpecialIslamicDay(today);
    
    return AnimatedDashboardCard(
      title: 'Islamic Calendar',
      icon: Icons.calendar_today,
      iconColor: AppColors.tertiary,
      isReorderable: isReorderable,
      onReorder: onReorder,
      onVisibilityToggle: onVisibilityToggle,
      isVisible: isVisible,
      onTap: () {
        // Navigate to Islamic calendar page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Islamic Calendar feature coming soon!'),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  context,
                  title: 'Hijri',
                  date: hijriDate,
                  subtitle: hijriMonthName,
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateCard(
                  context,
                  title: 'Gregorian',
                  date: gregorianDate,
                  subtitle: DateFormat('EEEE').format(now),
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          if (specialDay != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.tertiary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: AppColors.tertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      specialDay,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                context,
                icon: Icons.event,
                label: 'Events',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Islamic Events feature coming soon!'),
                    ),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.calendar_month,
                label: 'Full Calendar',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Full Calendar feature coming soon!'),
                    ),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.notifications_outlined,
                label: 'Reminders',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminders feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateCard(
    BuildContext context, {
    required String title,
    required String date,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: AppTextStyles.headingSmall.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.tertiary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
  
  String _getHijriMonthName(int month) {
    const List<String> monthNames = [
      'Muharram',
      'Safar',
      'Rabi\' al-Awwal',
      'Rabi\' al-Thani',
      'Jumada al-Awwal',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
    
    return monthNames[month - 1];
  }
  
  String? _getSpecialIslamicDay(HijriCalendar date) {
    // Check for special Islamic days
    if (date.hMonth == 9) {
      // Ramadan
      return 'Ramadan - The month of fasting';
    } else if (date.hMonth == 12 && date.hDay >= 8 && date.hDay <= 13) {
      // Hajj
      return 'Hajj period';
    } else if (date.hMonth == 12 && date.hDay == 10) {
      // Eid al-Adha
      return 'Eid al-Adha';
    } else if (date.hMonth == 10 && date.hDay == 1) {
      // Eid al-Fitr
      return 'Eid al-Fitr';
    } else if (date.hMonth == 1 && date.hDay == 10) {
      // Ashura
      return 'Ashura';
    } else if (date.hMonth == 3 && date.hDay == 12) {
      // Mawlid al-Nabi
      return 'Mawlid al-Nabi (Birth of Prophet Muhammad ﷺ)';
    } else if (date.hMonth == 7 && date.hDay == 27) {
      // Laylat al-Miraj
      return 'Laylat al-Miraj (Night Journey of Prophet Muhammad ﷺ)';
    } else if (date.hMonth == 8 && date.hDay == 15) {
      // Laylat al-Bara'at
      return 'Laylat al-Bara\'at (Night of Forgiveness)';
    } else if (date.hMonth == 9 && date.hDay == 27) {
      // Laylat al-Qadr
      return 'Laylat al-Qadr (Night of Power)';
    }
    
    return null;
  }
}
