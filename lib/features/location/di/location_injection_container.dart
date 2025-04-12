import 'package:get_it/get_it.dart';

import '../data/repositories/location_repository_impl.dart';
import '../data/services/location_service.dart';
import '../domain/repositories/location_repository.dart';
import '../presentation/bloc/location_bloc.dart';

/// Register location dependencies
void registerLocationDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => LocationBloc(locationRepository: sl()),
  );
  
  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      locationService: sl(),
      networkInfo: sl(),
    ),
  );
  
  // Service
  sl.registerLazySingleton(
    () => LocationService(sharedPreferences: sl()),
  );
}
