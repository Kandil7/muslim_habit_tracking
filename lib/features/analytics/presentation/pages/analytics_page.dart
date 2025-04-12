import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracking/core/presentation/widgets/widgets.dart';
import 'package:ramadan_habit_tracking/core/theme/app_theme.dart';
import 'package:ramadan_habit_tracking/core/utils/date_utils.dart';
import 'package:ramadan_habit_tracking/features/analytics/domain/entities/habit_stats.dart';
import 'package:ramadan_habit_tracking/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:ramadan_habit_tracking/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:ramadan_habit_tracking/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:ramadan_habit_tracking/features/analytics/presentation/pages/habit_stats_detail_page.dart';

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
      GetHabitStatsByDateRangeEvent(
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'week':
                    _startDate = DateTimeUtils.startOfWeek;
                    _endDate = DateTimeUtils.endOfWeek;
                    break;
                  case 'month':
                    _startDate = DateTimeUtils.startOfMonth;
                    _endDate = DateTimeUtils.endOfMonth;
                    break;
                  case 'custom':
                    // TODO: Implement date range picker
                    break;
                }
                _loadAnalytics();
              });
            },
            itemBuilder: (context) => [
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
    final overallCompletionRate = habitStats.fold<double>(
      0.0,
      (sum, stats) => sum + stats.completionRate,
    ) / habitStats.length;

    // Find most consistent habit
    habitStats.sort((a, b) => b.completionRate.compareTo(a.completionRate));
    final mostConsistentHabit = habitStats.first;

    // Find least consistent habit
    final leastConsistentHabit = habitStats.last;

    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      buildWhen: (previous, current) => 
        current is HabitStatsByDateRangeLoaded && 
        (previous is! HabitStatsByDateRangeLoaded || 
         (previous as HabitStatsByDateRangeLoaded).habitStats != current.habitStats),
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

  Widget _buildConsistencyItem(String name, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
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
      buildWhen: (previous, current) => 
        current is HabitStatsByDateRangeLoaded && 
        (previous is! HabitStatsByDateRangeLoaded || 
         (previous as HabitStatsByDateRangeLoaded).habitStats != current.habitStats),
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
              Text(
                stats.habitName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatItem(
                    label: 'Completion',
                    value: '${stats.completionRate.toStringAsFixed(1)}%',
                  ),
                  StatItem(
                    label: 'Current Streak',
                    value: '${stats.currentStreak} days',
                  ),
                  StatItem(
                    label: 'Longest Streak',
                    value: '${stats.longestStreak} days',
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
}
