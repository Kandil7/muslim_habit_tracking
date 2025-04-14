import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setDouble({required String key, required double value}) async {
    await _prefs?.setDouble(key, value);
  }

  double? getDouble({required String key}) {
    return _prefs?.getDouble(key);
  }

  Future<void> setList(
      {required String key, required List<String> value}) async {
    await _prefs?.setStringList(key, value);
  }

  List<String>? getList({required String key}) {
    return _prefs?.getStringList(key);
  }

  Future<void> setInt({required String key, required int value}) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt({required String key}) {
    return _prefs?.getInt(key);
  }

  Future<void> setBoolList(
      {required String key, required List<bool> value}) async {
    List<String> stringList = value.map((e) => e.toString()).toList();
    await _prefs?.setStringList(key, stringList);
  }

  List<bool>? getBoolList({required String key}) {
    List<String>? stringList = _prefs?.getStringList(key);
    if (stringList == null) return null;

    return stringList.map((e) => e == 'true').toList();
  }

  Future<void> setString({required String key, required String value}) async {
    await _prefs?.setString(key, value);
  }

  String? getString({required String key}) {
    return _prefs?.getString(key);
  }
}
