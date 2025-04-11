import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';
import 'features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'features/habit_tracking/presentation/bloc/habit_bloc.dart';
import 'features/habit_tracking/presentation/pages/home_page.dart';
import 'features/prayer_times/presentation/bloc/prayer_time_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await di.init();

  runApp(const SunnahTrackApp());
}

class SunnahTrackApp extends StatelessWidget {
  const SunnahTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: MaterialApp(
        title: 'SunnahTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
