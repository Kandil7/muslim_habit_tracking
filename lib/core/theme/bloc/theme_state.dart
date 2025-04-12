import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme states
abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  
  const ThemeState(this.themeMode);
  
  @override
  List<Object> get props => [themeMode];
}

/// Initial state when the app starts
class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeMode.system);
}

/// State when the theme is loaded
class ThemeLoaded extends ThemeState {
  const ThemeLoaded(ThemeMode themeMode) : super(themeMode);
  
  /// Check if dark mode is enabled
  bool get isDarkMode => themeMode == ThemeMode.dark;
}
