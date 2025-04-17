import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:muslim_habbit/core/utils/services/notification_service.dart';
import 'package:muslim_habbit/core/utils/services/shared_pref_service.dart';
import 'package:muslim_habbit/features/prayer_times/presentation/manager/prayer/prayer_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../features/notification/data/repo/notification_repo_impl.dart';
import '../../features/notification/presentation/manager/notification/notification_cubit.dart';
import '../../features/prayer_times/data/repo/prayer_repo_impl.dart';
import '../localization/bloc/language_bloc_exports.dart';

import '../constants/app_constants.dart';
import '../network/network_info.dart';
import '../services/cache_manager.dart';
import '../../features/habit_tracking/data/datasources/habit_local_data_source.dart';
import '../../features/habit_tracking/data/repositories/habit_repository_impl.dart';
import '../../features/habit_tracking/domain/repositories/habit_repository.dart';
import '../../features/habit_tracking/domain/usecases/create_habit.dart';
import '../../features/habit_tracking/domain/usecases/create_habit_log.dart';
import '../../features/habit_tracking/domain/usecases/delete_habit.dart';
import '../../features/habit_tracking/domain/usecases/get_habit_logs_by_date_range.dart';
import '../../features/habit_tracking/domain/usecases/get_habits.dart';
import '../../features/habit_tracking/domain/usecases/update_habit.dart';
import '../../features/habit_tracking/presentation/bloc/habit_bloc.dart';

import '../../features/dua_dhikr/data/datasources/dua_dhikr_local_data_source.dart';
import '../../features/dua_dhikr/data/repositories/dua_dhikr_repository_impl.dart';
import '../../features/dua_dhikr/domain/repositories/dua_dhikr_repository.dart';
import '../../features/dua_dhikr/domain/usecases/get_all_dhikrs.dart';
import '../../features/dua_dhikr/domain/usecases/get_duas_by_category.dart';
import '../../features/dua_dhikr/domain/usecases/toggle_dua_favorite.dart';
import '../../features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import '../../features/analytics/data/datasources/analytics_data_source.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/domain/usecases/get_habit_stats.dart';
import '../../features/analytics/domain/usecases/get_habit_stats_by_date_range.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../utils/services/location_service.dart';

import '../../features/habit_tracking/data/repositories/habit_reminder_repository_impl.dart';
import '../../features/habit_tracking/data/services/habit_notification_service.dart';
import '../../features/habit_tracking/domain/repositories/habit_reminder_repository.dart';
import '../../features/home/data/services/home_preferences_service.dart';
import '../../features/home/presentation/bloc/home_dashboard_bloc.dart';
import '../../features/hadith/data/datasources/hadith_local_data_source.dart';
import '../../features/hadith/data/repositories/hadith_repository_impl.dart';
import '../../features/hadith/domain/repositories/hadith_repository.dart';
import '../../features/hadith/domain/usecases/get_all_hadiths.dart';
import '../../features/hadith/domain/usecases/get_hadith_by_id.dart';
import '../../features/hadith/domain/usecases/get_hadith_of_the_day.dart';
import '../../features/hadith/domain/usecases/toggle_hadith_bookmark.dart';
import '../../features/hadith/presentation/bloc/hadith_bloc.dart';
import '../../features/quran/data/datasources/quran_local_data_source.dart';
import '../../features/quran/data/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/domain/usecases/add_bookmark.dart';
import '../../features/quran/domain/usecases/add_reading_history.dart';
import '../../features/quran/domain/usecases/get_all_surahs.dart';
import '../../features/quran/domain/usecases/get_bookmarks.dart';
import '../../features/quran/domain/usecases/get_last_read_position.dart';
import '../../features/quran/domain/usecases/get_reading_history.dart';
import '../../features/quran/domain/usecases/get_surah_by_id.dart';
import '../../features/quran/domain/usecases/remove_bookmark.dart';
import '../../features/quran/domain/usecases/update_last_read_position.dart';
import '../../features/quran/presentation/bloc/quran_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External dependencies
  await _initExternalDependencies();

  // Core
  await _initCore();

  // Features
  await _initHomeFeature();
  await _initHabitTrackingFeature();
  await _initPrayerTimesFeature();
  await _initDuaDhikrFeature();
  await _initAnalyticsFeature();
  await _initLocalizationFeature();
  await _initHadithFeature();
  await _initQuranFeature();
}

/// Initialize external dependencies
Future<void> _initExternalDependencies() async {
  // Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive boxes
  await Hive.openBox(AppConstants.habitsBoxName);
  await Hive.openBox(AppConstants.habitLogsBoxName);
  await Hive.openBox(AppConstants.prayerTimesBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);
  await Hive.openBox(AppConstants.duaDhikrBoxName);
  await Hive.openBox(AppConstants.hadithBoxName);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Http client
  sl.registerLazySingleton(() => http.Client());

  // Internet connection checker
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // UUID
  sl.registerLazySingleton(() => const Uuid());
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Cache Manager
  sl.registerLazySingleton(() => CacheManager());

  // Initialize SharedPrefService
  await SharedPrefService.init();

  // Register SharedPrefService
  sl.registerLazySingleton<SharedPrefService>(() => SharedPrefService());
}

