import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../analytics/domain/entities/habit_stats.dart';
import '../../../analytics/presentation/bloc/analytics_bloc.dart';
import '../../../analytics/presentation/bloc/analytics_event.dart';
import '../../../analytics/presentation/bloc/analytics_state.dart';
import '../../../analytics/presentation/pages/habit_stats_detail_page.dart';
import '../../../dua_dhikr/domain/entities/dua.dart';
import '../../../dua_dhikr/domain/entities/dhikr.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_event.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_state.dart';
import '../../../dua_dhikr/presentation/pages/dhikr_counter_page.dart';
import '../../../prayer_times/domain/entities/prayer_time.dart';
import '../../../prayer_times/presentation/bloc/prayer_time_bloc.dart';
import '../../../prayer_times/presentation/bloc/prayer_time_state.dart';
import '../../../prayer_times/presentation/pages/prayer_settings_page.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import 'add_habit_page.dart';
import 'habit_details_page.dart';

/// The main home page of the application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HabitDashboardPage(),
    const PrayerTimesPage(),
    const DuaDhikrPage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Dua',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Habit Dashboard page
class HabitDashboardPage extends StatelessWidget {
  const HabitDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunnahTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHabitPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HabitsLoaded) {
            return _buildHabitsList(context, state.habits);
          } else if (state is HabitError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No habits found. Add one!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitsList(BuildContext context, List<Habit> habits) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No habits yet',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first habit',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Color(int.parse('0xFF${habit.color.substring(1)}')),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            title: Text(
              habit.name,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              habit.description,
              style: AppTextStyles.bodySmall,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Show habit options
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailsPage(habit: habit),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Prayer Times page
class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
        builder: (context, state) {
          if (state is PrayerTimeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrayerTimeLoaded) {
            return _buildPrayerTimesView(context, state.prayerTime);
          } else if (state is PrayerTimeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No prayer times available'));
          }
        },
      ),
    );
  }

  Widget _buildPrayerTimesView(BuildContext context, PrayerTime prayerTime) {
    final now = DateTime.now();
    final nextPrayer = prayerTime.getNextPrayer(now);
    final nextPrayerName = nextPrayer.keys.first;
    final nextPrayerTime = nextPrayer.values.first;

    return Column(
      children: [
        // Date and next prayer
        Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.primary,
          width: double.infinity,
          child: Column(
            children: [
              Text(
                DateTimeUtils.formatDate(prayerTime.date),
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Next Prayer',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              Text(
                nextPrayerName,
                style: AppTextStyles.headingLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                DateTimeUtils.formatTime(nextPrayerTime),
                style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              // Countdown
              Text(
                'In ${_formatTimeRemaining(nextPrayerTime, now)}',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),

        // Prayer times list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPrayerTimeItem('Fajr', prayerTime.fajr, AppColors.fajrColor, now),
              _buildPrayerTimeItem('Sunrise', prayerTime.sunrise, AppColors.dhuhrColor.withOpacity(0.7), now),
              _buildPrayerTimeItem('Dhuhr', prayerTime.dhuhr, AppColors.dhuhrColor, now),
              _buildPrayerTimeItem('Asr', prayerTime.asr, AppColors.asrColor, now),
              _buildPrayerTimeItem('Maghrib', prayerTime.maghrib, AppColors.maghribColor, now),
              _buildPrayerTimeItem('Isha', prayerTime.isha, AppColors.ishaColor, now),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimeItem(String name, DateTime time, Color color, DateTime now) {
    final isPast = time.isBefore(now);
    final isNext = !isPast && now.isBefore(time) &&
                  !now.isAfter(time.subtract(const Duration(hours: 2)));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            isPast ? Icons.check : Icons.access_time,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          DateTimeUtils.formatTime(time),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatTimeRemaining(DateTime futureTime, DateTime now) {
    final difference = futureTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    } else {
      return '${minutes > 0 ? '$minutes min' : 'less than a minute'}';
    }
  }
}

/// Dua & Dhikr page
class DuaDhikrPage extends StatefulWidget {
  const DuaDhikrPage({super.key});

  @override
  State<DuaDhikrPage> createState() => _DuaDhikrPageState();
}

class _DuaDhikrPageState extends State<DuaDhikrPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Dua & Dhikr'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Duas'),
            Tab(text: 'Dhikr'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDuasTab(),
          _buildDhikrTab(),
        ],
      ),
    );
  }

  Widget _buildDuasTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DuaDhikrLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DuasLoaded) {
          return _buildDuasList(state.duas);
        } else {
          // Trigger loading of duas by category
          context.read<DuaDhikrBloc>().add(const GetDuasByCategoryEvent(category: 'Morning'));
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildDuasList(List<Dua> duas) {
    if (duas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No duas available',
              style: AppTextStyles.headingMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              dua.title,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              dua.category,
              style: AppTextStyles.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(
                dua.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: dua.isFavorite ? AppColors.secondary : null,
              ),
              onPressed: () {
                context.read<DuaDhikrBloc>().add(ToggleDuaFavoriteEvent(id: dua.id));
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text
                    Text(
                      dua.arabicText,
                      style: AppTextStyles.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Transliteration
                    Text(
                      dua.transliteration,
                      style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    Text(
                      dua.translation,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Reference
                    Text(
                      dua.reference,
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDhikrTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DuaDhikrLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DhikrsLoaded) {
          return _buildDhikrList(state.dhikrs);
        } else {
          // Trigger loading of dhikrs
          context.read<DuaDhikrBloc>().add(GetAllDhikrsEvent());
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildDhikrList(List<Dhikr> dhikrs) {
    if (dhikrs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.repeat,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No dhikrs available',
              style: AppTextStyles.headingMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = dhikrs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              dhikr.title,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              'Recommended: ${dhikr.recommendedCount} times',
              style: AppTextStyles.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(
                dhikr.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: dhikr.isFavorite ? AppColors.secondary : null,
              ),
              onPressed: () {
                context.read<DuaDhikrBloc>().add(ToggleDhikrFavoriteEvent(id: dhikr.id));
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text
                    Text(
                      dhikr.arabicText,
                      style: AppTextStyles.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Transliteration
                    Text(
                      dhikr.transliteration,
                      style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    Text(
                      dhikr.translation,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Reference
                    Text(
                      dhikr.reference,
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Count'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DhikrCounterPage(dhikr: dhikr),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Analytics page
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is HabitStatsByDateRangeLoaded) {
            return _buildAnalyticsView(state.habitStats);
          } else if (state is AnalyticsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No analytics available'));
          }
        },
      ),
    );
  }

  Widget _buildAnalyticsView(List<HabitStats> habitStats) {
    if (habitStats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No analytics available',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking habits to see analytics',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date range
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Analytics for',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${DateTimeUtils.formatShortDate(_startDate)} - ${DateTimeUtils.formatShortDate(_endDate)}',
                    style: AppTextStyles.headingSmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Overall completion rate
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Completion Rate',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: overallCompletionRate / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${overallCompletionRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Most consistent habit
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Most Consistent Habit',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.success,
                      child: const Icon(Icons.emoji_events, color: Colors.white),
                    ),
                    title: Text(
                      mostConsistentHabit.habitName,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Completion rate: ${mostConsistentHabit.completionRate.toStringAsFixed(1)}%',
                    ),
                    trailing: Text(
                      '${mostConsistentHabit.currentStreak} day streak',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Least consistent habit
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Needs Improvement',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.warning,
                      child: const Icon(Icons.warning, color: Colors.white),
                    ),
                    title: Text(
                      leastConsistentHabit.habitName,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Completion rate: ${leastConsistentHabit.completionRate.toStringAsFixed(1)}%',
                    ),
                    trailing: Text(
                      '${leastConsistentHabit.completionCount}/${leastConsistentHabit.totalDays} days',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // All habits stats
          Text(
            'All Habits',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 8),
          ...habitStats.map((stats) => _buildHabitStatsCard(stats)).toList(),
        ],
      ),
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
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Completion', '${stats.completionRate.toStringAsFixed(1)}%'),
                _buildStatItem('Current Streak', '${stats.currentStreak} days'),
                _buildStatItem('Longest Streak', '${stats.longestStreak} days'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: stats.completionRate / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

/// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App info section
          _buildSectionHeader('App Info'),
          _buildSettingsCard(
            title: 'SunnahTrack',
            subtitle: 'Version 1.0.0',
            leading: const Icon(Icons.info_outline),
            onTap: () {
              // TODO: Show app info dialog
            },
          ),
          const SizedBox(height: 16),

          // Prayer settings section
          _buildSectionHeader('Prayer Settings'),
          _buildSettingsCard(
            title: 'Prayer Times Calculation Method',
            subtitle: 'Muslim World League',
            leading: const Icon(Icons.calculate),
            onTap: () {
              // TODO: Navigate to prayer calculation method settings
            },
          ),
          _buildSettingsCard(
            title: 'Location',
            subtitle: 'Automatic',
            leading: const Icon(Icons.location_on),
            onTap: () {
              // TODO: Navigate to location settings
            },
          ),
          _buildSettingsCard(
            title: 'Prayer Notifications',
            subtitle: '15 minutes before prayer',
            leading: const Icon(Icons.notifications),
            onTap: () {
              // TODO: Navigate to prayer notification settings
            },
          ),
          const SizedBox(height: 16),

          // Appearance section
          _buildSectionHeader('Appearance'),
          _buildSettingsCard(
            title: 'Theme',
            subtitle: 'System default',
            leading: const Icon(Icons.brightness_6),
            onTap: () {
              // TODO: Show theme selection dialog
            },
          ),
          _buildSettingsCard(
            title: 'Language',
            subtitle: 'English',
            leading: const Icon(Icons.language),
            onTap: () {
              // TODO: Show language selection dialog
            },
          ),
          const SizedBox(height: 16),

          // Data section
          _buildSectionHeader('Data'),
          _buildSettingsCard(
            title: 'Export Data',
            subtitle: 'Export your habits and progress',
            leading: const Icon(Icons.upload),
            onTap: () {
              // TODO: Implement data export
            },
          ),
          _buildSettingsCard(
            title: 'Import Data',
            subtitle: 'Import habits and progress',
            leading: const Icon(Icons.download),
            onTap: () {
              // TODO: Implement data import
            },
          ),
          _buildSettingsCard(
            title: 'Clear All Data',
            subtitle: 'Delete all habits and progress',
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            onTap: () {
              // TODO: Show clear data confirmation dialog
            },
          ),
          const SizedBox(height: 32),

          // About section
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Show about dialog
              },
              child: const Text('About SunnahTrack'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required Icon leading,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
