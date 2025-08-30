import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Page to display detailed memorization statistics
class MemorizationStatisticsPage extends StatefulWidget {
  const MemorizationStatisticsPage({super.key});

  @override
  State<MemorizationStatisticsPage> createState() => _MemorizationStatisticsPageState();
}

class _MemorizationStatisticsPageState extends State<MemorizationStatisticsPage> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<MemorizationBloc>().add(LoadMemorizationStatistics());
    context.read<MemorizationBloc>().add(LoadDetailedStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Statistics'),
      ),
      body: BlocBuilder<MemorizationBloc, MemorizationState>(
        builder: (context, state) {
          if (state is MemorizationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemorizationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MemorizationStatisticsLoaded &&
              state is DetailedStatisticsLoaded) {
            // This won't work as intended, we need to handle both states
            return _buildStatisticsContent(context, state.statistics, null);
          } else if (state is MemorizationStatisticsLoaded) {
            return _buildStatisticsContent(context, state.statistics, null);
          } else if (state is DetailedStatisticsLoaded) {
            return _buildStatisticsContent(context, null, state.detailedStatistics);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildStatisticsContent(BuildContext context,
      MemorizationStatistics? stats, DetailedMemorizationStatistics? detailedStats) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall statistics cards
            if (stats != null) ...[
              _buildStatCard('Total Items', stats.totalItems.toString()),
              const SizedBox(height: 16),
              _buildStatCard('Memorized Items', 
                  '${stats.itemsByStatus[MemorizationStatus.memorized] ?? 0} '
                  '(${stats.memorizationPercentage.toStringAsFixed(1)}%)'),
              const SizedBox(height: 16),
              _buildStatCard('Current Streak', '${stats.currentStreak} days'),
              const SizedBox(height: 16),
              _buildStatCard('Longest Streak', '${stats.longestStreak} days'),
              const SizedBox(height: 16),
              _buildStatCard('Total Reviews', stats.totalReviews.toString()),
              const SizedBox(height: 16),
              _buildStatCard('Avg. Reviews/Day', 
                  stats.averageReviewsPerDay.toStringAsFixed(2)),
            ],
            
            const SizedBox(height: 32),
            
            // Progress over time chart
            const Text(
              'Progress Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (detailedStats != null)
              _buildProgressChart(detailedStats.progressOverTime),
            
            const SizedBox(height: 32),
            
            // Review frequency chart
            const Text(
              'Review Frequency by Day',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (detailedStats != null)
              _buildReviewFrequencyChart(detailedStats.reviewFrequencyByDay),
            
            const SizedBox(height: 32),
            
            // Additional statistics
            if (detailedStats != null) ...[
              _buildStatCard('Average Streak Length', 
                  detailedStats.averageStreakLength.toStringAsFixed(2)),
              const SizedBox(height: 16),
              _buildStatCard('Success Rate', 
                  '${detailedStats.successRate.toStringAsFixed(1)}%'),
              const SizedBox(height: 16),
              _buildStatCard('Archived Items', 
                  detailedStats.archivedItemsCount.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(Map<DateTime, int> progressData) {
    if (progressData.isEmpty) {
      return const Center(child: Text('No progress data available'));
    }

    // Convert map to list of flutterspots
    final spots = <FlSpot>[];
    final sortedDates = progressData.keys.toList()..sort();
    
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final value = progressData[date]!;
      spots.add(FlSpot(i.toDouble(), value.toDouble()));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < sortedDates.length) {
                    final date = sortedDates[value.toInt()];
                    return Text(
                      '${date.month}/${date.day}',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: 0,
          maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewFrequencyChart(Map<int, int> frequencyData) {
    if (frequencyData.isEmpty) {
      return const Center(child: Text('No review frequency data available'));
    }

    // Convert to list of bar chart groups
    final barGroups = <BarChartGroupData>[];
    
    for (int i = 1; i <= 7; i++) {
      final value = frequencyData[i] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: Colors.green,
              width: 20,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final index = value.toInt() - 1;
                  if (index >= 0 && index < days.length) {
                    return Text(days[index], style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}