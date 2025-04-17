import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../habit_tracking/presentation/bloc/habit_bloc.dart';
import '../../../habit_tracking/presentation/bloc/habit_state.dart';
import '../../../prayer_times/presentation/manager/prayer/prayer_cubit.dart';
import '../../../prayer_times/presentation/manager/prayer/prayer_state.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/habits_summary_card.dart';
import '../widgets/quran_card.dart';
import '../widgets/dhikr_card.dart';

/// The main home dashboard page
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunnahTrack'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.dark
                      ? AppIcons.themeDark
                      : AppIcons.themeLight,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
                tooltip: 'Toggle Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data
          context.read<PrayerCubit>().getPrayerTimes(forceRefresh: true);
          // Add other refresh actions here
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                _buildGreetingSection(context),
                const SizedBox(height: 24),
                
                // Prayer times section
                _buildPrayerTimesSection(context),
                const SizedBox(height: 24),
                
                // Habits section
                _buildHabitsSection(context),
                const SizedBox(height: 24),
                
                // Quran section
                const QuranCard(),
                const SizedBox(height: 24),
                
                // Dhikr section
                const DhikrCard(),
                const SizedBox(height: 24),
                
                // Quick actions section
                _buildQuickActionsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGreetingSection(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your Islamic dashboard for today',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPrayerTimesSection(BuildContext context) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        if (state is PrayerInitial) {
          context.read<PrayerCubit>().getPrayerTimes();
          return const LoadingIndicator(text: 'Loading prayer times...');
        } else if (state is GetPrayerSuccess) {
          return PrayerTimesCard(
            prayerList: context.read<PrayerCubit>().prayerList,
            nextPrayer: context.read<PrayerCubit>().nextPrayer,
          );
        } else if (state is GetPrayerError) {
          return DashboardCard(
            title: 'Prayer Times',
            icon: AppIcons.prayer,
            child: Column(
              children: [
                const Text('Failed to load prayer times'),
                TextButton(
                  onPressed: () {
                    context.read<PrayerCubit>().getPrayerTimes(forceRefresh: true);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return const LoadingIndicator(text: 'Loading prayer times...');
        }
      },
    );
  }
  
  Widget _buildHabitsSection(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitLoading) {
          return const LoadingIndicator(text: 'Loading habits...');
        } else if (state is HabitsLoaded) {
          return HabitsSummaryCard(habits: state.habits);
        } else if (state is HabitError) {
          return DashboardCard(
            title: 'Habits',
            icon: AppIcons.habit,
            child: Column(
              children: [
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () {
                    context.read<HabitBloc>().add(GetHabitsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return const DashboardCard(
            title: 'Habits',
            icon: AppIcons.habit,
            child: Text('No habits found'),
          );
        }
      },
    );
  }
  
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headingSmall,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem(
              context,
              icon: AppIcons.habit,
              label: 'Add Habit',
              onTap: () {
                Navigator.pushNamed(context, '/add-habit');
              },
            ),
            _buildQuickActionItem(
              context,
              icon: AppIcons.prayer,
              label: 'Prayer Times',
              onTap: () {
                // Switch to prayer tab
                // This would be handled by the parent HomePage
              },
            ),
            _buildQuickActionItem(
              context,
              icon: AppIcons.dua,
              label: 'Duas',
              onTap: () {
                // Switch to dua tab
                // This would be handled by the parent HomePage
              },
            ),
            _buildQuickActionItem(
              context,
              icon: AppIcons.analytics,
              label: 'Analytics',
              onTap: () {
                // Switch to analytics tab
                // This would be handled by the parent HomePage
              },
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
