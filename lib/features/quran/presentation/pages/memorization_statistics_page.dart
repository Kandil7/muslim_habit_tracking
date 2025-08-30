import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';

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
    context.read<MemorizationBloc>().add(LoadMemorizationItems());
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
          } else {
            return _buildStatisticsContent(state);
          }
        },
      ),
    );
  }

  Widget _buildStatisticsContent(MemorizationState state) {
    MemorizationStatistics? stats;
    DetailedMemorizationStatistics? detailedStats;
    List<MemorizationItem>? items;

    // Extract data from different states
    if (state is MemorizationStatisticsLoaded) {
      stats = state.statistics;
    } else if (state is DetailedStatisticsLoaded) {
      detailedStats = state.detailedStatistics;
    } else if (state is MemorizationItemsLoaded) {
      items = state.items;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall statistics cards
            if (stats != null) ...[
              _buildOverallStatsGrid(stats),
              const SizedBox(height: 24),
            ],
            
            // Status distribution chart
            const Text(
              'Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (stats != null)
              _buildStatusDistributionChart(stats.itemsByStatus),
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
              const Text(
                'Additional Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatCard('Average Streak Length', 
                  '${detailedStats.averageStreakLength.toStringAsFixed(2)} days'),
              const SizedBox(height: 16),
              _buildStatCard('Success Rate', 
                  '${detailedStats.successRate.toStringAsFixed(1)}%'),
              const SizedBox(height: 16),
              _buildStatCard('Archived Items', 
                  detailedStats.archivedItemsCount.toString()),
              const SizedBox(height: 16),
              _buildStatCard('Review Consistency', 
                  '${detailedStats.reviewConsistency.toStringAsFixed(1)}%'),
              const SizedBox(height: 16),
              _buildStatCard('Avg. Pages/Day', 
                  detailedStats.averagePagesPerDay.toStringAsFixed(2)),
            ],
            
            const SizedBox(height: 32),
            
            // Items list by status
            if (items != null) ...[
              const Text(
                'Your Memorization Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildItemsByStatusList(items),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatsGrid(MemorizationStatistics stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Total Items', stats.totalItems.toString()),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Memorized', 
                  '${stats.itemsByStatus[MemorizationStatus.memorized] ?? 0} '
                  '(${stats.memorizationPercentage.toStringAsFixed(1)}%)'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Current Streak', '${stats.currentStreak} days'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Longest Streak', '${stats.longestStreak} days'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Total Reviews', stats.totalReviews.toString()),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Avg. Reviews/Day', 
                  stats.averageReviewsPerDay.toStringAsFixed(2)),
            ),
          ],
        ),
      ],
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDistributionChart(Map<MemorizationStatus, int> statusData) {
    final List<PieChartSectionData> sections = [];
    final total = statusData.values.fold(0, (sum, item) => sum + item);
    
    if (total == 0) {
      return const Center(child: Text('No data available'));
    }
    
    // Colors for each status
    final statusColors = {
      MemorizationStatus.newStatus: Colors.blue,
      MemorizationStatus.inProgress: Colors.orange,
      MemorizationStatus.memorized: Colors.green,
      MemorizationStatus.archived: Colors.grey,
    };
    
    // Labels for each status
    final statusLabels = {
      MemorizationStatus.newStatus: 'New',
      MemorizationStatus.inProgress: 'In Progress',
      MemorizationStatus.memorized: 'Memorized',
      MemorizationStatus.archived: 'Archived',
    };
    
    int index = 0;
    for (final entry in statusData.entries) {
      if (entry.value > 0) {
        final percentage = (entry.value / total) * 100;
        sections.add(
          PieChartSectionData(
            color: statusColors[entry.key],
            value: percentage,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        index++;
      }
    }
    
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
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
              dotData: const FlDotData(show: true),
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

  Widget _buildItemsByStatusList(List<MemorizationItem> items) {
    // Group items by status
    final itemsByStatus = <MemorizationStatus, List<MemorizationItem>>{};
    for (final status in MemorizationStatus.values) {
      itemsByStatus[status] = items.where((item) => item.status == status).toList();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in itemsByStatus.entries) ...[
          if (entry.value.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              _getStatusLabel(entry.key),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.value.length,
              itemBuilder: (context, index) {
                final item = entry.value[index];
                return Card(
                  child: ListTile(
                    title: Text(item.surahName),
                    subtitle: Text('Pages ${item.startPage}-${item.endPage}'),
                    trailing: Text(
                      entry.key == MemorizationStatus.inProgress 
                          ? '${item.consecutiveReviewDays}/5 days' 
                          : '',
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  String _getStatusLabel(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return 'New Items';
      case MemorizationStatus.inProgress:
        return 'In Progress';
      case MemorizationStatus.memorized:
        return 'Memorized';
      case MemorizationStatus.archived:
        return 'Archived';
    }
  }
}