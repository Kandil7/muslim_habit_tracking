import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../network/network_info.dart';
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
import '../../features/prayer_times/data/datasources/prayer_time_local_data_source.dart';
import '../../features/prayer_times/data/datasources/prayer_time_remote_data_source.dart';
import '../../features/prayer_times/data/repositories/prayer_time_repository_impl.dart';
import '../../features/prayer_times/domain/repositories/prayer_time_repository.dart';
import '../../features/prayer_times/domain/usecases/get_prayer_time_by_date.dart';
import '../../features/prayer_times/domain/usecases/get_prayer_times_by_date_range.dart';
import '../../features/prayer_times/domain/usecases/update_calculation_method.dart';
import '../../features/prayer_times/presentation/bloc/prayer_time_bloc.dart';
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

final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External dependencies
  await _initExternalDependencies();

  // Core
  await _initCore();

  // Features
  await _initHabitTrackingFeature();
  await _initPrayerTimesFeature();
  await _initDuaDhikrFeature();
  await _initAnalyticsFeature();
}

/// Initialize external dependencies
Future<void> _initExternalDependencies() async {
  // Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive boxes
  await Hive.openBox(AppConstants.habitsBoxName);
  await Hive.openBox(AppConstants.prayerTimesBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);
  await Hive.openBox(AppConstants.duaDhikrBoxName);

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
}

/// Initialize habit tracking feature dependencies
Future<void> _initHabitTrackingFeature() async {
  // Data sources
  sl.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(
      habitsBox: Hive.box(AppConstants.habitsBoxName),
      habitLogsBox: Hive.box(AppConstants.habitsBoxName),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
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
  // Data sources
  sl.registerLazySingleton<PrayerTimeLocalDataSource>(
    () => PrayerTimeLocalDataSourceImpl(
      prayerTimesBox: Hive.box(AppConstants.prayerTimesBoxName),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<PrayerTimeRemoteDataSource>(
    () => PrayerTimeRemoteDataSourceImpl(
      client: sl(),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<PrayerTimeRepository>(
    () => PrayerTimeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPrayerTimeByDate(sl()));
  sl.registerLazySingleton(() => GetPrayerTimesByDateRange(sl()));
  sl.registerLazySingleton(() => UpdateCalculationMethod(sl()));

  // BLoC
  sl.registerFactory(
    () => PrayerTimeBloc(
      getPrayerTimeByDate: sl(),
      getPrayerTimesByDateRange: sl(),
      updateCalculationMethod: sl(),
    ),
  );
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
    () => DuaDhikrRepositoryImpl(
      localDataSource: sl(),
    ),
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
    () => AnalyticsDataSourceImpl(
      habitLocalDataSource: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHabitStats(sl()));
  sl.registerLazySingleton(() => GetHabitStatsByDateRange(sl()));

  // BLoC
  sl.registerFactory(
    () => AnalyticsBloc(
      getHabitStats: sl(),
      getHabitStatsByDateRange: sl(),
    ),
  );
}
