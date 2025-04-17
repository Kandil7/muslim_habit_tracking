import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../di/injection_container.dart' as di;
import '/core/utils/constants.dart';
import 'package:pray_times/pray_times.dart';

import 'constants.dart';
import 'services/setup_locator_service.dart';
import 'services/shared_pref_service.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

abstract class Helper {
  static final SharedPrefService _sharedPrefService =
      di.sl<SharedPrefService>();

  static String convertToArabicNumbers(String input) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < englishNumbers.length; i++) {
      input = input.replaceAll(englishNumbers[i], arabicNumbers[i]);
    }

    return input;
  }

  static String formatRemaingTime(int time, {required bool local}) {
    if (local) {
      return convertToArabicNumbers((time % 60).toString().padLeft(2, '0'));
    }
    return (time % 60).toString().padLeft(2, '0');
  }

  static String _formatMiladDateTime(String lan) {
    DateTime date = DateTime.now();
    String day = DateFormat('d', lan).format(date);

    String month = DateFormat('MMMM', lan).format(date);
    String year = DateFormat('y', lan).format(date);

    return "$day $month $year";
  }

  static String _formatHijriDateTime(String lan) {
    HijriCalendar.setLocal(lan);
    final hijriDate = HijriCalendar.now();

    return hijriDate.toFormat("DDDD dd MMMM yyyy");
  }

  static String formatDateTime(String lan) {
    return '${_formatHijriDateTime(lan)} / ${_formatMiladDateTime(lan)}';
  }

  static String gethizbText(int page) {
    final currentPage = Constants.quranPages[page - 1];
    final hizb = currentPage.hizb;
    switch (currentPage.hizbQuarter % 4) {
      case 1:
        return '¼ الحزب $hizb';
      case 2:
        return '½ الحزب $hizb';
      case 3:
        return '¾ الحزب $hizb';
      default:
        return 'الحزب $hizb';
    }
  }

  static Future<List<dynamic>> loadJson(String json) async {
    String data = await rootBundle.loadString(json);

    List<dynamic> jsonResult = jsonDecode(data);
    return jsonResult;
  }

  static void setSystemSetting() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Map getLatlng() {
    double? latitude = _sharedPrefService.getDouble(key: Constants.latitude);
    double? longitude = _sharedPrefService.getDouble(key: Constants.longitude);
    return {"latitude": latitude, "longitude": longitude};
  }

  static Future<void> setLocationCountyAndCity() async {
    double? latitude = Helper.getLatlng()['latitude'];
    double? longitude = Helper.getLatlng()['longitude'];

    List<geocoding.Placemark> placemarksAr = await geocoding
        .placemarkFromCoordinates(
          latitude!,
          longitude!,
          localeIdentifier: 'ar',
        );

    List<geocoding.Placemark> placemarksEn = await geocoding
        .placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'en');

    final counryAr = placemarksAr.first.country ?? "";
    final cityAr = placemarksAr.first.subAdministrativeArea ?? "";

    final counryEn = placemarksEn.first.country ?? "";
    final cityEn = placemarksEn.first.subAdministrativeArea ?? "";

    await _sharedPrefService.setList(
      key: Constants.addressAr,
      value: [cityAr, counryAr],
    );
    await _sharedPrefService.setList(
      key: Constants.addressEn,
      value: [cityEn, counryEn],
    );
  }

  // static Future<Translation> _getPlaceName(
  //     {required String placeName, String? from, String? to}) async {
  //   return await GoogleTranslator()
  //       .translate(placeName, from: from ?? 'ar', to: to ?? 'en');
  // }

  static List<bool>? getBoolList() {
    final boolList = _sharedPrefService.getBoolList(
      key: Constants.notification,
    );
    return boolList;
  }

  static List<String> getPrayersList({DateTime? dateTime}) {
    DateTime now = dateTime ?? DateTime.now();
    final timeZoneOffset = now.timeZoneOffset.inHours.toDouble();

    double? latitude = Helper.getLatlng()['latitude'];
    double? longitude = Helper.getLatlng()['longitude'];

    PrayerTimes prayers = PrayerTimes();
    prayers.tune(List.filled(7, 0));

    final prefs = _sharedPrefService.getList(key: Constants.addressEn);

    String country = prefs?.last ?? "saudi arabia";

    if (country.toLowerCase() == "egypt") {
      prayers.setCalcMethod(prayers.Egypt);
    } else if (country.toLowerCase() == "saudi arabia") {
      prayers.setCalcMethod(prayers.Makkah);
    } else if (country.toLowerCase() == "pakistan") {
      prayers.setCalcMethod(prayers.Karachi);
    } else if (country.toLowerCase() == "iran") {
      prayers.setCalcMethod(prayers.Tehran);
    } else {
      prayers.setCalcMethod(prayers.MWL);
    }

    return prayers.getPrayerTimes(
      now,
      latitude ?? 24.697079250797515,
      longitude ?? 46.67124576608985,
      timeZoneOffset,
    );
  }

  static void setDateTime(
    String prayerTimes,
    List<DateTime> prayerDateTimes,
    DateTime now,
  ) {
    DateTime timeOnly = DateFormat("HH:mm", "en").parse(prayerTimes);
    prayerDateTimes.add(
      DateTime(now.year, now.month, now.day, timeOnly.hour, timeOnly.minute),
    );
  }

  static List<DateTime> getPrayerDateTimes({DateTime? dateTime}) {
    DateTime now = DateTime.now();
    final todayPrayerTimes = Helper.getPrayersList(dateTime: dateTime);

    List<DateTime> prayerDateTimes = [];
    for (int i = 0; i < todayPrayerTimes.length; i++) {
      if (i == 5) continue;
      Helper.setDateTime(todayPrayerTimes[i], prayerDateTimes, dateTime ?? now);
    }

    return prayerDateTimes;
  }

  // static Future<QuerySnapshot<Map<String, dynamic>>?> getSnapShot(
  //     String collection) async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection(collection).get();
  //
  //   return snapshot;
  // }
}
