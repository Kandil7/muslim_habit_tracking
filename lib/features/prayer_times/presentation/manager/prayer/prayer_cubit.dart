import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '/core/utils/helper.dart';
import '/core/utils/services/location_service.dart';
import '/core/utils/services/prayer_notification_service.dart';
import '/core/utils/services/setup_locator_service.dart';
import '/core/utils/services/shared_pref_service.dart';

import '../../../../../core/utils/services/shared_pref_service.dart';
import '../../../data/models/prayer_item_model.dart';
import '../../../data/repo/prayer_repo.dart';

part 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit(this._prayerRepo, this._locationService)
      : super(PrayerInitial()) {
    _startTimer();
    _initNotificationService();
  }
  final PrayerRepo _prayerRepo;
  final LocationService _locationService;
  final SharedPrefService _sharedPrefService = di.sl<SharedPrefService>();
  late final PrayerNotificationService _notificationService;
  List<PrayerItemModel> prayerList = [];
  String nextPrayer = '';
  bool _notificationsEnabled = false;
  int _notificationMinutesBefore = 15; // Default value

  Timer? _timer;
  void _startTimer() async {
    // _setTime();
    getPrayerTimes();
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   getPrayerTimes();
    // });
  }

  // void _setTime() {
  //   int lastMinute = DateTime.now().minute;
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     DateTime currentTime = DateTime.now();
  //     if (currentTime.minute != lastMinute) {
  //       lastMinute = currentTime.minute;
  //       now = DateTime.now();
  //       emit(ChangeTime());
  //     }
  //   });
  // }

  DateTime now = DateTime.now();

  String getPrayerTimes({bool forceRefresh = false}) {
    final prayerMap = _prayerRepo.getPrayerTimes(forceRefresh: forceRefresh);
    prayerList = prayerMap['prayerList'];
    nextPrayer = prayerMap['nextPrayer'];
    if (prayerList.isNotEmpty) {
      emit(GetPrayerSuccess());
      // Schedule notifications if enabled
      if (_notificationsEnabled) {
        _scheduleNotifications();
      }
    } else {
      emit(GetPrayerError('Failed to get prayer times'));
    }
    return prayerMap['nextPrayer'];
  }

  Future<void> setLocation() async {
    try {
      await _locationService.getLocation();
      getPrayerTimes();
      emit(SetLocationSuccess());
    } catch (e) {
      emit(SetLocationError('Error getting location: ${e.toString()}'));
    }
  }

  Future<void> firstSetLocation() async {
    try {
      double? latitude = Helper.getLatlng()['latitude'];
      double? longitude = Helper.getLatlng()['longitude'];

      if (latitude == null && longitude == null) {
        await setLocation();
      } else {
        // We already have location, just get prayer times
        getPrayerTimes();
      }
    } catch (e) {
      emit(SetLocationError('Error initializing location: ${e.toString()}'));
    }
  }

  List<String>? getAddress(key) {
    return _sharedPrefService.getList(key: key);
  }

  Future<void> _initNotificationService() async {
    _notificationService = PrayerNotificationService();
    // Load notification preferences from SharedPreferences
    _notificationsEnabled = _sharedPrefService.getBool(key: 'prayer_notifications_enabled') ?? false;
    _notificationMinutesBefore = _sharedPrefService.getInt(key: 'prayer_notifications_minutes_before') ?? 15;

    if (_notificationsEnabled) {
      await _notificationService.requestPermissions();
      _scheduleNotifications();
    }
  }

  Future<void> _scheduleNotifications() async {
    if (_notificationsEnabled && prayerList.isNotEmpty) {
      await _notificationService.scheduleAllPrayerNotifications(
          prayerList, _notificationMinutesBefore);
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _sharedPrefService.setBool(key: 'prayer_notifications_enabled', value: enabled);

    if (enabled) {
      await _notificationService.requestPermissions();
      _scheduleNotifications();
    } else {
      await _notificationService.cancelAllNotifications();
    }
    emit(NotificationSettingsChanged());
  }

  Future<void> setNotificationTime(int minutesBefore) async {
    _notificationMinutesBefore = minutesBefore;
    await _sharedPrefService.setInt(key: 'prayer_notifications_minutes_before', value: minutesBefore);

    if (_notificationsEnabled) {
      _scheduleNotifications();
    }
    emit(NotificationSettingsChanged());
  }

  bool get notificationsEnabled => _notificationsEnabled;
  int get notificationMinutesBefore => _notificationMinutesBefore;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
