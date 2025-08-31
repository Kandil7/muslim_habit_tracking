import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/bloc/enhanced_dashboard_bloc.dart';

/// Widget showing task progress with visual indicators
class TaskProgressWidget extends StatelessWidget {
  final TaskProgress progressData;

  const TaskProgressWidget({super.key, required this.progressData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Overall completion progress
            _buildOverallProgress(),
            const SizedBox(height: 20),
            // Category completion
            const Text(
              'By Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...progressData.categoryCompletion.entries.map((entry) => _CategoryProgress(
              category: entry.key,
              progress: entry.value,
            )).toList(),
            const SizedBox(height: 20),
            // Streak tracking
            _buildStreakTracking(),
          ],
        ),
      ),
    );
  }

  /// Build overall progress visualization
  Widget _buildOverallProgress() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: progressData.overallCompletion / 100,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${progressData.overallCompletion.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Overall Progress',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build streak tracking section
  Widget _buildStreakTracking() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StreakItem(
            value: '${progressData.currentStreak}',
            label: 'Current\nStreak',
            icon: Icons.local_fire_department,
            color: Colors.orange,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          _StreakItem(
            value: '${progressData.longestStreak}',
            label: 'Longest\nStreak',
            icon: Icons.emoji_events,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying category progress
class _CategoryProgress extends StatelessWidget {
  final String category;
  final double progress;

  const _CategoryProgress({
    required this.category,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    if (progress >= 75) {
      progressColor = Colors.green;
    } else if (progress >= 50) {
      progressColor = Colors.blue;
    } else if (progress >= 25) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying streak information
class _StreakItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StreakItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}