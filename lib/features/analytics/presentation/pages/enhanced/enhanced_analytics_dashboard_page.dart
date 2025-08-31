import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/analytics/presentation/bloc/enhanced/enhanced_analytics_bloc.dart';

/// Enhanced Analytics Dashboard Page
class EnhancedAnalyticsDashboardPage extends StatelessWidget {
  const EnhancedAnalyticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Export data
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh data
            },
          ),
        ],
      ),
      body: BlocBuilder<EnhancedAnalyticsBloc, EnhancedAnalyticsState>(
        builder: (context, state) {
          if (state is EnhancedAnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EnhancedAnalyticsLoaded) {
            return _AnalyticsDashboardContent(
              stats: state.stats,
              insights: state.insights,
            );
          } else if (state is EnhancedAnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Retry loading data
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Widget to display the analytics dashboard content
class _AnalyticsDashboardContent extends StatelessWidget {
  final OverallStats stats;
  final List<String> insights;

  const _AnalyticsDashboardContent({
    required this.stats,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date range selector
            _DateRangeSelector(stats: stats),
            const SizedBox(height: 20),
            
            // Overall summary cards
            _OverallSummaryCards(stats: stats),
            const SizedBox(height: 20),
            
            // Detailed analytics sections
            _HabitAnalyticsSection(habitAnalytics: stats.habitAnalytics),
            const SizedBox(height: 20),
            
            _IbadahAnalyticsSection(ibadahAnalytics: stats.ibadahAnalytics),
            const SizedBox(height: 20),
            
            _SkillsAnalyticsSection(skillsAnalytics: stats.skillsAnalytics),
            const SizedBox(height: 20),
            
            _SelfDevelopmentAnalyticsSection(
                selfDevelopmentAnalytics: stats.selfDevelopmentAnalytics),
            const SizedBox(height: 20),
            
            // Personalized insights
            _PersonalizedInsightsSection(insights: insights),
          ],
        ),
      ),
    );
  }
}

/// Widget to display date range selector
class _DateRangeSelector extends StatelessWidget {
  final OverallStats stats;

  const _DateRangeSelector({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics Period',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${stats.dateRangeStart.toString().split(' ')[0]} - ${stats.dateRangeEnd.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display overall summary cards
class _OverallSummaryCards extends StatelessWidget {
  final OverallStats stats;

  const _OverallSummaryCards({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 32, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text('Habits Completed'),
                  Text(
                    '${stats.habitAnalytics.completedToday}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.mosque, size: 32, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text('Prayers'),
                  Text(
                    '${stats.ibadahAnalytics.prayersCompleted}/${stats.ibadahAnalytics.totalPrayers}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.computer, size: 32, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text('Study Time'),
                  Text(
                    '${stats.skillsAnalytics.totalTimeSpent.inHours}h ${stats.skillsAnalytics.totalTimeSpent.inMinutes % 60}m',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget to display habit analytics section
class _HabitAnalyticsSection extends StatelessWidget {
  final HabitAnalytics habitAnalytics;

  const _HabitAnalyticsSection({required this.habitAnalytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Active Habits: ${habitAnalytics.activeHabits}/${habitAnalytics.totalHabits}'),
            Text('Completion Rate: ${habitAnalytics.overallCompletionRate.toStringAsFixed(1)}%'),
            Text('Current Streak: ${habitAnalytics.averageStreak} days'),
            Text('Longest Streak: ${habitAnalytics.longestStreak} days'),
          ],
        ),
      ),
    );
  }
}

/// Widget to display Ibadah analytics section
class _IbadahAnalyticsSection extends StatelessWidget {
  final IbadahAnalytics ibadahAnalytics;

  const _IbadahAnalyticsSection({required this.ibadahAnalytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ibadah Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Prayer Completion: ${ibadahAnalytics.prayerCompletionRate.toStringAsFixed(1)}%'),
            Text('Adhkar Completed: ${ibadahAnalytics.adhkarCompleted}/${ibadahAnalytics.totalAdhkar}'),
            Text('Quran Pages Read: ${ibadahAnalytics.quranPagesRead} pages'),
            Text('Dhikr Sessions: ${ibadahAnalytics.dhikrSessions}'),
          ],
        ),
      ),
    );
  }
}

/// Widget to display skills analytics section
class _SkillsAnalyticsSection extends StatelessWidget {
  final SkillsAnalytics skillsAnalytics;

  const _SkillsAnalyticsSection({required this.skillsAnalytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills Development',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Total Activities: ${skillsAnalytics.totalActivities}'),
            Text('Time Spent: ${skillsAnalytics.totalTimeSpent.inHours}h ${skillsAnalytics.totalTimeSpent.inMinutes % 60}m'),
            Text('Challenges Completed: ${skillsAnalytics.challengesCompleted}/${skillsAnalytics.totalChallenges}'),
            Text('Resources Saved: ${skillsAnalytics.resourcesSaved}'),
          ],
        ),
      ),
    );
  }
}

/// Widget to display self-development analytics section
class _SelfDevelopmentAnalyticsSection extends StatelessWidget {
  final SelfDevelopmentAnalytics selfDevelopmentAnalytics;

  const _SelfDevelopmentAnalyticsSection({required this.selfDevelopmentAnalytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Self Development',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Goals Completed: ${selfDevelopmentAnalytics.goalsCompleted}/${selfDevelopmentAnalytics.goalsSet}'),
            Text('Reflection Entries: ${selfDevelopmentAnalytics.reflectionEntries}'),
            Text('Mindfulness Sessions: ${selfDevelopmentAnalytics.mindfulnessSessions}'),
          ],
        ),
      ),
    );
  }
}

/// Widget to display personalized insights section
class _PersonalizedInsightsSection extends StatelessWidget {
  final List<String> insights;

  const _PersonalizedInsightsSection({required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(insight)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}