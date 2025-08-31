import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Page for daily review of memorization items
class DailyReviewPage extends StatefulWidget {
  const DailyReviewPage({super.key});

  @override
  State<DailyReviewPage> createState() => _DailyReviewPageState();
}

class _DailyReviewPageState extends State<DailyReviewPage> {
  @override
  void initState() {
    super.initState();
    // Load the daily review schedule
    context.read<MemorizationBloc>().add(LoadDailyReviewSchedule());
  }

  /// Mark an item as reviewed
  void _markItemAsReviewed(String itemId) {
    context.read<MemorizationBloc>().add(MarkItemAsReviewedEvent(itemId));
    
    // Show haptic feedback if enabled
    final preferencesState = context.read<MemorizationBloc>().state;
    if (preferencesState is MemorizationPreferencesLoaded) {
      final preferences = preferencesState.preferences;
      if (preferences.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Review'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MemorizationBloc>().add(LoadDailyReviewSchedule());
            },
          ),
        ],
      ),
      body: BlocBuilder<MemorizationBloc, MemorizationState>(
        builder: (context, state) {
          if (state is DailyReviewScheduleLoaded) {
            final schedule = state.schedule;
            return _buildReviewContent(schedule);
          } else if (state is MemorizationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemorizationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MemorizationBloc>().add(LoadDailyReviewSchedule());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// Build the review content based on the schedule
  Widget _buildReviewContent(ReviewSchedule schedule) {
    if (schedule.dailyItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'All caught up!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You have completed all your reviews for today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Progress header
        _buildProgressHeader(schedule.progressStats),
        const SizedBox(height: 16),
        // Priority indicator
        _buildPriorityIndicator(),
        const SizedBox(height: 16),
        // Review items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: schedule.prioritizedItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = schedule.prioritizedItems[index];
              return _buildReviewItem(item, index, schedule.prioritizedItems.length);
            },
          ),
        ),
      ],
    );
  }

  /// Build the progress header
  Widget _buildProgressHeader(ReviewProgressStats stats) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: stats.completionPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(stats.completionPercentage),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${stats.completedItems}/${stats.totalItems} completed'),
                Text('${stats.completionPercentage.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get progress color based on percentage
  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.blue;
  }

  /// Build the priority indicator
  Widget _buildPriorityIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('High Priority', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 16),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Medium Priority', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 16),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Low Priority', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Build a review item with priority indicator
  Widget _buildReviewItem(MemorizationItem item, int index, int totalItems) {
    // Determine priority color based on position
    Color priorityColor;
    if (index < (totalItems * 0.3).ceil()) {
      // Top 30% - High priority (red)
      priorityColor = Colors.red;
    } else if (index < (totalItems * 0.7).ceil()) {
      // Middle 40% - Medium priority (orange)
      priorityColor = Colors.orange;
    } else {
      // Bottom 30% - Low priority (green)
      priorityColor = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority indicator
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.surahName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(item.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Pages ${item.startPage}-${item.endPage}'),
            const SizedBox(height: 8),
            Text(
              item.reviewStatusMessage,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to surah view
                    },
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _markItemAsReviewed(item.id);
                    },
                    child: const Text('Mark as Reviewed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build a status chip
  Widget _buildStatusChip(MemorizationStatus status) {
    String text;
    Color color;
    
    switch (status) {
      case MemorizationStatus.newStatus:
        text = 'New';
        color = Colors.blue;
        break;
      case MemorizationStatus.inProgress:
        text = 'In Progress';
        color = Colors.orange;
        break;
      case MemorizationStatus.memorized:
        text = 'Memorized';
        color = Colors.green;
        break;
      case MemorizationStatus.archived:
        text = 'Archived';
        color = Colors.grey;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}