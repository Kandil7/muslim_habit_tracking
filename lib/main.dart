import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injection_container.dart' as di;
import 'core/services/cache_manager.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc_exports.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';
import 'features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'features/dua_dhikr/presentation/bloc/dua_dhikr_event.dart';
import 'features/habit_tracking/presentation/bloc/habit_bloc.dart';
import 'features/habit_tracking/presentation/bloc/habit_event.dart';
import 'features/habit_tracking/presentation/pages/home_page.dart';
import 'features/prayer_times/presentation/bloc/prayer_time_bloc.dart';
import 'features/prayer_times/presentation/bloc/prayer_time_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await di.init();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  // Initialize cache manager
  final cacheManager = CacheManager();
  await cacheManager.init();

  runApp(const SunnahTrackApp());
}

class SunnahTrackApp extends StatefulWidget {
  const SunnahTrackApp({super.key});

  @override
  State<SunnahTrackApp> createState() => _SunnahTrackAppState();
}

class _SunnahTrackAppState extends State<SunnahTrackApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(const LoadThemeEvent()),
        ),
        BlocProvider<HabitBloc>(
          create: (context) => di.sl<HabitBloc>()..add(GetHabitsEvent()),
        ),
        BlocProvider<PrayerTimeBloc>(
          create: (context) => di.sl<PrayerTimeBloc>()..add(GetPrayerTimeByDateEvent(date: DateTime.now())),
        ),
        BlocProvider<DuaDhikrBloc>(
          create: (context) => di.sl<DuaDhikrBloc>()..add(GetAllDhikrsEvent()),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (context) => di.sl<AnalyticsBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'SunnahTrack',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
