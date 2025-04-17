import 'dart:convert';

import '/core/di/injection_container.dart' as di;
import '/core/utils/assets.dart';
import '/core/utils/helper.dart';
import '/core/utils/services/shared_pref_service.dart';

import '../models/prayer_item_model.dart';
import 'prayer_repo.dart';

class PrayerRepoImpl extends PrayerRepo {
  final SharedPrefService _sharedPrefService = di.sl<SharedPrefService>();
  static const String _cacheKey = 'prayer_times_cache';
  static const String _cacheDateKey = 'prayer_times_cache_date';

  @override
  Map getPrayerTimes({bool forceRefresh = false}) {
    // Check if we can use cached data
    if (!forceRefresh) {
      final cachedData = _getCachedPrayerTimes();
      if (cachedData != null) {
        return cachedData;
      }
    }

    // If no cache or force refresh, calculate new prayer times
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
        "${element.hour.toString().padLeft(2, '0')}:${element.minute
            .toString()
            .padLeft(2, '0')}";
        break;
      }
    }

    List<PrayerItemModel> prayerList =
    _getPrayerTimesMethod(effectivePrayerTimes, prayerDateTimes);

    final result = {
      'nextPrayer': nextPrayer,
      'prayerList': prayerList,
    };

    // Cache the result
    _cachePrayerTimes(result);

    return result;
  }

  /// Caches the prayer times data
  void _cachePrayerTimes(Map data) {
    try {
      // Convert PrayerItemModel list to a serializable format
      final List<Map<String, dynamic>> serializedList = [];
      for (final item in data['prayerList'] as List<PrayerItemModel>) {
        serializedList.add({
          'prayerImage': item.prayerImage,
          'arName': item.arName,
          'enName': item.enName,
          'prayerTime': item.prayerTime,
          'remainingTime': item.remainingTime.inSeconds,
          'isPrayerPassed': item.isPrayerPassed,
        });
      }

      final Map<String, dynamic> cacheData = {
        'nextPrayer': data['nextPrayer'],
        'prayerList': serializedList,
      };

      // Save to SharedPreferences
      _sharedPrefService.setString(
          key: _cacheKey, value: jsonEncode(cacheData));
      _sharedPrefService.setString(
          key: _cacheDateKey, value: DateTime.now().toIso8601String());
    } catch (e) {
      print('Error caching prayer times: $e');
    }
  }

  /// Retrieves cached prayer times if they're still valid
  Map? _getCachedPrayerTimes() {
    try {
      // Check if we have cached data
      final cachedString = _sharedPrefService.getString(key: _cacheKey);
      final cachedDateString = _sharedPrefService.getString(key: _cacheDateKey);

      if (cachedString == null || cachedDateString == null) {
        return null;
      }

      // Check if cache is from today
      final cachedDate = DateTime.parse(cachedDateString);
      final now = DateTime.now();
      if (cachedDate.year != now.year || cachedDate.month != now.month ||
          cachedDate.day != now.day) {
        return null; // Cache is from a different day
      }

      // Parse the cached data
      final Map<String, dynamic> cacheData = jsonDecode(cachedString);
      final List<dynamic> serializedList = cacheData['prayerList'];

      // Convert back to PrayerItemModel list
      final List<PrayerItemModel> prayerList = [];
      for (final item in serializedList) {
        prayerList.add(PrayerItemModel(
          prayerImage: item['prayerImage'],
          arName: item['arName'],
          enName: item['enName'],
          prayerTime: item['prayerTime'],
          remainingTime: Duration(seconds: item['remainingTime']),
          isPrayerPassed: item['isPrayerPassed'],
        ));
      }

      // Update remaining times based on current time
      _updateRemainingTimes(prayerList);

      return {
        'nextPrayer': cacheData['nextPrayer'],
        'prayerList': prayerList,
      };
    } catch (e) {
      print('Error retrieving cached prayer times: $e');
      return null;
    }
  }

  /// Updates the remaining times for cached prayer items
  void _updateRemainingTimes(List<PrayerItemModel> prayerList) {
    final now = DateTime.now();
    for (final item in prayerList) {
      // Parse prayer time
      final List<String> timeParts = item.prayerTime.split(':');
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);

      // Create prayer time DateTime
      final prayerDateTime = DateTime(
          now.year, now.month, now.day, hour, minute);

      // Calculate new remaining time
      final Duration remainingTime = prayerDateTime.difference(now);

      // Update the item (this is a hack since PrayerItemModel is immutable)
      // In a real app, you'd create a new instance or make the model mutable
      (item as dynamic).remainingTime =
      remainingTime.isNegative ? remainingTime.abs() : remainingTime;
      (item as dynamic).isPrayerPassed = remainingTime.isNegative;
    }
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

  List<PrayerItemModel> _getPrayerTimesMethod(List<String> prayerTimes,
      List<DateTime> prayerDateTimes) {
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
