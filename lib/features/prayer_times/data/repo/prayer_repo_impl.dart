import '/core/utils/assets.dart';
import '/core/utils/helper.dart';

import '../models/prayer_item_model.dart';
import 'prayer_repo.dart';

class PrayerRepoImpl extends PrayerRepo {
  @override
  Map getPrayerTimes() {
    DateTime now = DateTime.now();
    final todayPrayerTimes = Helper.getPrayersList();

    List<DateTime> prayerDateTimes = [];
    for (int i = 0; i < todayPrayerTimes.length; i++) {
      if (i == 5) continue;
      Helper.setDateTime(todayPrayerTimes[i], prayerDateTimes, now);
    }

    bool isAfterLastPrayer = now.isAfter(prayerDateTimes.last);
    List<String> effectivePrayerTimes;
    if (isAfterLastPrayer) {
      now = now.add(Duration(days: 1));
      effectivePrayerTimes = Helper.getPrayersList();

      prayerDateTimes = [];
      for (int i = 0; i < effectivePrayerTimes.length; i++) {
        if (i == 5) continue;
        Helper.setDateTime(effectivePrayerTimes[i], prayerDateTimes, now);
      }
    } else {
      effectivePrayerTimes = todayPrayerTimes;
    }

    String? nextPrayer;
    DateTime currentTime = DateTime.now();
    for (var element in prayerDateTimes) {
      if (element.isAfter(currentTime)) {
        nextPrayer =
            "${element.hour.toString().padLeft(2, '0')}:${element.minute.toString().padLeft(2, '0')}";
        break;
      }
    }

    List<PrayerItemModel> prayerList =
        _getPrayerTimesMethod(effectivePrayerTimes, prayerDateTimes);

    return {
      'nextPrayer': nextPrayer,
      'prayerList': prayerList,
    };
  }

  // List<String> getPrayersList() {
  //   DateTime now = DateTime.now();
  //   final timeZoneOffset = now.timeZoneOffset.inHours.toDouble();

  //   double? latitude = Helper.getLatlng()['latitude'];
  //   double? longitude = Helper.getLatlng()['longitude'];
  //   if (latitude == null && longitude == null) {
  //     latitude = 24.697079250797515;
  //     longitude = 46.67124576608985;
  //   }

  //   PrayerTimes prayers = PrayerTimes();
  //   prayers.tune(List.filled(7, 0));
  //   prayers.setCalcMethod(prayers.Makkah);
  //   return prayers.getPrayerTimes(now, latitude!, longitude!, timeZoneOffset);
  // }

  // void _setDateTime(
  //     String prayerTimes, List<DateTime> prayerDateTimes, DateTime now) {
  //   DateTime timeOnly = DateFormat("HH:mm", "en").parse(prayerTimes);
  //   prayerDateTimes.add(
  //       DateTime(now.year, now.month, now.day, timeOnly.hour, timeOnly.minute));
  // }

  List<PrayerItemModel> _getPrayerTimesMethod(
      List<String> prayerTimes, List<DateTime> prayerDateTimes) {
    Map<String, String> prayerTimesAsString = {
      "الفجر": prayerTimes[0],
      "الشروق": prayerTimes[1],
      "الظهر": prayerTimes[2],
      "العصر": prayerTimes[3],
      "المغرب": prayerTimes[5],
      "العشاء": prayerTimes[6],
    };
    List<String> enPrayerNames = [
      "Fajr",
      "Sunrise",
      "Zuhr",
      "Asr",
      "Maghreb",
      "Isha"
    ];
    List<String> prayerImages = [
      Assets.imagesMoon,
      Assets.imagesSunrise,
      Assets.imagesSun,
      Assets.imagesSun,
      Assets.imagesSunrise,
      Assets.imagesMoon
    ];
    List<PrayerItemModel> prayerList = [];
    int index = 0;
    DateTime currentTime = DateTime.now();

    for (var element in prayerTimesAsString.entries) {
      Duration remainingTime = prayerDateTimes[index].difference(currentTime);
      bool isPrayerPassed = remainingTime.isNegative;

      if (remainingTime.isNegative) {
        remainingTime = remainingTime.abs();
      }

      prayerList.add(
        PrayerItemModel(
            prayerImage: prayerImages[index],
            arName: element.key,
            enName: enPrayerNames[index],
            prayerTime: element.value,
            remainingTime: remainingTime,
            isPrayerPassed: isPrayerPassed),
      );
      index++;
    }

    return prayerList;
  }
}
