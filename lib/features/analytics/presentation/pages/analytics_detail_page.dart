import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:muslim_habbit/features/analytics/presentation/widgets/goal_progress_card.dart';
import 'package:muslim_habbit/features/analytics/presentation/widgets/monthly_chart.dart';
import 'package:muslim_habbit/features/analytics/presentation/widgets/yearly_chart.dart';
import 'package:share_plus/share_plus.dart';

/// A detailed analytics page for a specific habit
class AnalyticsDetailPage extends StatefulWidget {
  /// The habit statistics
  final HabitStats habitStats;

  /// Creates an analytics detail page
  const AnalyticsDetailPage({super.key, required this.habitStats});

  @override
  State<AnalyticsDetailPage> createState() => _AnalyticsDetailPageState();
}

class _AnalyticsDetailPageState extends State<AnalyticsDetailPage>
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitStats.habitName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportAndShareData(),
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () => _showGoalSettingDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOverviewTab(), _buildMonthlyTab(), _buildYearlyTab()],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Completion Rate',
                        '${widget.habitStats.completionRate.toStringAsFixed(1)}%',
                        Icons.percent,
                        _getCompletionColor(widget.habitStats.completionRate),
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
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: widget.habitStats.completionRate / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCompletionColor(widget.habitStats.completionRate),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completed ${widget.habitStats.completionCount} out of ${widget.habitStats.totalDays} days',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Goal progress card
          GoalProgressCard(habitStats: widget.habitStats),

          const SizedBox(height: 16),

          // Weekday completion card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekday Completion',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildWeekdayCompletionChart(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Insights card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Insights',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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

  Widget _buildMonthlyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Completion Rates',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (widget.habitStats.monthlyCompletionRates.isNotEmpty)
            MonthlyChart(
              monthlyData: widget.habitStats.monthlyCompletionRates,
              height: 300,
            )
          else
            const Center(child: Text('No monthly data available')),
          const SizedBox(height: 24),
          Text(
            'Monthly Insights',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildMonthlyInsights(),
        ],
      ),
    );
  }

  Widget _buildYearlyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yearly Completion Rates',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (widget.habitStats.yearlyCompletionRates.isNotEmpty)
            YearlyChart(
              yearlyData: widget.habitStats.yearlyCompletionRates,
              height: 300,
            )
          else
            const Center(child: Text('No yearly data available')),
          const SizedBox(height: 24),
          Text(
            'Yearly Insights',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildYearlyInsights(),
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
          backgroundColor: color.withAlpha(51), // 0.2 opacity
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
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
            backgroundColor: color.withAlpha(51), // 0.2 opacity
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(content, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayCompletionChart() {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final maxValue = widget.habitStats.weekdayCompletion.values.fold<int>(
      0,
      (max, value) => value > max ? value : max,
    );

    return Column(
      children:
          weekdays.map((day) {
            final value = widget.habitStats.weekdayCompletion[day] ?? 0;
            final percentage = maxValue > 0 ? value / maxValue : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 100, child: Text(day)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 16,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$value'),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMonthlyInsights() {
    if (widget.habitStats.monthlyCompletionRates.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No monthly data available for insights'),
        ),
      );
    }

    // Find best and worst months
    final sortedMonths =
        widget.habitStats.monthlyCompletionRates.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final bestMonth = sortedMonths.first;
    final worstMonth = sortedMonths.last;

    // Calculate average monthly completion rate
    final averageRate =
        sortedMonths.fold<double>(0.0, (sum, entry) => sum + entry.value) /
        sortedMonths.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInsightItem(
              'Best Month',
              '${_formatMonthYear(bestMonth.key)} (${bestMonth.value.toStringAsFixed(1)}%)',
              Icons.emoji_events,
              AppColors.success,
            ),
            const Divider(),
            _buildInsightItem(
              'Needs Improvement',
              '${_formatMonthYear(worstMonth.key)} (${worstMonth.value.toStringAsFixed(1)}%)',
              Icons.warning,
              AppColors.warning,
            ),
            const Divider(),
            _buildInsightItem(
              'Average Monthly Rate',
              '${averageRate.toStringAsFixed(1)}%',
              Icons.analytics,
              AppColors.info,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyInsights() {
    if (widget.habitStats.yearlyCompletionRates.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No yearly data available for insights'),
        ),
      );
    }

    // Find best and worst years
    final sortedYears =
        widget.habitStats.yearlyCompletionRates.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final bestYear = sortedYears.first;
    final worstYear = sortedYears.last;

    // Calculate average yearly completion rate
    final averageRate =
        sortedYears.fold<double>(0.0, (sum, entry) => sum + entry.value) /
        sortedYears.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInsightItem(
              'Best Year',
              '${bestYear.key} (${bestYear.value.toStringAsFixed(1)}%)',
              Icons.emoji_events,
              AppColors.success,
            ),
            const Divider(),
            _buildInsightItem(
              'Needs Improvement',
              '${worstYear.key} (${worstYear.value.toStringAsFixed(1)}%)',
              Icons.warning,
              AppColors.warning,
            ),
            const Divider(),
            _buildInsightItem(
              'Average Yearly Rate',
              '${averageRate.toStringAsFixed(1)}%',
              Icons.analytics,
              AppColors.info,
            ),
          ],
        ),
      ),
    );
  }

  String _getBestDay() {
    final weekdayCompletion = widget.habitStats.weekdayCompletion;
    if (weekdayCompletion.isEmpty) {
      return 'No data available';
    }

    final bestDay = weekdayCompletion.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return '${bestDay.key} (${bestDay.value} completions)';
  }

  String _getWorstDay() {
    final weekdayCompletion = widget.habitStats.weekdayCompletion;
    if (weekdayCompletion.isEmpty) {
      return 'No data available';
    }

    final worstDay = weekdayCompletion.entries.reduce(
      (a, b) => a.value < b.value ? a : b,
    );

    return '${worstDay.key} (${worstDay.value} completions)';
  }

  String _getCurrentStatus() {
    final completionRate = widget.habitStats.completionRate;

    if (completionRate >= 80) {
      return 'Excellent! Keep up the good work.';
    } else if (completionRate >= 60) {
      return 'Good progress. You\'re on the right track.';
    } else if (completionRate >= 40) {
      return 'Making progress. Try to be more consistent.';
    } else {
      return 'Needs improvement. Try setting reminders.';
    }
  }

  Color _getCompletionColor(double completionRate) {
    if (completionRate >= 80) {
      return AppColors.success;
    } else if (completionRate >= 50) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
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

  void _exportAndShareData() {
    context.read<AnalyticsBloc>().add(
      const ExportAnalyticsDataEvent(format: 'csv'),
    );

    // Show a snackbar to indicate that the export is in progress
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting analytics data...')),
    );

    // Listen for the export completion
    final blocListener = BlocListener<AnalyticsBloc, AnalyticsState>(
      listenWhen:
          (previous, current) =>
              current is AnalyticsDataExported || current is AnalyticsError,
      listener: (context, state) {
        if (state is AnalyticsDataExported) {
          // Share the exported file
          SharePlus.instance.share(
            ShareParams(
              files: [XFile(state.filePath)],
              subject: 'Habit Analytics Data',
              text: 'Here is your habit analytics data',
            ),
          );
        } else if (state is AnalyticsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );

    // Add the listener to the widget tree temporarily
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => blocListener,
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  void _showGoalSettingDialog() {
    int? targetStreak = widget.habitStats.targetStreak;
    double? targetCompletionRate = widget.habitStats.targetCompletionRate;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Set Goals'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Set goals to track your progress:'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Target Streak:'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: (targetStreak ?? 0).toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 20,
                            label: targetStreak?.toString() ?? '0',
                            onChanged: (value) {
                              setState(() {
                                targetStreak = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('${targetStreak ?? 0} days'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Target Completion Rate:'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: targetCompletionRate ?? 0,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            label: '${(targetCompletionRate ?? 0).toInt()}%',
                            onChanged: (value) {
                              setState(() {
                                targetCompletionRate = value;
                              });
                            },
                          ),
                        ),
                        Text('${(targetCompletionRate ?? 0).toInt()}%'),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      // Set the goal
                      context.read<AnalyticsBloc>().add(
                        SetHabitGoalEvent(
                          habitId: widget.habitStats.habitId,
                          targetStreak: targetStreak,
                          targetCompletionRate: targetCompletionRate,
                        ),
                      );

                      // Show a snackbar to indicate that the goal has been set
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Goal set successfully')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
