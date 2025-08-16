import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../habit_tracking/domain/entities/habit.dart';
import 'dashboard_card.dart';

/// Card widget displaying habits summary
class HabitsSummaryCard extends StatelessWidget {
  final List<Habit> habits;

  const HabitsSummaryCard({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final activeHabits = habits.where((h) => h.isActive).length;
    final completedToday =
        0; // This would come from habit logs in a real implementation
    final streakHabits = habits.where((h) => h.currentStreak > 0).length;

    return DashboardCard(
      title: 'Habits',
      icon: AppIcons.home,
      onTap: () {
        // Navigate to habits page or switch to home tab
        // This would be handled by the parent HomePage
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                value: activeHabits.toString(),
                label: 'Active',
                icon: Icons.check_circle_outline,
                color: AppColors.primary,
              ),
              _buildStatItem(
                context,
                value: '$completedToday/$activeHabits',
                label: 'Today',
                icon: Icons.today,
                color: AppColors.secondary,
              ),
              _buildStatItem(
                context,
                value: streakHabits.toString(),
                label: 'Streaks',
                icon: Icons.local_fire_department,
                color: AppColors.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Habits list
          if (habits.isEmpty)
            const Center(child: Text('No habits yet. Add your first habit!'))
          else
            Column(
              children: [
                for (int i = 0; i < habits.length; i++)
                  if (i < 3) // Show only first 3 habits to save space
                    _buildHabitItem(context, habits[i]),
                if (habits.length > 3)
                  TextButton(
                    onPressed: () {
                      // Navigate to habits page or switch to home tab
                      // This would be handled by the parent HomePage
                    },
                    child: const Text('View All Habits'),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.headingSmall),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitItem(BuildContext context, Habit habit) {
    // Check if habit is completed today
    // final now = DateTime.now();
    final isCompletedToday =
        false; // This would come from habit logs in a real implementation

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(int.parse('0xFF${habit.color.substring(1)}')),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getIconForHabitType(habit.type),
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (habit.currentStreak > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: AppColors.secondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak} day streak',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Checkbox(
            value: isCompletedToday,
            onChanged: (value) {
              // Mark habit as completed
              // This would be handled by the parent HomePage
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  IconData _getIconForHabitType(String type) {
    switch (type) {
      case 'prayer':
        return Icons.mosque;
      case 'quran':
        return Icons.menu_book;
      case 'fasting':
        return Icons.no_food;
      case 'dhikr':
        return Icons.repeat;
      case 'charity':
        return Icons.volunteer_activism;
      default:
        return Icons.check_circle_outline;
    }
  }
}
