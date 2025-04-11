import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';

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
              // TODO: Navigate to add habit page
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
          // TODO: Navigate to add habit page
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
              // TODO: Navigate to habit details page
            },
          ),
        );
      },
    );
  }
}
}

/// Placeholder for the Prayer Times page
class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ),
      body: Center(
        child: Text(
          'Prayer Times',
          style: AppTextStyles.headingMedium,
        ),
      ),
    );
  }
}

/// Placeholder for the Dua & Dhikr page
class DuaDhikrPage extends StatelessWidget {
  const DuaDhikrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua & Dhikr'),
      ),
      body: Center(
        child: Text(
          'Dua & Dhikr',
          style: AppTextStyles.headingMedium,
        ),
      ),
    );
  }
}

/// Placeholder for the Analytics page
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Center(
        child: Text(
          'Analytics',
          style: AppTextStyles.headingMedium,
        ),
      ),
    );
  }
}

/// Placeholder for the Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'Settings',
          style: AppTextStyles.headingMedium,
        ),
      ),
    );
  }
}
