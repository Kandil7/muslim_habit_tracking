import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/bloc/enhanced_dashboard_bloc.dart';

/// Widget showing upcoming reminders with smart prioritization
class UpcomingRemindersWidget extends StatelessWidget {
  final List<UpcomingReminder> reminders;

  const UpcomingRemindersWidget({super.key, required this.reminders});

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
              'Upcoming Reminders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (reminders.isEmpty)
              const Center(
                child: Text(
                  'No upcoming reminders',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...reminders.map((reminder) => _ReminderItem(reminder: reminder)),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying a single reminder item
class _ReminderItem extends StatelessWidget {
  final UpcomingReminder reminder;

  const _ReminderItem({required this.reminder});

  @override
  Widget build(BuildContext context) {
    // Get icon and color based on reminder type
    IconData icon;
    Color color;
    switch (reminder.type) {
      case 'prayer':
        icon = Icons.access_time;
        color = Colors.blue;
        break;
      case 'quran':
        icon = Icons.menu_book;
        color = Colors.green;
        break;
      case 'habit':
        icon = Icons.check_circle;
        color = Colors.purple;
        break;
      case 'skill':
        icon = Icons.computer;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    reminder.time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimeUntil(reminder.minutesUntil),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _getTimeColor(reminder.minutesUntil),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${reminder.minutesUntil} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Format time until reminder
  String _formatTimeUntil(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours h';
      } else {
        return '$hours h $remainingMinutes m';
      }
    }
  }

  /// Get color based on time until reminder
  Color _getTimeColor(int minutes) {
    if (minutes <= 15) {
      return Colors.red;
    } else if (minutes <= 30) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}