import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';

/// Card widget showing statistics summary with enhanced UI
class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<MemorizationBloc, MemorizationState>(
          builder: (context, state) {
            if (state is MemorizationStatisticsLoaded) {
              final stats = state.statistics;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enhanced stats grid
                  _EnhancedStatsGrid(stats: stats),
                ],
              );
            } else if (state is MemorizationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MemorizationError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

/// Enhanced statistics grid with better visual design
class _EnhancedStatsGrid extends StatelessWidget {
  final MemorizationStatistics stats;

  const _EnhancedStatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - streak stats
        Row(
          children: [
            Expanded(
              child: _EnhancedStatItem(
                value: stats.currentStreak.toString(),
                label: 'Current Streak',
                icon: Icons.local_fire_department,
                color: Colors.orange,
                isHighlighted: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EnhancedStatItem(
                value: stats.longestStreak.toString(),
                label: 'Longest Streak',
                icon: Icons.emoji_events,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row - item stats
        Row(
          children: [
            Expanded(
              child: _EnhancedStatItem(
                value: stats.totalItems.toString(),
                label: 'Total Items',
                icon: Icons.book,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EnhancedStatItem(
                value: stats.totalReviews.toString(),
                label: 'Total Reviews',
                icon: Icons.refresh,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Third row - additional stats
        Row(
          children: [
            Expanded(
              child: _EnhancedStatItem(
                value: stats.averageReviewsPerDay.toStringAsFixed(1),
                label: 'Avg Reviews/Day',
                icon: Icons.trending_up,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EnhancedStatItem(
                value: stats.overdueItemsCount.toString(),
                label: 'Overdue Items',
                icon: Icons.warning,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Enhanced statistic item with better visual design
class _EnhancedStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  const _EnhancedStatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? color.withValues(alpha: 0.3) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isHighlighted ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? color : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isHighlighted ? color : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}