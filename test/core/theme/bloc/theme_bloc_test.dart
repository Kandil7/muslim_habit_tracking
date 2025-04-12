import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_habit_tracking/core/theme/bloc/theme_bloc_exports.dart';

void main() {
  late ThemeBloc themeBloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    themeBloc = ThemeBloc();
  });

  tearDown(() {
    themeBloc.close();
  });

  group('ThemeBloc', () {
    test('initial state should be ThemeInitial with system theme', () {
      expect(themeBloc.state, isA<ThemeInitial>());
      expect(themeBloc.state.themeMode, equals(ThemeMode.system));
    });

    test('should emit ThemeLoaded with light theme when SetThemeModeEvent is added with light theme', () async {
      // Act
      themeBloc.add(const SetThemeModeEvent(ThemeMode.light));

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.light)),
      );
    });

    test('should emit ThemeLoaded with dark theme when SetThemeModeEvent is added with dark theme', () async {
      // Act
      themeBloc.add(const SetThemeModeEvent(ThemeMode.dark));

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.dark)),
      );
    });

    test('should emit ThemeLoaded with system theme when SetThemeModeEvent is added with system theme', () async {
      // Act
      themeBloc.add(const SetThemeModeEvent(ThemeMode.system));

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.system)),
      );
    });

    test('should toggle theme from light to dark when ToggleThemeEvent is added', () async {
      // Set initial theme to light
      themeBloc.add(const SetThemeModeEvent(ThemeMode.light));
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      themeBloc.add(const ToggleThemeEvent());

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.dark)),
      );
    });

    test('should toggle theme from dark to light when ToggleThemeEvent is added', () async {
      // Set initial theme to dark
      themeBloc.add(const SetThemeModeEvent(ThemeMode.dark));
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      themeBloc.add(const ToggleThemeEvent());

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.light)),
      );
    });

    test('should load system theme when LoadThemeEvent is added with no saved preferences', () async {
      // Act
      themeBloc.add(const LoadThemeEvent());

      // Assert
      await expectLater(
        themeBloc.stream,
        emits(isA<ThemeLoaded>().having((state) => state.themeMode, 'themeMode', ThemeMode.system)),
      );
    });
  });
}
