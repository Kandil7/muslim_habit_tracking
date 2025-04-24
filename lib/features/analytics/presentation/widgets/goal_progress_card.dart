import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';

/// A widget that displays goal progress for a habit
class GoalProgressCard extends StatelessWidget {
  /// The habit statistics
  final HabitStats habitStats;

  /// Creates a goal progress card widget
  const GoalProgressCard({super.key, required this.habitStats});

  @override
  Widget build(BuildContext context) {
    // If no goals are set, show a message
    if (habitStats.targetStreak == null &&
        habitStats.targetCompletionRate == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goals', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              const Center(child: Text('No goals set for this habit')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showGoalSettingDialog(context);
                },
                child: const Text('Set a Goal'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Goals', style: Theme.of(context).textTheme.titleLarge),
                Icon(
                  habitStats.hasReachedGoal ? Icons.emoji_events : Icons.flag,
                  color:
                      habitStats.hasReachedGoal
                          ? AppColors.success
                          : AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (habitStats.targetStreak != null) ...[
              _buildGoalProgress(
                context,
                'Streak Goal',
                habitStats.currentStreak,
                habitStats.targetStreak!,
                habitStats.currentStreak >= habitStats.targetStreak!,
                Icons.local_fire_department,
              ),
              const SizedBox(height: 16),
            ],
            if (habitStats.targetCompletionRate != null) ...[
              _buildGoalProgress(
                context,
                'Completion Rate Goal',
                habitStats.completionRate.toInt(),
                habitStats.targetCompletionRate!.toInt(),
                habitStats.completionRate >= habitStats.targetCompletionRate!,
                Icons.percent,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgress(
    BuildContext context,
    String title,
    int current,
    int target,
    bool isAchieved,
    IconData icon,
  ) {
    final progress = current / target;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: isAchieved ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: clampedProgress,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isAchieved ? AppColors.success : AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Current: $current'), Text('Target: $target')],
        ),
        if (isAchieved) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                'Goal Achieved!',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showGoalSettingDialog(BuildContext context) {
    // These variables would be used in a real implementation
    // to pass to the bloc event
    int? streakGoal;
    double? completionRateGoal;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Set Goals'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Streak Goal (days)',
                    hintText: 'e.g., 7, 30, 90',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      streakGoal = int.tryParse(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Completion Rate Goal (%)',
                    hintText: 'e.g., 80, 90, 100',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      completionRateGoal = double.tryParse(value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Here you would call a method to save the goals
                  // For example:
                  // context.read<AnalyticsBloc>().add(
                  //   SetHabitGoalEvent(
                  //     habitId: habitStats.habitId,
                  //     targetStreak: streakGoal,
                  //     targetCompletionRate: completionRateGoal,
                  //   ),
                  // );

                  // In a real app, we would log these values or use them directly
                  // Logger.log('Streak Goal: $streakGoal');
                  // Logger.log('Completion Rate Goal: $completionRateGoal');

                  // For now, just show a success message
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Goals updated: Streak=${streakGoal ?? "not set"}, Completion Rate=${completionRateGoal ?? "not set"}%',
                      ),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
