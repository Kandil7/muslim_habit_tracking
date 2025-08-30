import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/memorization_progress_card.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/daily_review_list.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/stats_summary_card.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/memorization_statistics_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/add_memorization_item_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/daily_review_page.dart';

/// Dashboard page for Quran memorization tracking
class MemorizationDashboardPage extends StatefulWidget {
  const MemorizationDashboardPage({super.key});

  @override
  State<MemorizationDashboardPage> createState() => _MemorizationDashboardPageState();
}

class _MemorizationDashboardPageState extends State<MemorizationDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<MemorizationBloc>().add(LoadMemorizationStatistics());
    context.read<MemorizationBloc>().add(LoadDailyReviewSchedule());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Memorization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Navigate to statistics page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemorizationStatisticsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemorizationSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MemorizationBloc>().add(LoadMemorizationStatistics());
          context.read<MemorizationBloc>().add(LoadDailyReviewSchedule());
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
                
                // Quick actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DailyReviewPage(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(Icons.bookmark_added, size: 32, color: Colors.blue),
                                SizedBox(height: 8),
                                Text('Daily Review'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddMemorizationItemPage(),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(Icons.add, size: 32, color: Colors.green),
                                SizedBox(height: 8),
                                Text('Add Item'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Daily review section
                const Text(
                  'Daily Review',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Daily review list
                const DailyReviewList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new memorization item page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMemorizationItemPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Settings page for memorization preferences
class MemorizationSettingsPage extends StatefulWidget {
  const MemorizationSettingsPage({super.key});

  @override
  State<MemorizationSettingsPage> createState() => _MemorizationSettingsPageState();
}

class _MemorizationSettingsPageState extends State<MemorizationSettingsPage> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    context.read<MemorizationBloc>().add(LoadMemorizationPreferences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Settings'),
      ),
      body: BlocBuilder<MemorizationBloc, MemorizationState>(
        builder: (context, state) {
          if (state is MemorizationPreferencesLoaded) {
            final preferences = state.preferences;
            _selectedTime = preferences.notificationTime;
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review Period',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select how many days to divide your memorized portions for review',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 5, label: Text('5 Days')),
                      ButtonSegment(value: 6, label: Text('6 Days')),
                      ButtonSegment(value: 7, label: Text('7 Days')),
                    ],
                    selected: {preferences.reviewPeriod},
                    onSelectionChanged: (Set<int> newSelection) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(reviewPeriod: newSelection.first),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Memorization Direction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose the direction of your memorization journey',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<MemorizationDirection>(
                    segments: const [
                      ButtonSegment(
                        value: MemorizationDirection.fromBaqarah,
                        label: Text('Baqarah → Nas'),
                      ),
                      ButtonSegment(
                        value: MemorizationDirection.fromNas,
                        label: Text('Nas → Baqarah'),
                      ),
                    ],
                    selected: {preferences.memorizationDirection},
                    onSelectionChanged: (Set<MemorizationDirection> newSelection) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(
                                memorizationDirection: newSelection.first,
                              ),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Enable Daily Reminders'),
                    value: preferences.notificationsEnabled,
                    onChanged: (bool value) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(notificationsEnabled: value),
                            ),
                          );
                    },
                  ),
                  if (preferences.notificationsEnabled) ...[
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Notification Time'),
                      subtitle: Text(
                        preferences.notificationTime?.formattedTime ?? 'Not set',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: preferences.notificationTime ??
                              TimeOfDay(hour: 8, minute: 0),
                        );
                        if (picked != null) {
                          context.read<MemorizationBloc>().add(
                                UpdatePreferences(
                                  preferences.copyWith(
                                    notificationTime: picked,
                                  ),
                                ),
                              );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Show Overdue Warnings'),
                    value: preferences.showOverdueWarnings,
                    onChanged: (bool value) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(showOverdueWarnings: value),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Show Motivational Quotes'),
                    value: preferences.showMotivationalQuotes,
                    onChanged: (bool value) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(showMotivationalQuotes: value),
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable Haptic Feedback'),
                    value: preferences.enableHapticFeedback,
                    onChanged: (bool value) {
                      context.read<MemorizationBloc>().add(
                            UpdatePreferences(
                              preferences.copyWith(enableHapticFeedback: value),
                            ),
                          );
                    },
                  ),
                ],
              ),
            );
          } else if (state is MemorizationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemorizationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}