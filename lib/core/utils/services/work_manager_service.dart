// import 'dart:developer';
//
// import 'package:flutter/widgets.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:worker_manager/worker_manager.dart';
//
// import '../../../features/notification/data/repo/notification_repo_impl.dart';
// import '../../di/injection_container.dart';
// import 'setup_locator_service.dart';
// import 'shared_pref_service.dart';
//
// abstract class WorkManagerService {
//   static Future<void> initWorkManager() async {
//     await workerManager.init();
//
//     await workerManager.execute(
//       _callbackDispatcher,
//
//
//     );
//
//     // await workerManager().registerPeriodicTask(
//     //   "Jumaa",
//     //   "Jumaa",
//     //   inputData: {"task": "Jumaa Notifications"},
//     //   frequency: const Duration(days: 1),
//     //   // existingWorkPolicy: ExistingWorkPolicy.replace,
//     //   constraints: Constraints(
//     //       networkType: NetworkType.not_required,
//     //       requiresBatteryNotLow: false,
//     //       requiresCharging: false,
//     //       requiresDeviceIdle: false,
//     //       requiresStorageNotLow: false),
//     // );
//     log("✅ WorkManager task registered successfully");
//   }
//
//   static Future<void> cancelWorkManager() async {
//     await workerManager.dispose();
//   }
// }
//
// @pragma('vm:entry-point')
// void _callbackDispatcher() async{
//     try {
//       log("Hello from WorkManager");
//       WidgetsFlutterBinding.ensureInitialized();
//
//       init();
//       await Future.wait([
//         SharedPrefService.init(),
//         initializeDateFormatting('ar_EG', null),
//       ]);
//       await NotificationRepoImpl().makeNotification();
//
//       log("Notification sent successfully!");
//       return Future.value(true);
//     } catch (e, stackTrace) {
//       log("❌ WorkManager Error: $e");
//       log("🔍 StackTrace: $stackTrace");
//       return Future.value(false);
//     }
//
// }
