import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/bloc/theme_bloc_exports.dart';
import '../../utils/accessibility_utils.dart';
import 'animated_widgets.dart';

/// A theme toggle widget
class ThemeToggle extends StatefulWidget {
  /// The size of the toggle
  final double size;

  /// The light theme color
  final Color? lightColor;

  /// The dark theme color
  final Color? darkColor;

  /// The duration of the animation
  final Duration duration;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates a [ThemeToggle]
  const ThemeToggle({
    super.key,
    this.size = 40,
    this.lightColor,
    this.darkColor,
    this.duration = const Duration(milliseconds: 300),
    this.semanticLabel,
  });

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Set initial animation state based on current theme
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    if (themeBloc.state.themeMode == ThemeMode.dark) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final lightColor = widget.lightColor ?? Colors.amber;
    final darkColor = widget.darkColor ?? Colors.indigo;

    return BlocListener<ThemeBloc, ThemeState>(
      listener: (context, state) {
        if (state.themeMode == ThemeMode.dark) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AccessibilityUtils.addSemanticLabel(
        GestureDetector(
          onTap: _toggleTheme,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(lightColor, darkColor, _controller.value),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.white,
                        size: widget.size * 0.6,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        label:
            widget.semanticLabel ??
            (isDark ? 'Switch to light theme' : 'Switch to dark theme'),
        isButton: true,
        onTap: _toggleTheme,
      ),
    );
  }

  void _toggleTheme() {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    if (themeBloc.state.themeMode == ThemeMode.dark) {
      themeBloc.add(const ChangeThemeEvent(ThemeMode.light));
    } else {
      themeBloc.add(const ChangeThemeEvent(ThemeMode.dark));
    }
  }
}

/// A theme toggle button
class ThemeToggleButton extends StatelessWidget {
  /// The size of the toggle
  final double size;

  /// The light theme color
  final Color? lightColor;

  /// The dark theme color
  final Color? darkColor;

  /// The duration of the animation
  final Duration duration;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates a [ThemeToggleButton]
  const ThemeToggleButton({
    super.key,
    this.size = 40,
    this.lightColor,
    this.darkColor,
    this.duration = const Duration(milliseconds: 300),
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return AnimatedAppContainer(
          duration: duration,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          width: size * 2.2,
          height: size,
          child: Stack(
            children: [
              AnimatedAppPositioned(
                duration: duration,
                left: isDark ? size * 1.2 : 0,
                top: 0,
                child: ThemeToggle(
                  size: size,
                  lightColor: lightColor,
                  darkColor: darkColor,
                  duration: duration,
                  semanticLabel: semanticLabel,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
