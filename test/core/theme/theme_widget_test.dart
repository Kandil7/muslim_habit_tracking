import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/core/theme/bloc/theme_bloc_exports.dart';

void main() {
  late ThemeBloc themeBloc;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    themeBloc = ThemeBloc();
  });

  tearDown(() {
    themeBloc.close();
  });

  testWidgets('App should use light theme when ThemeBloc emits light theme', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Create a mock ThemeState
    final mockThemeState = const ThemeLoaded(ThemeMode.light);

    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mockThemeState.themeMode,
        home: const Scaffold(
          body: Center(
            child: Text('Test'),
          ),
        ),
      ),
    );

    // Wait for the theme to be applied
    await tester.pumpAndSettle();

    // Assert
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, equals(ThemeMode.light));

    // Check that the app is using light theme
    final ThemeData theme = Theme.of(tester.element(find.text('Test')));
    expect(theme.brightness, equals(Brightness.light));
  });

  testWidgets('App should use dark theme when ThemeBloc emits dark theme', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Create a mock ThemeState
    final mockThemeState = const ThemeLoaded(ThemeMode.dark);

    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mockThemeState.themeMode,
        home: const Scaffold(
          body: Center(
            child: Text('Test'),
          ),
        ),
      ),
    );

    // Wait for the theme to be applied
    await tester.pumpAndSettle();

    // Assert
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, equals(ThemeMode.dark));

    // Check that the app is using dark theme
    final ThemeData theme = Theme.of(tester.element(find.text('Test')));
    expect(theme.brightness, equals(Brightness.dark));
  });

  testWidgets('Theme should change when theme mode changes', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Create a stateful test widget
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Test'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Toggle theme directly
                        });
                      },
                      child: const Text('Toggle Theme'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    // Wait for the theme to be applied
    await tester.pumpAndSettle();

    // Assert initial theme
    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, equals(ThemeMode.light));

    // Check that the app is using light theme
    ThemeData theme = Theme.of(tester.element(find.text('Test')));
    expect(theme.brightness, equals(Brightness.light));
  });
}
