import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/core/theme/bloc/theme_bloc_exports.dart';

void main() {
  group('ThemeState', () {
    test('ThemeInitial should have system theme mode', () {
      const state = ThemeInitial();
      expect(state.themeMode, equals(ThemeMode.system));
    });

    test('ThemeLoaded with light theme should have light theme mode', () {
      const state = ThemeLoaded(ThemeMode.light);
      expect(state.themeMode, equals(ThemeMode.light));
    });

    test('ThemeLoaded with dark theme should have dark theme mode', () {
      const state = ThemeLoaded(ThemeMode.dark);
      expect(state.themeMode, equals(ThemeMode.dark));
    });

    test('ThemeLoaded with system theme should have system theme mode', () {
      const state = ThemeLoaded(ThemeMode.system);
      expect(state.themeMode, equals(ThemeMode.system));
    });

    test('isDarkMode should return true for dark theme', () {
      const state = ThemeLoaded(ThemeMode.dark);
      expect(state.isDarkMode, isTrue);
    });

    test('isDarkMode should return false for light theme', () {
      const state = ThemeLoaded(ThemeMode.light);
      expect(state.isDarkMode, isFalse);
    });

    test('isDarkMode should return false for system theme', () {
      const state = ThemeLoaded(ThemeMode.system);
      expect(state.isDarkMode, isFalse);
    });

    test('states with same theme mode should be equal', () {
      const state1 = ThemeLoaded(ThemeMode.dark);
      const state2 = ThemeLoaded(ThemeMode.dark);
      expect(state1, equals(state2));
    });

    test('states with different theme modes should not be equal', () {
      const state1 = ThemeLoaded(ThemeMode.dark);
      const state2 = ThemeLoaded(ThemeMode.light);
      expect(state1, isNot(equals(state2)));
    });

    test('props should contain theme mode', () {
      const state = ThemeLoaded(ThemeMode.dark);
      expect(state.props, equals([ThemeMode.dark]));
    });
  });
}
