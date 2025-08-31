import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Widget showing a single item in the daily review list with enhanced UI
class DailyReviewItemWidget extends StatelessWidget {
  final MemorizationItem item;

  const DailyReviewItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.isOverdue;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to review details page
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getStatusIcon(item.status),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.surahName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Overdue',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pages ${item.startPage}-${item.endPage}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              _getProgressIndicator(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.status != MemorizationStatus.archived)
                    ElevatedButton(
                      onPressed: () {
                        // Mark item as reviewed
                        context.read<MemorizationBloc>().add(MarkItemAsReviewedEvent(item.id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(item.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Review'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get status icon based on item status
  Widget _getStatusIcon(MemorizationStatus status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case MemorizationStatus.newStatus:
        color = Colors.blue;
        icon = Icons.fiber_new;
        break;
      case MemorizationStatus.inProgress:
        color = Colors.orange;
        icon = Icons.hourglass_bottom;
        break;
      case MemorizationStatus.memorized:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case MemorizationStatus.archived:
        color = Colors.grey;
        icon = Icons.archive;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  /// Get progress indicator based on item status
  Widget _getProgressIndicator() {
    switch (item.status) {
      case MemorizationStatus.newStatus:
        return const Text(
          'New item - Start reviewing to begin memorization',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        );
      case MemorizationStatus.inProgress:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress: ${item.consecutiveReviewDays}/5 days',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.streakCompletionPercentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 6,
              ),
            ),
          ],
        );
      case MemorizationStatus.memorized:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Memorized',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last reviewed: ${_formatDate(item.lastReviewed)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        );
      case MemorizationStatus.archived:
        return const Text(
          'Archived - No further reviews needed',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        );
    }
  }

  /// Get button color based on item status
  Color _getButtonColor(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return Colors.blue;
      case MemorizationStatus.inProgress:
        return Colors.orange;
      case MemorizationStatus.memorized:
        return Colors.green;
      case MemorizationStatus.archived:
        return Colors.grey;
    }
  }

  /// Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}