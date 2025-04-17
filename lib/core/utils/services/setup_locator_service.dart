// import 'package:get_it/get_it.dart';
// import '/core/utils/services/notification_service.dart';
// import '/core/utils/services/shared_pref_service.dart';
// import '/core/utils/services/sqflite_service.dart';
// import '/features/home/data/repo/jumaa_data_repo_impl.dart';
// import '/features/night_prayer/data/repo/night_prayer_repo_impl.dart';
// import '/features/notification/data/repo/notification_repo_impl.dart';
//
// import '../../../features/early_jumaa/data/repo/early_jumaa_repo_impl.dart';
// import '../../../features/prayer/data/repo/prayer_repo_impl.dart';
// import 'location_service.dart';
//
// final getIt = GetIt.instance;
//
// void setupLocatorService() {
//   getIt.registerSingleton<SharedPrefService>(SharedPrefService());
//   getIt.registerSingleton<SqfliteService>(SqfliteService());
//   getIt.registerSingleton<LocationService>(LocationService());
//   getIt.registerSingleton<NotificationService>(NotificationService());
//
//   getIt.registerSingleton<JumaaDataRepoImpl>(
//       JumaaDataRepoImpl(getIt.get<SqfliteService>()));
//   getIt.registerSingleton<PrayerRepoImpl>(PrayerRepoImpl());
//   getIt.registerSingleton<EarlyJumaaRepoImpl>(EarlyJumaaRepoImpl());
//   getIt.registerSingleton<NightPrayerRepoImpl>(NightPrayerRepoImpl());
//   getIt.registerSingleton<NotificationRepoImpl>(NotificationRepoImpl());
// }
