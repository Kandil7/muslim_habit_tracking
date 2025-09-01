import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';

/// Card widget showing overall memorization progress with enhanced UI
class MemorizationProgressCard extends StatelessWidget {
  const MemorizationProgressCard({super.key});

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
                    'Your Memorization Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enhanced progress visualization
                  _ProgressVisualization(
                    percentage: stats.memorizationPercentage,
                    totalPages: stats.totalPagesMemorized,
                  ),
                  const SizedBox(height: 20),
                  // Status breakdown with improved design
                  const Text(
                    'Status Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StatusBreakdown(stats: stats),
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

/// Enhanced progress visualization widget
class _ProgressVisualization extends StatelessWidget {
  final double percentage;
  final int totalPages;

  const _ProgressVisualization({
    required this.percentage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(percentage),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getProgressColor(percentage).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$totalPages Pages Memorized',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _getProgressColor(percentage),
            ),
          ),
        ),
      ],
    );
  }

  /// Get progress color based on percentage
  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.blue;
  }
}

/// Status breakdown visualization
class _StatusBreakdown extends StatelessWidget {
  final MemorizationStatistics stats;

  const _StatusBreakdown({required this.stats});

  @override
  Widget build(BuildContext context) {
    final newCount = stats.itemsByStatus[MemorizationStatus.newStatus] ?? 0;
    final inProgressCount = stats.itemsByStatus[MemorizationStatus.inProgress] ?? 0;
    final memorizedCount = stats.itemsByStatus[MemorizationStatus.memorized] ?? 0;
    final archivedCount = stats.itemsByStatus[MemorizationStatus.archived] ?? 0;
    
    final totalCount = newCount + inProgressCount + memorizedCount + archivedCount;

    return Column(
      children: [
        // Progress bars for each status
        _StatusProgressBar(
          label: 'New',
          count: newCount,
          totalCount: totalCount,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _StatusProgressBar(
          label: 'In Progress',
          count: inProgressCount,
          totalCount: totalCount,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _StatusProgressBar(
          label: 'Memorized',
          count: memorizedCount,
          totalCount: totalCount,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _StatusProgressBar(
          label: 'Archived',
          count: archivedCount,
          totalCount: totalCount,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        // Summary row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatusIndicator(
              count: newCount,
              label: 'New',
              color: Colors.blue,
            ),
            _StatusIndicator(
              count: inProgressCount,
              label: 'In Progress',
              color: Colors.orange,
            ),
            _StatusIndicator(
              count: memorizedCount,
              label: 'Memorized',
              color: Colors.green,
            ),
            _StatusIndicator(
              count: archivedCount,
              label: 'Archived',
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}

/// Progress bar for a specific status
class _StatusProgressBar extends StatelessWidget {
  final String label;
  final int count;
  final int totalCount;
  final Color color;

  const _StatusProgressBar({
    required this.label,
    required this.count,
    required this.totalCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalCount > 0 ? count / totalCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count items',
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
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

/// Widget showing status indicator with count
class _StatusIndicator extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatusIndicator({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}