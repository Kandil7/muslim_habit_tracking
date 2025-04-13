import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_state.dart';

/// Cubit for managing language settings
class LanguageCubit extends Cubit<LanguageState> {
  final String _prefsKey = 'language_code';
  final SharedPreferences _preferences;

  LanguageCubit(this._preferences) : super(LanguageState.initial()) {
    _loadSavedLanguage();
  }

  /// Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final savedLanguage = _preferences.getString(_prefsKey);
    
    if (savedLanguage != null) {
      emit(state.copyWith(locale: Locale(savedLanguage)));
    }
  }

  /// Change the app language
  Future<void> changeLanguage(Locale newLocale) async {
    if (newLocale.languageCode != state.locale.languageCode) {
      // Save the selected language to SharedPreferences
      await _preferences.setString(_prefsKey, newLocale.languageCode);
      
      // Update the state
      emit(state.copyWith(locale: newLocale));
    }
  }
}
