import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/utils/date_utils.dart';
import 'package:muslim_habbit/core/presentation/widgets/widgets.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/habit_stats.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:muslim_habbit/features/analytics/presentation/pages/habit_stats_detail_page.dart';
import 'package:share_plus/share_plus.dart';

/// Analytics page with granular BlocBuilder widgets
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  DateTime _startDate = DateTimeUtils.startOfWeek;
  DateTime _endDate = DateTimeUtils.endOfWeek;

  @override
  void initState() {
    super.initState();
    // Load analytics for the current week
    _loadAnalytics();
  }

  void _loadAnalytics() {
    context.read<AnalyticsBloc>().add(
      GetHabitStatsByDateRangeEvent(startDate: _startDate, endDate: _endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Export Data',
            onPressed: _exportAnalyticsData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'week':
                    _startDate = DateTimeUtils.startOfWeek;
                    // Make sure end date is not in the future
                    final endOfWeek = DateTimeUtils.endOfWeek;
                    final now = DateTime.now();
                    _endDate = endOfWeek.isAfter(now) ? now : endOfWeek;
                    break;
                  case 'month':
                    _startDate = DateTimeUtils.startOfMonth;
                    // Make sure end date is not in the future
                    final endOfMonth = DateTimeUtils.endOfMonth;
                    final now = DateTime.now();
                    _endDate = endOfMonth.isAfter(now) ? now : endOfMonth;
                    break;
                  case 'custom':
                    _showDateRangePicker(context);
                    return; // Don't call _loadAnalytics() yet, it will be called after picking dates
                }
                _loadAnalytics();
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem<String>(
                    value: 'week',
                    child: Text('This Week'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'month',
                    child: Text('This Month'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'custom',
                    child: Text('Custom Range'),
                  ),
                ],
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const LoadingIndicator(text: 'Loading analytics...');
          } else if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Try Again',
                    onPressed: _loadAnalytics,
                    buttonType: ButtonType.primary,
                  ),
                ],
              ),
            );
          } else if (state is HabitStatsByDateRangeLoaded) {
            if (state.habitStats.isEmpty) {
              return EmptyState(
                title: 'No Analytics Available',
                message: 'Start tracking habits to see analytics',
                icon: Icons.bar_chart,
                actionText: 'Refresh',
                onAction: _loadAnalytics,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range card
                  _buildDateRangeCard(),

                  const SizedBox(height: 16),

                  // Summary section
                  _buildSummarySection(state.habitStats),

                  const SizedBox(height: 16),

                  // All habits stats
                  Text(
                    'All Habits',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  // List of habit stats cards
                  _buildHabitStatsList(state.habitStats),
                ],
              ),
            );
          } else {
            return const EmptyState(
              title: 'No Analytics Available',
              message: 'Start tracking habits to see analytics',
              icon: Icons.bar_chart,
            );
          }
        },
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Analytics for',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${DateTimeUtils.formatShortDate(_startDate)} - ${DateTimeUtils.formatShortDate(_endDate)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(List<HabitStats> habitStats) {
    // Calculate overall completion rate
    final overallCompletionRate =
        habitStats.fold<double>(
          0.0,
          (sum, stats) => sum + stats.completionRate,
        ) /
        habitStats.length;

    // Find most consistent habit
    habitStats.sort((a, b) => b.completionRate.compareTo(a.completionRate));
    final mostConsistentHabit = habitStats.first;

    // Find least consistent habit
    final leastConsistentHabit = habitStats.last;

    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      buildWhen: (previous, current) {
        if (current is! HabitStatsByDateRangeLoaded) return false;
        if (previous is! HabitStatsByDateRangeLoaded) return true;
        return previous.habitStats != current.habitStats;
      },
      builder: (context, state) {
        if (state is HabitStatsByDateRangeLoaded) {
          return Card(
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
                      StatItem(
                        label: 'Overall Completion',
                        value: '${overallCompletionRate.toStringAsFixed(1)}%',
                        icon: Icons.check_circle,
                        color: _getCompletionColor(overallCompletionRate),
                      ),
                      StatItem(
                        label: 'Total Habits',
                        value: '${habitStats.length}',
                        icon: Icons.list,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Most Consistent',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildConsistencyItem(
                    mostConsistentHabit.habitName,
                    '${mostConsistentHabit.completionRate.toStringAsFixed(1)}%',
                    Icons.emoji_events,
                    AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Needs Improvement',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildConsistencyItem(
                    leastConsistentHabit.habitName,
                    '${leastConsistentHabit.completionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildConsistencyItem(
    String name,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitStatsList(List<HabitStats> habitStats) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      buildWhen: (previous, current) {
        if (current is! HabitStatsByDateRangeLoaded) return false;
        if (previous is! HabitStatsByDateRangeLoaded) return true;
        return previous.habitStats != current.habitStats;
      },
      builder: (context, state) {
        if (state is HabitStatsByDateRangeLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habitStats.length,
            itemBuilder: (context, index) {
              return _buildHabitStatsCard(habitStats[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHabitStatsCard(HabitStats stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitStatsDetailPage(habitStats: stats),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      stats.habitName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (stats.hasReachedGoal)
                    Tooltip(
                      message: 'Goal reached!',
                      child: Icon(Icons.emoji_events, color: AppColors.success),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatItem(
                    label: 'Completion',
                    value: '${stats.completionRate.toStringAsFixed(1)}%',
                    icon: Icons.percent,
                    color: _getCompletionColor(stats.completionRate),
                  ),
                  StatItem(
                    label: 'Current Streak',
                    value: '${stats.currentStreak} days',
                    icon: Icons.local_fire_department,
                    color: AppColors.secondary,
                  ),
                  StatItem(
                    label: 'Longest Streak',
                    value: '${stats.longestStreak} days',
                    icon: Icons.emoji_events,
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: stats.completionRate / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getCompletionColor(stats.completionRate),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed ${stats.completionCount} out of ${stats.totalDays} days',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  HabitStatsDetailPage(habitStats: stats),
                        ),
                      );
                    },
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _showDateRangePicker(BuildContext context) async {
    // Make sure the end date is not in the future
    final now = DateTime.now();
    final adjustedEndDate = _endDate.isAfter(now) ? now : _endDate;

    final initialDateRange = DateTimeRange(
      start: _startDate,
      end: adjustedEndDate,
    );

    // Set lastDate to at least one year in the future to accommodate any reasonable range
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
      _loadAnalytics();
    }
  }

  void _exportAnalyticsData() {
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
          Share.shareXFiles(
            [XFile(state.filePath)],
            subject: 'Habit Analytics Data',
            text: 'Here is your habit analytics data',
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
}
