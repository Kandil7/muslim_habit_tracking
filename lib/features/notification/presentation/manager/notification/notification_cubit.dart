import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import '/core/utils/constants.dart';
import '/core/utils/helper.dart';
import '/core/utils/services/notification_service.dart';
import '/core/utils/services/shared_pref_service.dart';

import '../../../data/models/notification_item_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._sharedPrefService, this._notificationService)
    : super(NotificationInitial());
  final SharedPrefService _sharedPrefService;
  final NotificationService _notificationService;

  List<NotificationItemModel> notificationList(BuildContext context) {
    List<bool>? boolList = Helper.getBoolList();
    if (boolList == null) return [];
    return [
      NotificationItemModel(
        name: context.tr.translate('notification.readingSurahAlKahfOnFriday'),
        value: boolList[0],
      ),
      // NotificationItemModel(
      //     name: context.tr.translate('notification.earlyJumaa'), value: boolList[1]),
      // NotificationItemModel(
      //     name: context.tr.translate('notification.jumaSunnin'), value: boolList[2]),
      NotificationItemModel(
        name: context.tr.translate('notification.prayerOnProphetMuhammad'),
        value: boolList[3],
      ),
      NotificationItemModel(
        name: context.tr.translate('notification.reminderForDuhaPrayer'),
        value: boolList[4],
      ),
      NotificationItemModel(
        name: context.tr.translate(
          'notification.fastingOnMondaysaAndThursdays',
        ),
        value: boolList[5],
      ),
      // NotificationItemModel(
      //     name: context.tr.translate('notification.reminderToDoTheNightPrayers'), value: boolList[6]),
      NotificationItemModel(
        name: context.tr.translate(
          'notification.rememberingtopraybetweenthecalltoprayerandtheiqama',
        ),
        value: boolList[7],
      ),
      NotificationItemModel(
        name: context.tr.translate('notification.remindertoreadthedailyQuran'),
        value: boolList[8],
      ),
      NotificationItemModel(
        name: context.tr.translate(
          'notification.rememberingthemorningandeveningremembrances',
        ),
        value: boolList[9],
      ),
      NotificationItemModel(
        name: context.tr.translate(
          'notification.remindingtheentryofprayertimes',
        ),
        value: boolList[10],
      ),
    ];
  }

  void changeNotificationValue(int index, BuildContext context) async {
    List<bool>? boolList = Helper.getBoolList();
    if (boolList == null) return;

    boolList[index] = !boolList[index];
    _sharedPrefService.setBoolList(
      key: Constants.notification,
      value: boolList,
    );
    notificationList(context);
    await _cancleNotification(boolList);

    emit(ChangeNotificationSuccess());
  }

  Future<void> _cancleNotification(List<bool> boolList) async {
    if (!boolList[0]) {
      await _notificationService.cancleNotification(0);
    }
    if (!boolList[1]) {
      for (int i in Constants.earlyJumaaID) {
        await _notificationService.cancleNotification(i);
      }
    }
    if (!boolList[2]) {
      await _notificationService.cancleNotification(1);
    }
    if (!boolList[3]) {
      for (int i in Constants.prayerOnPromptMohamedID) {
        await _notificationService.cancleNotification(i);
      }
    }
    if (!boolList[4]) {
      await _notificationService.cancleNotification(5);
    }
    if (!boolList[5]) {
      await _notificationService.cancleNotification(12);
      await _notificationService.cancleNotification(13);
    }
    if (!boolList[6]) {
      for (int i in Constants.nightPrayersID) {
        await _notificationService.cancleNotification(i);
      }
    }
    if (!boolList[7]) {
      for (int i in Constants.doaaBeforIqmaaID) {
        await _notificationService.cancleNotification(i);
      }
    }
    if (!boolList[8]) {
      await _notificationService.cancleNotification(6);
    }
    if (!boolList[9]) {
      await _notificationService.cancleNotification(3);
      await _notificationService.cancleNotification(4);
    }
    if (!boolList[10]) {
      for (int i in Constants.prayerTimesID) {
        await _notificationService.cancleNotification(i);
      }
    }
  }

  Future<void> makeNotification() async {
    // await WorkManagerService.cancelWorkManager();
    // await WorkManagerService.initWorkManager();
  }
}
