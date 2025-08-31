import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart' as prefs;
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
    context.read<MemorizationBloc>().add(LoadStreakStatistics());
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
          context.read<MemorizationBloc>().add(LoadStreakStatistics());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress summary card with enhanced UI
                const MemorizationProgressCard(),
                const SizedBox(height: 16),
                
                // Streak visualization
                const _StreakVisualizationCard(),
                const SizedBox(height: 16),
                
                // Stats summary card
                const StatsSummaryCard(),
                const SizedBox(height: 16),
                
                // Quick actions with improved design
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
                      child: _QuickActionButton(
                        icon: Icons.bookmark_added,
                        label: 'Daily Review',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DailyReviewPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.add,
                        label: 'Add Item',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddMemorizationItemPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Daily review section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Review',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DailyReviewPage(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Daily review list with limited height
                const SizedBox(
                  height: 200,
                  child: DailyReviewList(),
                ),
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

/// Widget for visualizing streak information
class _StreakVisualizationCard extends StatelessWidget {
  const _StreakVisualizationCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MemorizationBloc, MemorizationState>(
          builder: (context, state) {
            if (state is StreakStatisticsLoaded) {
              final streakStats = state.streakStatistics;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Streak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StreakIndicator(
                        value: '${streakStats.currentStreak}',
                        label: 'Current',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        isCurrent: true,
                      ),
                      _StreakIndicator(
                        value: '${streakStats.longestStreak}',
                        label: 'Longest',
                        icon: Icons.emoji_events,
                        color: Colors.purple,
                        isCurrent: false,
                      ),
                      _StreakIndicator(
                        value: '${((streakStats.currentStreak / (streakStats.longestStreak > 0 ? streakStats.longestStreak : 1)) * 100).toStringAsFixed(0)}%',
                        label: 'Completion',
                        icon: Icons.percent,
                        color: Colors.blue,
                        isCurrent: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Streak progress visualization
                  _StreakProgressVisualization(
                    currentStreak: streakStats.currentStreak,
                    targetStreak: 30, // Target streak for visualization
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

/// Widget showing streak indicator with visual enhancement
class _StreakIndicator extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isCurrent;

  const _StreakIndicator({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isCurrent ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
            ),
            Icon(icon, color: color, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? color : null,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Widget for visualizing streak progress
class _StreakProgressVisualization extends StatelessWidget {
  final int currentStreak;
  final int targetStreak;

  const _StreakProgressVisualization({
    required this.currentStreak,
    required this.targetStreak,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetStreak > 0 ? (currentStreak / targetStreak).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress to 30-day streak',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            backgroundColor: Colors.grey[300]!,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentStreak/$targetStreak days',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Enhanced quick action button with better visual design
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
  prefs.TimeOfDay? _selectedTime;
  int _reviewPeriod = 5;
  bool _notificationsEnabled = true;
  bool _showOverdueWarnings = true;
  bool _showMotivationalQuotes = true;

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
            _reviewPeriod = preferences.reviewPeriod;
            _notificationsEnabled = preferences.notificationsEnabled;
            _showOverdueWarnings = preferences.showOverdueWarnings;
            _showMotivationalQuotes = preferences.showMotivationalQuotes;
            _selectedTime = preferences.notificationTime;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Review Period',
                    subtitle: 'How often to review memorized items',
                    trailing: DropdownButton<int>(
                      value: _reviewPeriod,
                      items: const [
                        DropdownMenuItem(value: 5, child: Text('5 days')),
                        DropdownMenuItem(value: 6, child: Text('6 days')),
                        DropdownMenuItem(value: 7, child: Text('7 days')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _reviewPeriod = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Memorization Direction',
                    subtitle: 'Order of surahs for memorization',
                    trailing: DropdownButton<String>(
                      value: 'fromBaqarah',
                      items: const [
                        DropdownMenuItem(
                          value: 'fromBaqarah',
                          child: Text('From Al-Baqarah (2)'),
                        ),
                        DropdownMenuItem(
                          value: 'fromNas',
                          child: Text('From An-Nas (114)'),
                        ),
                      ],
                      onChanged: (value) {
                        // Handle direction change
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Enable Notifications',
                    subtitle: 'Receive daily reminders for review',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Notification Time',
                    subtitle: 'When to receive daily reminders',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedTime != null
                              ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                              : 'Not set',
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _selectedTime = prefs.TimeOfDay(
                                  hour: selectedTime.hour,
                                  minute: selectedTime.minute,
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Display Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Show Overdue Warnings',
                    subtitle: 'Highlight items that need review',
                    trailing: Switch(
                      value: _showOverdueWarnings,
                      onChanged: (value) {
                        setState(() {
                          _showOverdueWarnings = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    title: 'Show Motivational Quotes',
                    subtitle: 'Display quotes in notifications',
                    trailing: Switch(
                      value: _showMotivationalQuotes,
                      onChanged: (value) {
                        setState(() {
                          _showMotivationalQuotes = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save preferences
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings saved successfully!'),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Save Settings'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Reusable settings card widget
class _SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}