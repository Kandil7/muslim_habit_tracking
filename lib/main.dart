import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_library/quran_library.dart';

import 'core/utils/custom_bloc_observer.dart';

import 'core/di/injection_container.dart' as di;
import 'core/localization/app_localizations.dart';
import 'core/localization/bloc/language_bloc_exports.dart';
import 'core/services/cache_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc_exports.dart';
import 'core/utils/services/location_service.dart';
import 'features/prayer_times/data/repo/prayer_repo_impl.dart';
import 'features/prayer_times/presentation/manager/prayer/prayer_cubit.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';
import 'features/dua_dhikr/domain/entities/dhikr.dart';
import 'features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'features/dua_dhikr/presentation/bloc/dua_dhikr_event.dart';
import 'features/dua_dhikr/presentation/pages/dhikr_counter_page.dart';
import 'features/habit_tracking/presentation/bloc/habit_bloc.dart';
import 'features/habit_tracking/presentation/bloc/habit_event.dart';
import 'features/habit_tracking/presentation/pages/add_habit_page.dart';
import 'features/hadith/presentation/bloc/hadith_bloc.dart';
import 'features/hadith/presentation/bloc/hadith_event.dart';
import 'features/hadith/presentation/pages/hadith_collection_page.dart';
import 'features/quran/presentation/bloc/quran_bloc.dart';
import 'features/quran/presentation/pages/quran_view.dart';
import 'features/settings/presentation/pages/settings_page.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up BlocObserver for logging
  Bloc.observer = const CustomBlocObserver(verbose: false);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await di.init();

  // Initialize cache manager
  final cacheManager = CacheManager();
  await cacheManager.init();

  // Run the app immediately to improve startup time
  // We'll initialize QuranLibrary in the background
  runApp(
    BlocProvider<LanguageCubit>(
      create: (context) => di.sl<LanguageCubit>(),
      child: const SunnahTrackApp(),
    ),
  );

  // Initialize QuranLibrary after the app has started
  // This prevents blocking the main thread during startup
  Future.microtask(() {
    try {
      QuranLibrary().init();
    } catch (e) {
      debugPrint('Error initializing QuranLibrary: $e');
    }
  });
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
        BlocProvider<PrayerCubit>(
          create:
              (context) => PrayerCubit(
                di.sl<PrayerRepoImpl>(),
                di.sl<LocationService>(),
              ),
        ),
        BlocProvider<DuaDhikrBloc>(
          create: (context) => di.sl<DuaDhikrBloc>()..add(GetAllDhikrsEvent()),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (context) => di.sl<AnalyticsBloc>(),
        ),
        BlocProvider<HadithBloc>(
          create:
              (context) =>
                  di.sl<HadithBloc>()..add(const GetHadithOfTheDayEvent()),
        ),
        BlocProvider<QuranBloc>(create: (context) => di.sl<QuranBloc>()),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Muslim Habbit',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: languageState.locale,
                supportedLocales: const [
                  Locale('en', ''), // English
                  Locale('ar', ''), // Arabic
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // RTL support based on the current locale
                builder: (context, child) {
                  return Directionality(
                    textDirection:
                        languageState.isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: child!,
                  );
                },
                home: const SplashPage(),
                onGenerateRoute: (settings) {
                  // Handle named routes
                  if (settings.name == '/dhikr-counter') {
                    // Extract the Dhikr argument
                    final dhikr = settings.arguments as Dhikr;
                    return MaterialPageRoute(
                      builder: (context) => DhikrCounterPage(dhikr: dhikr),
                    );
                  } else if (settings.name == '/add-habit') {
                    return MaterialPageRoute(
                      builder: (context) => const AddHabitPage(),
                    );
                  } else if (settings.name == '/hadith-collection') {
                    return MaterialPageRoute(
                      builder: (context) => const HadithCollectionPage(),
                    );
                  } else if (settings.name == '/quran') {
                    return MaterialPageRoute(
                      builder: (context) => const QuranView(),
                    );
                  } else if (settings.name == '/settings') {
                    return MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    );
                  }
                  return null;
                },
              );
            },
          );
        },
      ),
    );
  }
}
