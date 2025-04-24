import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// A widget that displays yearly habit completion data as a line chart
class YearlyChart extends StatelessWidget {
  /// The yearly completion rates data
  final Map<String, double> yearlyData;

  /// Optional height for the chart
  final double height;

  /// Optional title for the chart
  final String? title;

  /// Creates a yearly chart widget
  const YearlyChart({
    super.key,
    required this.yearlyData,
    this.height = 300,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (yearlyData.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No yearly data available')),
      );
    }

    final sortedYears =
        yearlyData.keys.toList()..sort((a, b) => a.compareTo(b));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(title!, style: Theme.of(context).textTheme.titleMedium),
          ),
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withAlpha(76), // 0.3 opacity
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < sortedYears.length) {
                        return Text(sortedYears[value.toInt()]);
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
                      if (value % 25 == 0) {
                        return Text('${value.toInt()}%');
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: sortedYears.length - 1,
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(sortedYears.length, (index) {
                    final year = sortedYears[index];
                    final value = yearlyData[year] ?? 0.0;
                    return FlSpot(index.toDouble(), value);
                  }),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withAlpha(51), // 0.2 opacity
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final year = sortedYears[spot.x.toInt()];
                      return LineTooltipItem(
                        '$year: ${spot.y.toStringAsFixed(1)}%',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
