import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

/// BLoC for managing app theme
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';
  
  ThemeBloc() : super(const ThemeInitial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeModeEvent>(_onSetThemeMode);
  }
  
  /// Handle loading the theme preference
  Future<void> _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePreferenceKey);
    
    if (themeIndex != null) {
      emit(ThemeLoaded(ThemeMode.values[themeIndex]));
    } else {
      emit(const ThemeLoaded(ThemeMode.system));
    }
  }
  
  /// Handle toggling between light and dark theme
  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final currentThemeMode = state.themeMode;
    final newThemeMode = currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    
    await _saveThemePreference(newThemeMode);
    emit(ThemeLoaded(newThemeMode));
  }
  
  /// Handle setting a specific theme mode
  Future<void> _onSetThemeMode(SetThemeModeEvent event, Emitter<ThemeState> emit) async {
    await _saveThemePreference(event.themeMode);
    emit(ThemeLoaded(event.themeMode));
  }
  
  /// Save theme preference to shared preferences
  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePreferenceKey, themeMode.index);
  }
}