/// Initialize habit tracking feature dependencies
Future<void> _initHabitTrackingFeature() async {
  // Register Hive boxes
  await Hive.openBox(AppConstants.categoriesBoxName);

  // Services
  sl.registerLazySingleton<HabitNotificationService>(
    () => HabitNotificationService(),
  );

  // Data sources
  sl.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(
      habitsBox: Hive.box(AppConstants.habitsBoxName),
      habitLogsBox: Hive.box(AppConstants.habitLogsBoxName),
      categoriesBox: Hive.box(AppConstants.categoriesBoxName),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<HabitReminderRepository>(
    () => HabitReminderRepositoryImpl(
      sharedPreferences: sl(),
      notificationService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHabits(sl()));
  sl.registerLazySingleton(() => CreateHabit(sl()));
  sl.registerLazySingleton(() => UpdateHabit(sl()));
  sl.registerLazySingleton(() => DeleteHabit(sl()));
  sl.registerLazySingleton(() => GetHabitLogsByDateRange(sl()));
  sl.registerLazySingleton(() => CreateHabitLog(sl()));

  // BLoC
  sl.registerFactory(
    () => HabitBloc(
      getHabits: sl(),
      createHabit: sl(),
      updateHabit: sl(),
      deleteHabit: sl(),
      getHabitLogsByDateRange: sl(),
      createHabitLog: sl(),
    ),
  );
}

/// Initialize prayer times feature dependencies
Future<void> _initPrayerTimesFeature() async {
  // Services
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => NotificationService());

  // Repositories
  sl.registerSingleton<PrayerRepoImpl>(PrayerRepoImpl());
  sl.registerSingleton<NotificationRepoImpl>(NotificationRepoImpl());

  // BLoC
  sl.registerFactory(() => PrayerCubit(sl(), sl()));
  sl.registerFactory(() => NotificationCubit(sl(), sl()));
}

/// Initialize dua & dhikr feature dependencies
Future<void> _initDuaDhikrFeature() async {
  // Data sources
  sl.registerLazySingleton<DuaDhikrLocalDataSource>(
    () => DuaDhikrLocalDataSourceImpl(
      duaDhikrBox: Hive.box(AppConstants.duaDhikrBoxName),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DuaDhikrRepository>(
    () => DuaDhikrRepositoryImpl(localDataSource: sl(), cacheManager: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDuasByCategory(sl()));
  sl.registerLazySingleton(() => GetAllDhikrs(sl()));
  sl.registerLazySingleton(() => ToggleDuaFavorite(sl()));

  // BLoC
  sl.registerFactory(
    () => DuaDhikrBloc(
      getDuasByCategory: sl(),
      getAllDhikrs: sl(),
      toggleDuaFavorite: sl(),
    ),
  );
}

/// Initialize analytics feature dependencies
Future<void> _initAnalyticsFeature() async {
  // Data sources
  sl.registerLazySingleton<AnalyticsDataSource>(
    () => AnalyticsDataSourceImpl(habitLocalDataSource: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHabitStats(sl()));
  sl.registerLazySingleton(() => GetHabitStatsByDateRange(sl()));

  // BLoC
  sl.registerFactory(
    () => AnalyticsBloc(getHabitStats: sl(), getHabitStatsByDateRange: sl()),
  );
}

/// Initialize localization feature dependencies
Future<void> _initLocalizationFeature() async {
  // Register the LanguageCubit
  sl.registerFactory(() => LanguageCubit(sl()));
}

/// Initialize home feature dependencies
Future<void> _initHomeFeature() async {
  // Services
  sl.registerLazySingleton<HomePreferencesService>(
    () => HomePreferencesService(sharedPreferences: sl()),
  );

  // BLoC
  sl.registerFactory(() => HomeDashboardBloc(preferencesService: sl()));
}

/// Initialize hadith feature dependencies
Future<void> _initHadithFeature() async {
  // Data sources
  sl.registerLazySingleton<HadithLocalDataSource>(
    () => HadithLocalDataSourceImpl(
      hadithBox: Hive.box(AppConstants.hadithBoxName),
    ),
  );

  // Initialize with sample data
  await sl<HadithLocalDataSource>().initializeWithSampleData();

  // Repositories
  sl.registerLazySingleton<HadithRepository>(
    () => HadithRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllHadiths(sl()));
  sl.registerLazySingleton(() => GetHadithById(sl()));
  sl.registerLazySingleton(() => GetHadithOfTheDay(sl()));
  sl.registerLazySingleton(() => ToggleHadithBookmark(sl()));

  // BLoC
  sl.registerFactory(
    () => HadithBloc(
      getAllHadiths: sl(),
      getHadithById: sl(),
      getHadithOfTheDay: sl(),
      toggleHadithBookmark: sl(),
    ),
  );
}

/// Initialize Quran feature dependencies
Future<void> _initQuranFeature() async {
  // Register Hive box
  await Hive.openBox(AppConstants.quranBoxName);

  // Data sources
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(
      quranBox: Hive.box(AppConstants.quranBoxName),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllSurahs(sl()));
  sl.registerLazySingleton(() => GetSurahById(sl()));
  sl.registerLazySingleton(() => GetBookmarks(sl()));
  sl.registerLazySingleton(() => AddBookmark(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));
  sl.registerLazySingleton(() => GetReadingHistory(sl()));
  sl.registerLazySingleton(() => AddReadingHistory(sl()));
  sl.registerLazySingleton(() => GetLastReadPosition(sl()));
  sl.registerLazySingleton(() => UpdateLastReadPosition(sl()));

  // BLoC
  sl.registerFactory(
    () => QuranBloc(
      getAllSurahs: sl(),
      getSurahById: sl(),
      getBookmarks: sl(),
      addBookmark: sl(),
      removeBookmark: sl(),
      getReadingHistory: sl(),
      addReadingHistory: sl(),
      getLastReadPosition: sl(),
      updateLastReadPosition: sl(),
    ),
  );
}
