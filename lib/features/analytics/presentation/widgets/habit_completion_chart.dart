import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';

class HabitCompletionChart extends StatelessWidget {
  final List<HabitStats> habitStats;
  final DateTime startDate;
  final DateTime endDate;

  const HabitCompletionChart({
    super.key,
    required this.habitStats,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    if (habitStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < habitStats.length) {
                    final name = habitStats[value.toInt()].habitName;
                    // Truncate long names
                    final displayName = name.length > 10 
                        ? '${name.substring(0, 10)}...' 
                        : name;
                    return Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  );
                },
                reservedSize: 30,
                interval: 20,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _getBarGroups(),
          gridData: const FlGridData(show: true),
          maxY: 100,
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return habitStats.asMap().entries.map((entry) {
      final index = entry.key;
      final stats = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stats.completionRate,
            color: _getBarColor(stats.completionRate),
            width: 16,
            borderRadius: BorderRadius.zero,
            rodStackItems: [
              BarChartRodStackItem(
                0,
                stats.completionRate,
                _getBarColor(stats.completionRate),
              ),
            ],
          ),
        ],
      );
    }).toList();
  }

  Color _getBarColor(double completionRate) {
    if (completionRate >= 80) {
      return Colors.green;
    } else if (completionRate >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}