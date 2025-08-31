import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/memorization_progress_card.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/stats_summary_card.dart';
import 'package:fl_chart/fl_chart.dart';

/// Statistics page for detailed Quran memorization analytics
class MemorizationStatisticsPage extends StatefulWidget {
  const MemorizationStatisticsPage({super.key});

  @override
  State<MemorizationStatisticsPage> createState() =>
      _MemorizationStatisticsPageState();
}

class _MemorizationStatisticsPageState
    extends State<MemorizationStatisticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MemorizationBloc>().add(LoadMemorizationStatistics());
    context.read<MemorizationBloc>().add(LoadDetailedStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Statistics'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MemorizationBloc>().add(LoadMemorizationStatistics());
          context.read<MemorizationBloc>().add(LoadDetailedStatistics());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress summary card
                const MemorizationProgressCard(),
                const SizedBox(height: 16),
                
                // Stats summary card
                const StatsSummaryCard(),
                const SizedBox(height: 16),
                
                // Progress over time chart
                const _ProgressOverTimeChart(),
                const SizedBox(height: 16),
                
                // Review frequency chart
                const _ReviewFrequencyChart(),
                const SizedBox(height: 16),
                
                // Additional metrics
                const _AdditionalMetricsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chart showing progress over time
class _ProgressOverTimeChart extends StatelessWidget {
  const _ProgressOverTimeChart();

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
            if (state is DetailedStatisticsLoaded) {
              final detailedStats = state.detailedStatistics;
              
              // Convert map to list of points
              final dataPoints = detailedStats.progressOverTime.entries
                  .map((entry) => FlSpot(
                        entry.key.millisecondsSinceEpoch.toDouble(),
                        entry.value.toDouble(),
                      ))
                  .toList();
              
              if (dataPoints.isEmpty) {
                return const Center(
                  child: Text(
                    'No progress data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Over Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date = DateTime.fromMillisecondsSinceEpoch(
                                    value.toInt());
                                return Text(
                                  '${date.day}/${date.month}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: dataPoints.first.x,
                        maxX: dataPoints.last.x,
                        minY: 0,
                        maxY: dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataPoints,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
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

/// Chart showing review frequency by day of week
class _ReviewFrequencyChart extends StatelessWidget {
  const _ReviewFrequencyChart();

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
            if (state is DetailedStatisticsLoaded) {
              final detailedStats = state.detailedStatistics;
              
              // Convert map to list of bar chart groups
              final barGroups = detailedStats.reviewFrequencyByDay.entries
                  .map((entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: Colors.green,
                            width: 20,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ))
                  .toList();
              
              if (barGroups.isEmpty) {
                return const Center(
                  child: Text(
                    'No review frequency data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review Frequency by Day',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ];
                                final index = value.toInt();
                                return Text(
                                  index < days.length ? days[index] : '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                        maxY: barGroups
                                .map((g) => g.barRods.first.toY)
                                .reduce((a, b) => a > b ? a : b) +
                            5,
                      ),
                    ),
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

/// Card showing additional metrics
class _AdditionalMetricsCard extends StatelessWidget {
  const _AdditionalMetricsCard();

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
            if (state is DetailedStatisticsLoaded) {
              final detailedStats = state.detailedStatistics;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Metrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _MetricItem(
                    label: 'Average Streak Length',
                    value: '${detailedStats.averageStreakLength.toStringAsFixed(1)} days',
                    icon: Icons.timeline,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _MetricItem(
                    label: 'Success Rate',
                    value: '${detailedStats.successRate.toStringAsFixed(1)}%',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _MetricItem(
                    label: 'Review Consistency',
                    value: detailedStats.reviewConsistency.toStringAsFixed(1) + '%',
                    icon: Icons.bar_chart,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _MetricItem(
                    label: 'Average Pages/Day',
                    value: detailedStats.averagePagesPerDay.toStringAsFixed(1),
                    icon: Icons.description,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _MetricItem(
                    label: 'Archived Items',
                    value: detailedStats.archivedItemsCount.toString(),
                    icon: Icons.archive,
                    color: Colors.grey,
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

/// Widget for displaying a single metric
class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}