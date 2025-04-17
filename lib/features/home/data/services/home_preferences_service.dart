import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing home dashboard preferences
class HomePreferencesService {
  final SharedPreferences _sharedPreferences;
  
  // Keys for SharedPreferences
  static const String _userNameKey = 'home_user_name';
  static const String _cardOrderKey = 'home_card_order';
  static const String _cardVisibilityKey = 'home_card_visibility';
  static const String _quickActionsKey = 'home_quick_actions';
  
  HomePreferencesService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;
  
  /// Get the user's name
  String getUserName() {
    return _sharedPreferences.getString(_userNameKey) ?? '';
  }
  
  /// Set the user's name
  Future<bool> setUserName(String name) {
    return _sharedPreferences.setString(_userNameKey, name);
  }
  
  /// Get the card order
  List<String> getCardOrder() {
    final String? orderJson = _sharedPreferences.getString(_cardOrderKey);
    if (orderJson == null) {
      // Default order
      return [
        'prayer',
        'habits',
        'quran',
        'dhikr',
        'calendar',
        'qibla',
        'hadith',
      ];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(orderJson);
      return decoded.cast<String>();
    } catch (e) {
      // Return default order on error
      return [
        'prayer',
        'habits',
        'quran',
        'dhikr',
        'calendar',
        'qibla',
        'hadith',
      ];
    }
  }
  
  /// Set the card order
  Future<bool> setCardOrder(List<String> order) {
    final String orderJson = jsonEncode(order);
    return _sharedPreferences.setString(_cardOrderKey, orderJson);
  }
  
  /// Get card visibility settings
  Map<String, bool> getCardVisibility() {
    final String? visibilityJson = _sharedPreferences.getString(_cardVisibilityKey);
    if (visibilityJson == null) {
      // Default visibility (all visible)
      return {
        'prayer': true,
        'habits': true,
        'quran': true,
        'dhikr': true,
        'calendar': true,
        'qibla': true,
        'hadith': true,
      };
    }
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(visibilityJson);
      return decoded.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      // Return default visibility on error
      return {
        'prayer': true,
        'habits': true,
        'quran': true,
        'dhikr': true,
        'calendar': true,
        'qibla': true,
        'hadith': true,
      };
    }
  }
  
  /// Set card visibility settings
  Future<bool> setCardVisibility(Map<String, bool> visibility) {
    final String visibilityJson = jsonEncode(visibility);
    return _sharedPreferences.setString(_cardVisibilityKey, visibilityJson);
  }
  
  /// Get quick actions
  List<Map<String, dynamic>> getQuickActions() {
    final String? actionsJson = _sharedPreferences.getString(_quickActionsKey);
    if (actionsJson == null) {
      // Default quick actions
      return [
        {'id': 'add_habit', 'label': 'Add Habit', 'icon': 'habit', 'enabled': true},
        {'id': 'prayer_times', 'label': 'Prayer Times', 'icon': 'prayer', 'enabled': true},
        {'id': 'read_quran', 'label': 'Read Quran', 'icon': 'quran', 'enabled': true},
        {'id': 'dhikr_counter', 'label': 'Dhikr', 'icon': 'dua', 'enabled': true},
      ];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(actionsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      // Return default quick actions on error
      return [
        {'id': 'add_habit', 'label': 'Add Habit', 'icon': 'habit', 'enabled': true},
        {'id': 'prayer_times', 'label': 'Prayer Times', 'icon': 'prayer', 'enabled': true},
        {'id': 'read_quran', 'label': 'Read Quran', 'icon': 'quran', 'enabled': true},
        {'id': 'dhikr_counter', 'label': 'Dhikr', 'icon': 'dua', 'enabled': true},
      ];
    }
  }
  
  /// Set quick actions
  Future<bool> setQuickActions(List<Map<String, dynamic>> actions) {
    final String actionsJson = jsonEncode(actions);
    return _sharedPreferences.setString(_quickActionsKey, actionsJson);
  }
}
