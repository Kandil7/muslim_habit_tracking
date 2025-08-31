import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';

class StreakVisualization extends StatelessWidget {
  final List<HabitStats> habitStats;

  const StreakVisualization({
    super.key,
    required this.habitStats,
  });

  @override
  Widget build(BuildContext context) {
    if (habitStats.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort by current streak descending
    final sortedStats = List<HabitStats>.from(habitStats)
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

    final topStreaks = sortedStats.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Streaks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...topStreaks.map((stats) {
            return _buildStreakItem(stats);
          }),
        ],
      ),
    );
  }

  Widget _buildStreakItem(HabitStats stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStreakColor(stats.currentStreak),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${stats.currentStreak}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stats.habitName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Longest: ${stats.longestStreak} days',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_fire_department,
            color: _getStreakColor(stats.currentStreak),
          ),
        ],
      ),
    );
  }

  Color _getStreakColor(int streak) {
    if (streak >= 30) {
      return Colors.red;
    } else if (streak >= 14) {
      return Colors.orange;
    } else if (streak >= 7) {
      return Colors.yellow;
    } else {
      return Colors.blue;
    }
  }
}