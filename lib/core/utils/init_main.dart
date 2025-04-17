// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import '/core/utils/cached_images.dart';
// import '/core/utils/custom_bloc_observer.dart';
// import '/core/utils/helper.dart';
// import '/core/widgets/jumaa.dart';
// import '/core/utils/firebase_options.dart';
// import 'package:quran_library/quran.dart';
//
// import 'services/setup_locator_service.dart';
// import 'services/shared_pref_service.dart';
//
// Future<void> initMain() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Bloc.observer = CustomBlocObserver();
//   Helper.setSystemSetting();
//   setupLocatorService();
//
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   await Future.wait([
//     QuranLibrary().init(),
//     initializeDateFormatting('ar_EG', null),
//     SharedPrefService.init(),
//   ]);
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   WidgetsBinding.instance.addPostFrameCallback((_) async {
//     await CachedImages.loadImages(navigatorKey.currentContext!);
//   });
//
//   runApp(DevicePreview(
//       enabled: false, builder: (context) => Jumaa(navigatorKey: navigatorKey)));
// }
