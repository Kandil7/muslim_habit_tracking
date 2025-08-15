import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dua_dhikr_page.dart';

import 'package:muslim_habbit/features/habit_tracking/presentation/pages/habit_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_view.dart';
import 'package:muslim_habbit/features/settings/presentation/pages/app_settings_page.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../home/presentation/bloc/home_dashboard_bloc.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';

import '../../../home/presentation/pages/home_dashboard_page.dart';
import '../../../prayer_times/presentation/views/prayer_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BlocProvider<HomeDashboardBloc>(
      create: (context) => di.sl<HomeDashboardBloc>(),
      child: const HomeDashboardPage(),
    ),
    const HabitDashboardPage(),
    const PrayerView(),
    const QuranView(),
    const DuaDhikrPage(),
    const AnalyticsPage(),
    const AppSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(milliseconds: 500),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.homeOutlined),
              selectedIcon: Icon(AppIcons.home),
              label: 'Habits',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.prayerOutlined),
              selectedIcon: Icon(AppIcons.prayer),
              label: 'Prayer',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Quran',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.duaOutlined),
              selectedIcon: Icon(AppIcons.dua),
              label: 'Dua',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.analyticsOutlined),
              selectedIcon: Icon(AppIcons.analytics),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(AppIcons.settingsOutlined),
              selectedIcon: Icon(AppIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
