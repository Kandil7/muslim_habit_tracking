import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/habit_stats.dart';

/// Page for detailed habit statistics
class HabitStatsDetailPage extends StatefulWidget {
  final HabitStats habitStats;

  const HabitStatsDetailPage({super.key, required this.habitStats});

  @override
  State<HabitStatsDetailPage> createState() => _HabitStatsDetailPageState();
}

class _HabitStatsDetailPageState extends State<HabitStatsDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.habitStats.habitName),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Weekly'),
                Tab(text: 'Trends'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildWeeklyTab(),
              _buildTrendsTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Summary', style: AppTextStyles.headingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStatItem(
                        'Completion\n Rate',
                        '${widget.habitStats.completionRate.toStringAsFixed(1)}%',
                        Icons.percent,
                        AppColors.primary,
                      ),
                      _buildStatItem(
                        'Current Streak',
                        '${widget.habitStats.currentStreak} days',
                        Icons.local_fire_department,
                        AppColors.secondary,
                      ),
                      _buildStatItem(
                        'Longest Streak',
                        '${widget.habitStats.longestStreak} days',
                        Icons.emoji_events,
                        AppColors.success,
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: widget.habitStats.completionRate / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCompletionColor(widget.habitStats.completionRate),
                    ),
                  ),
                  Text(
                    'Completed ${widget.habitStats.completionCount} out of ${widget.habitStats.totalDays} days',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Completion by day of week
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completion by Day of Week',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 200, child: _buildDayOfWeekChart()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Insights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Insights', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  _buildInsightItem(
                    'Best Day',
                    _getBestDay(),
                    Icons.star,
                    AppColors.secondary,
                  ),
                  const Divider(),
                  _buildInsightItem(
                    'Needs Improvement',
                    _getWorstDay(),
                    Icons.warning,
                    AppColors.warning,
                  ),
                  const Divider(),
                  _buildInsightItem(
                    'Current Status',
                    _getCurrentStatus(),
                    Icons.info,
                    AppColors.info,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This week's progress
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('This Week', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  SizedBox(height: 200, child: _buildWeeklyProgressChart()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Day by day breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day by Day Breakdown',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  ...DateTimeUtils.daysOfWeek
                      .map((day) => _buildDayProgressItem(day))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly trend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Trend', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  SizedBox(height: 200, child: _buildMonthlyTrendChart()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Streak history
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Streak History', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      child: Icon(Icons.emoji_events, color: Colors.white),
                    ),
                    title: const Text('Longest Streak'),
                    subtitle: Text('${widget.habitStats.longestStreak} days'),
                    trailing: const Text('Achievement Unlocked!'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Current Streak'),
                    subtitle: Text('${widget.habitStats.currentStreak} days'),
                    trailing: Text(
                      widget.habitStats.currentStreak > 0
                          ? 'Keep it up!'
                          : 'Start today!',
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.info,
                      child: Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    title: const Text('Average Streak'),
                    subtitle: const Text('5 days'),
                    trailing: const Text('Good consistency'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommendations', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  _buildRecommendationItem(
                    'Set a reminder',
                    'Schedule notifications to help you remember',
                    Icons.notifications,
                  ),
                  const Divider(),
                  _buildRecommendationItem(
                    'Track consistently',
                    'Try to complete this habit on ${_getWorstDay()}',
                    Icons.track_changes,
                  ),
                  const Divider(),
                  _buildRecommendationItem(
                    'Celebrate milestones',
                    'Reward yourself when you reach 10 days streak',
                    Icons.celebration,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildInsightItem(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(content, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayProgressItem(String day) {
    final count = widget.habitStats.weekdayCompletion[day] ?? 0;
    final isToday = day == DateTimeUtils.formatDayOfWeek(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.substring(0, 1),
                style: TextStyle(
                  color: isToday ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: count > 0 ? 1.0 : 0.0,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    count > 0 ? AppColors.success : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            count > 0 ? 'Completed' : 'Missed',
            style: AppTextStyles.bodySmall.copyWith(
              color: count > 0 ? AppColors.success : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(content, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekChart() {
    final weekdayCompletion = widget.habitStats.weekdayCompletion;
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            weekdayCompletion.values.isEmpty
                ? 1
                : weekdayCompletion.values.reduce((a, b) => a > b ? a : b) *
                    1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    daysOfWeek[value.toInt()].substring(0, 1),
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine:
              (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 1),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          daysOfWeek.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: weekdayCompletion[daysOfWeek[index]]?.toDouble() ?? 0,
                color: _getDayColor(daysOfWeek[index]),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressChart() {
    // Simulated data for weekly progress
    final weekData = [0.8, 0.6, 1.0, 0.7, 0.9, 0.5, 0.0];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.2,
          getDrawingHorizontalLine:
              (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    days[value.toInt()],
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
              reservedSize: 40,
              interval: 0.2,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              7,
              (index) => FlSpot(index.toDouble(), weekData[index]),
            ),
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendChart() {
    // Simulated data for monthly trend
    final monthData = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.2,
          getDrawingHorizontalLine:
              (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      months[value.toInt()],
                      style: AppTextStyles.bodySmall,
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
                if (value == 0) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
              reservedSize: 40,
              interval: 0.2,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              6,
              (index) => FlSpot(index.toDouble(), monthData[index]),
            ),
            isCurved: true,
            color: AppColors.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.secondary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDayColor(String day) {
    if (day == 'Friday') {
      return AppColors.primary;
    } else if (day == DateTimeUtils.formatDayOfWeek(DateTime.now())) {
      return AppColors.secondary;
    } else {
      return AppColors.primaryLight;
    }
  }

  Color _getCompletionColor(double rate) {
    if (rate >= 80) {
      return AppColors.success;
    } else if (rate >= 50) {
      return AppColors.primary;
    } else if (rate >= 30) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  String _getBestDay() {
    final weekdayCompletion = widget.habitStats.weekdayCompletion;
    if (weekdayCompletion.isEmpty) return 'Not enough data';

    String bestDay = weekdayCompletion.keys.first;
    int maxCount = weekdayCompletion.values.first;

    weekdayCompletion.forEach((day, count) {
      if (count > maxCount) {
        bestDay = day;
        maxCount = count;
      }
    });

    return bestDay;
  }

  String _getWorstDay() {
    final weekdayCompletion = widget.habitStats.weekdayCompletion;
    if (weekdayCompletion.isEmpty) return 'Not enough data';

    String worstDay = weekdayCompletion.keys.first;
    int minCount = weekdayCompletion.values.first;

    weekdayCompletion.forEach((day, count) {
      if (count < minCount) {
        worstDay = day;
        minCount = count;
      }
    });

    return worstDay;
  }

  String _getCurrentStatus() {
    final completionRate = widget.habitStats.completionRate;

    if (completionRate >= 80) {
      return 'Excellent! Keep up the good work.';
    } else if (completionRate >= 60) {
      return 'Good progress. You\'re on the right track.';
    } else if (completionRate >= 40) {
      return 'Making progress. Try to be more consistent.';
    } else if (completionRate >= 20) {
      return 'Getting started. Keep pushing forward.';
    } else {
      return 'Just beginning. Every step counts!';
    }
  }
}
