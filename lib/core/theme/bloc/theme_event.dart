import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// Event to toggle between light and dark theme
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

/// Event to set a specific theme mode
class SetThemeModeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const SetThemeModeEvent(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

/// Event to load the saved theme preference
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}
