import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final String _prefsKey = 'language_code';

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Locale get locale => _locale;

  // Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_prefsKey);
    
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  // Change the app language
  Future<void> changeLanguage(Locale newLocale) async {
    if (newLocale.languageCode != _locale.languageCode) {
      _locale = newLocale;
      
      // Save the selected language to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, newLocale.languageCode);
      
      notifyListeners();
    }
  }

  // Check if the current locale is RTL
  bool get isRtl => _locale.languageCode == 'ar';
}
