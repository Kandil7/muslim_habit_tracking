import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Card widget showing statistics summary
class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({super.key});

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
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        value: '${stats.currentStreak}',
                        label: 'Current Streak',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      _StatItem(
                        value: '${stats.longestStreak}',
                        label: 'Longest Streak',
                        icon: Icons.emoji_events,
                        color: Colors.purple,
                      ),
                      _StatItem(
                        value: '${stats.totalItems}',
                        label: 'Total Items',
                        icon: Icons.book,
                        color: Colors.blue,
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
}

/// Widget showing a single statistic item
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
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
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}