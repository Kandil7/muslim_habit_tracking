import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quran_library/quran_library.dart';

import 'core/utils/animation_utils.dart';
import 'core/utils/custom_bloc_observer.dart';

import 'core/di/injection_container.dart' as di;
import 'core/localization/app_localizations.dart';
import 'core/localization/bloc/language_bloc_exports.dart';
import 'core/presentation/widgets/contrast_selector.dart';
import 'core/presentation/widgets/text_size_selector.dart';
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

/// Application entry point with robust error handling
void main() async {
  // Catch any errors during initialization to prevent app crashes
  try {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set up BlocObserver for logging
    Bloc.observer = const CustomBlocObserver(verbose: false);

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).catchError((error) {
      debugPrint('Warning: Could not set preferred orientations: $error');
      // Non-critical error, continue app initialization
    });

    // Initialize dependencies with error handling
    await _initializeDependencies();

    // Run the app immediately to improve startup time
    // We'll initialize QuranLibrary in the background
    runApp(
      MultiProvider(
        providers: [
          BlocProvider<LanguageCubit>(
            create: (context) => di.sl<LanguageCubit>(),
          ),
          ChangeNotifierProvider<TextSizeProvider>(
            create: (context) => TextSizeProvider(),
          ),
          ChangeNotifierProvider<ContrastProvider>(
            create: (context) => ContrastProvider(),
          ),
        ],
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
        // Non-critical error, app can function without QuranLibrary
      }
    });
  } catch (e, stackTrace) {
    // Log fatal error
    debugPrint('Fatal error during app initialization: $e');
    debugPrint(stackTrace.toString());

    // Show error screen instead of crashing
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'An error occurred during startup. Please restart the app.\nError: $e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Initialize all dependencies with proper error handling
Future<void> _initializeDependencies() async {
  try {
    // Initialize dependency injection
    await di.init().catchError((error) {
      debugPrint('Error initializing dependencies: $error');
      throw Exception('Failed to initialize dependencies: $error');
    });

    // Initialize cache manager
    final cacheManager = CacheManager();
    await cacheManager.init().catchError((error) {
      debugPrint('Error initializing cache manager: $error');
      // Non-critical error, continue app initialization
    });

    // Initialize animation utils
    await AnimationUtils.init().catchError((error) {
      debugPrint('Error initializing animation utils: $error');
      // Non-critical error, continue app initialization
    });
  } catch (e) {
    debugPrint('Error during dependency initialization: $e');
    throw Exception('Failed to initialize app dependencies: $e');
  }
}

class SunnahTrackApp extends StatefulWidget {
  const SunnahTrackApp({super.key});

  @override
  State<SunnahTrackApp> createState() => _SunnahTrackAppState();
}

class _SunnahTrackAppState extends State<SunnahTrackApp> {
  /// Applies high contrast to the theme
  ThemeData _applyHighContrast(ThemeData theme) {
    // Determine colors based on brightness
    final backgroundColor =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white;
    final foregroundColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final dividerColor =
        theme.brightness == Brightness.dark
            ? Colors.white.withAlpha(77) // ~0.3 opacity
            : Colors.black.withAlpha(77); // ~0.3 opacity

    // Increase contrast by using more distinct colors
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        // Increase contrast for primary colors
        primary: theme.colorScheme.primary,
        onPrimary: Colors.white,
        // Increase contrast for secondary colors
        secondary: theme.colorScheme.secondary,
        onSecondary: Colors.white,
        // Increase contrast for surface
        surface: backgroundColor,
        onSurface: foregroundColor,
        // Increase contrast for error
        error: Colors.red.shade700,
        onError: Colors.white,
      ),
      // Increase text contrast
      textTheme: theme.textTheme.apply(
        bodyColor: foregroundColor,
        displayColor: foregroundColor,
      ),
      // Increase divider contrast
      dividerColor: dividerColor,
      // Increase card contrast
      cardTheme: theme.cardTheme.copyWith(color: backgroundColor),
    );
  }

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
                // RTL support and accessibility features
                builder: (context, child) {
                  final textSizeProvider = Provider.of<TextSizeProvider>(
                    context,
                  );
                  final contrastProvider = Provider.of<ContrastProvider>(
                    context,
                  );

                  // Apply high contrast theme if needed
                  final theme =
                      contrastProvider.isHighContrast
                          ? _applyHighContrast(Theme.of(context))
                          : null;

                  return Theme(
                    data: theme ?? Theme.of(context),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(
                          textSizeProvider.textScaleFactor,
                        ),
                      ),
                      child: Directionality(
                        textDirection:
                            languageState.isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        child: child!,
                      ),
                    ),
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
