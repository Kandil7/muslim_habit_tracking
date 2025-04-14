// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jumaa/core/utils/services/location_service.dart';
// import 'package:jumaa/core/utils/services/setup_locator_service.dart';
// import 'package:jumaa/core/utils/services/shared_pref_service.dart';
// import 'package:jumaa/features/home/data/repo/jumaa_data_repo_impl.dart';
// import 'package:jumaa/features/prayer/data/repo/prayer_repo_impl.dart';
//
// import '../../features/home/presentation/manager/app/app_cubit.dart';
// import '../../features/prayer/presentation/manager/prayer/prayer_cubit.dart';
// import '../utils/services/notification_service.dart';
// import 'jumaa_material_app.dart';
//
// class Jumaa extends StatelessWidget {
//   const Jumaa({super.key, required this.navigatorKey});
//   final GlobalKey<NavigatorState> navigatorKey;
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//             create: (context) => AppCubit(
//                   getIt.get<SharedPrefService>(),
//                   getIt.get<JumaaDataRepoImpl>(),
//                   getIt.get<NotificationService>(),
//                 )),
//         BlocProvider(
//             create: (context) => PrayerCubit(
//                 getIt.get<PrayerRepoImpl>(), getIt.get<LocationService>())),
//       ],
//       child: JumaaMaterialApp(navigatorKey: navigatorKey),
//     );
//   }
// }
//
