import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';

import '../../../features/notification/data/repo/notification_repo_impl.dart';
import 'setup_locator_service.dart';
import 'shared_pref_service.dart';

abstract class WorkManagerService {
  static Future<void> initWorkManager() async {
    await Workmanager().initialize(
      _callbackDispatcher,
      isInDebugMode: false,
    );

    await Workmanager().registerPeriodicTask(
      "Jumaa",
      "Jumaa",
      inputData: {"task": "Jumaa Notifications"},
      frequency: const Duration(days: 1),
      // existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false),
    );
    log("✅ WorkManager task registered successfully");
  }

  static Future<void> cancelWorkManager() async {
    await Workmanager().cancelAll();
  }
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      log("Hello from WorkManager");
      WidgetsFlutterBinding.ensureInitialized();

      setupLocatorService();
      await Future.wait([
        SharedPrefService.init(),
        initializeDateFormatting('ar_EG', null),
      ]);
      await NotificationRepoImpl().makeNotification();

      log("Notification sent successfully!");
      return Future.value(true);
    } catch (e, stackTrace) {
      log("❌ WorkManager Error: $e");
      log("🔍 StackTrace: $stackTrace");
      return Future.value(false);
    }
  });
}
