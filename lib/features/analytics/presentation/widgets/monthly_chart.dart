import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// A widget that displays monthly habit completion data as a bar chart
class MonthlyChart extends StatelessWidget {
  /// The monthly completion rates data
  final Map<String, double> monthlyData;

  /// Optional height for the chart
  final double height;

  /// Optional title for the chart
  final String? title;

  /// Creates a monthly chart widget
  const MonthlyChart({
    super.key,
    required this.monthlyData,
    this.height = 300,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No monthly data available')),
      );
    }

    final sortedMonths =
        monthlyData.keys.toList()..sort((a, b) => a.compareTo(b));

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
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final month = sortedMonths[group.x.toInt()];
                    return BarTooltipItem(
                      '${_formatMonthYear(month)}\\n${rod.toY.toStringAsFixed(1)}%',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < sortedMonths.length) {
                        final month = sortedMonths[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _formatMonthYearShort(month),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value % 25 == 0) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
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
              borderData: FlBorderData(show: false),
              barGroups: List.generate(sortedMonths.length, (index) {
                final month = sortedMonths[index];
                final value = monthlyData[month] ?? 0.0;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: AppColors.primary,
                      width: 15,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  String _formatMonthYear(String monthYear) {
    final parts = monthYear.split('-');
    if (parts.length == 2) {
      final year = parts[0];
      final month = parts[1];
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      final monthIndex = int.tryParse(month);
      if (monthIndex != null && monthIndex >= 1 && monthIndex <= 12) {
        return '${monthNames[monthIndex - 1]} $year';
      }
    }
    return monthYear;
  }

  String _formatMonthYearShort(String monthYear) {
    final parts = monthYear.split('-');
    if (parts.length == 2) {
      final year = parts[0].substring(2); // Get last 2 digits of year
      final month = parts[1];
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final monthIndex = int.tryParse(month);
      if (monthIndex != null && monthIndex >= 1 && monthIndex <= 12) {
        return '${monthNames[monthIndex - 1]} $year';
      }
    }
    return monthYear;
  }
}
