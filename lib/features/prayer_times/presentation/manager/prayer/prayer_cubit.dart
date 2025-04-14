import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '/core/utils/helper.dart';
import '/core/utils/services/location_service.dart';
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
  }
  final PrayerRepo _prayerRepo;
  final LocationService _locationService;
  final SharedPrefService _sharedPrefService = di.sl<SharedPrefService>();
  List<PrayerItemModel> prayerList = [];
  String nextPrayer = '';

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

  String getPrayerTimes() {
    final prayerMap = _prayerRepo.getPrayerTimes();
    prayerList = prayerMap['prayerList'];
    nextPrayer = prayerMap['nextPrayer'];
    if (prayerList.isNotEmpty) {
      emit(GetPrayerSuccess());
    }
    return prayerMap['nextPrayer'];
  }

  Future<void> setLocation() async {
    await _locationService.getLocation();

    getPrayerTimes();
    emit(SetLocationSuccess());
  }

  Future<void> firstSetLocation() async {
    double? latitude = Helper.getLatlng()['latitude'];
    double? longitude = Helper.getLatlng()['longitude'];

    if (latitude == null && longitude == null) {
      await setLocation();
    }
  }

  List<String>? getAddress(key) {
    return _sharedPrefService.getList(key: key);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
