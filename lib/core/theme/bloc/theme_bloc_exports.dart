export 'theme_bloc.dart';
export 'theme_event.dart';
export 'theme_state.dart';

import 'package:flutter/material.dart';
import 'theme_event.dart';

class ChangeThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeThemeEvent(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}
