import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Widget showing the list of items for daily review with enhanced UI
class DailyReviewList extends StatelessWidget {
  const DailyReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemorizationBloc, MemorizationState>(
      builder: (context, state) {
        if (state is DailyReviewScheduleLoaded) {
          final items = state.schedule.dailyItems;
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No items to review today',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add new items to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _ReviewItemCard(item: items[index]);
            },
          );
        } else if (state is MemorizationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MemorizationError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// Enhanced card for displaying a review item
class _ReviewItemCard extends StatelessWidget {
  final MemorizationItem item;

  const _ReviewItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.isOverdue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Handle item tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Surah name and pages
                  Expanded(
                    child: Text(
                      '${item.surahName} (${item.startPage}-${item.endPage})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Overdue indicator
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
              // Progress information
              Row(
                children: [
                  if (item.status == MemorizationStatus.inProgress) ...[
                    Text(
                      '${item.consecutiveReviewDays}/5 days',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: item.streakCompletionPercentage / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ] else if (item.status == MemorizationStatus.memorized) ...[
                    Text(
                      'Memorized',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last reviewed: ${_formatDate(item.lastReviewed)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'New item',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get color based on item status
  Color _getStatusColor(MemorizationStatus status) {
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