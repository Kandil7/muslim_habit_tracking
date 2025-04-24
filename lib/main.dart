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
import 'core/utils/services/notification_service.dart';
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

    // Initialize notifications
    await _initializeNotifications();

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

/// Initialize notification services
Future<void> _initializeNotifications() async {
  try {
    // Get the notification service from dependency injection
    final notificationService = di.sl<NotificationService>();

    // Initialize the notification service
    try {
      await notificationService.initNotification();
      debugPrint('Notification service initialized successfully');

      // Request notification permissions
      final permissionsGranted = await notificationService.requestPermissions();
      debugPrint('Notification permissions granted: $permissionsGranted');

      // Register notification handlers
      _registerNotificationHandlers(notificationService);
    } catch (error) {
      debugPrint('Error initializing notification service: $error');
      // Non-critical error, continue app initialization
    }
  } catch (e) {
    debugPrint('Error during notification initialization: $e');
    // Non-critical error, continue app initialization
  }
}

/// Register notification handlers for different notification types
void _registerNotificationHandlers(NotificationService notificationService) {
  // This will be called when the app is in the foreground and a notification is received
  // We can add custom handling for different notification types here
  debugPrint('Registered notification handlers');
}

class SunnahTrackApp extends StatefulWidget {
  const SunnahTrackApp({super.key});

  @override
  State<SunnahTrackApp> createState() => _SunnahTrackAppState();
}

class _SunnahTrackAppState extends State<SunnahTrackApp> {
  /// Generate routes for the app
  ///
  /// This method handles all named routes in the app and returns the appropriate
  /// page based on the route name and arguments.
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    // Map of route names to builder functions
    final routes = {
      '/dhikr-counter':
          (context) => DhikrCounterPage(dhikr: settings.arguments as Dhikr),
      '/add-habit': (context) => const AddHabitPage(),
      '/hadith-collection': (context) => const HadithCollectionPage(),
      '/quran': (context) => const QuranView(),
      '/settings': (context) => const SettingsPage(),
    };

    // Get the builder for the requested route
    final builder = routes[settings.name];

    // If the route exists, create a MaterialPageRoute
    if (builder != null) {
      return MaterialPageRoute(settings: settings, builder: builder);
    }

    // Return null for unknown routes (will use the onUnknownRoute handler if provided)
    return null;
  }

  /// Applies high contrast to the theme for improved accessibility
  ///
  /// This method enhances the visual contrast of the app by:
  /// 1. Using pure black and white colors for maximum contrast
  /// 2. Ensuring text has high contrast against backgrounds
  /// 3. Making interactive elements more distinguishable
  /// 4. Increasing contrast for dividers and borders
  ///
  /// The method respects the current brightness mode (light/dark) and
  /// applies appropriate contrast enhancements for each mode.
  ///
  /// @param theme The original theme to enhance
  /// @return A new ThemeData instance with high contrast settings
  ThemeData _applyHighContrast(ThemeData theme) {
    // Determine colors based on brightness
    // Use pure black/white for maximum contrast in high contrast mode
    final backgroundColor =
        theme.brightness == Brightness.dark ? Colors.black : Colors.white;
    final foregroundColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final dividerColor =
        theme.brightness == Brightness.dark
            ? Colors.white.withAlpha(77) // ~0.3 opacity for dark mode
            : Colors.black.withAlpha(77); // ~0.3 opacity for light mode

    // Create a new theme with enhanced contrast settings
    return theme.copyWith(
      // Modify the color scheme for better contrast
      colorScheme: theme.colorScheme.copyWith(
        // Ensure primary colors have sufficient contrast
        primary: theme.colorScheme.primary, // Keep brand color
        onPrimary: Colors.white, // White text on primary for best readability
        // Enhance secondary colors
        secondary: theme.colorScheme.secondary, // Keep brand secondary color
        onSecondary: Colors.white, // White text on secondary for readability
        // Maximize contrast for surfaces (backgrounds)
        surface: backgroundColor, // Pure black/white for surfaces
        onSurface: foregroundColor, // Opposite color for text on surfaces
        // Make error states highly visible
        error: Colors.red.shade700, // Darker red for better visibility
        onError: Colors.white, // White text on error for readability
      ),

      // Apply high contrast to all text
      textTheme: theme.textTheme.apply(
        bodyColor: foregroundColor, // High contrast text color
        displayColor: foregroundColor, // High contrast heading color
      ),

      // Enhance dividers for better visual separation
      dividerColor: dividerColor,

      // Ensure cards have consistent high contrast
      cardTheme: theme.cardTheme.copyWith(
        color: backgroundColor, // Pure black/white for card backgrounds
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Flatten provider structure for better performance by combining
    // all providers in a single MultiProvider
    return MultiProvider(
      providers: [
        // BLoC providers
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
      child: Builder(
        builder: (context) {
          // Access the language and theme state from the context
          final languageState = context.watch<LanguageCubit>().state;
          final themeState = context.watch<ThemeBloc>().state;

          return MaterialApp(
            title: 'SunnahTracker',
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
              final textSizeProvider = Provider.of<TextSizeProvider>(context);
              final contrastProvider = Provider.of<ContrastProvider>(context);

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
            onGenerateRoute: _generateRoute,
          );
        },
      ),
    );
  }
}
