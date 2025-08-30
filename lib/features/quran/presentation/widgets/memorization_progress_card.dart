import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Card widget showing overall memorization progress
class MemorizationProgressCard extends StatelessWidget {
  const MemorizationProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MemorizationBloc, MemorizationState>(
          builder: (context, state) {
            if (state is MemorizationStatisticsLoaded) {
              final stats = state.statistics;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  LinearProgressIndicator(
                    value: stats.memorizationPercentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(stats.memorizationPercentage),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${stats.memorizationPercentage.toStringAsFixed(1)}% Complete'),
                      Text('${stats.totalPagesMemorized} Pages'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Status breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatusIndicator(
                        count: stats.itemsByStatus[MemorizationStatus.newStatus] ?? 0,
                        label: 'New',
                        color: Colors.blue,
                      ),
                      _StatusIndicator(
                        count: stats.itemsByStatus[MemorizationStatus.inProgress] ?? 0,
                        label: 'In Progress',
                        color: Colors.orange,
                      ),
                      _StatusIndicator(
                        count: stats.itemsByStatus[MemorizationStatus.memorized] ?? 0,
                        label: 'Memorized',
                        color: Colors.green,
                      ),
                    ],
                  ),
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

  /// Get progress color based on percentage
  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.blue;
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text('$count'),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}