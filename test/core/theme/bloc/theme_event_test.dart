import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/core/theme/bloc/theme_bloc_exports.dart';

void main() {
  group('ThemeEvent', () {
    test('ToggleThemeEvent props should be empty', () {
      const event = ToggleThemeEvent();
      expect(event.props, isEmpty);
    });

    test('SetThemeModeEvent props should contain theme mode', () {
      const event = SetThemeModeEvent(ThemeMode.dark);
      expect(event.props, equals([ThemeMode.dark]));
    });

    test('LoadThemeEvent props should be empty', () {
      const event = LoadThemeEvent();
      expect(event.props, isEmpty);
    });

    test('events of same type should be equal', () {
      const event1 = ToggleThemeEvent();
      const event2 = ToggleThemeEvent();
      expect(event1, equals(event2));
    });

    test('SetThemeModeEvent with same theme mode should be equal', () {
      const event1 = SetThemeModeEvent(ThemeMode.dark);
      const event2 = SetThemeModeEvent(ThemeMode.dark);
      expect(event1, equals(event2));
    });

    test('SetThemeModeEvent with different theme modes should not be equal', () {
      const event1 = SetThemeModeEvent(ThemeMode.dark);
      const event2 = SetThemeModeEvent(ThemeMode.light);
      expect(event1, isNot(equals(event2)));
    });

    test('different event types should not be equal', () {
      const event1 = ToggleThemeEvent();
      const event2 = LoadThemeEvent();
      expect(event1, isNot(equals(event2)));
    });
  });
}
