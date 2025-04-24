import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for animations
class AnimationUtils {
  /// Whether animations are enabled
  static bool _animationsEnabled = true;

  /// Initializes the animation utils
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _animationsEnabled = prefs.getBool('animations_enabled') ?? true;
  }

  /// Sets whether animations are enabled
  static Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animations_enabled', enabled);
  }

  /// Gets whether animations are enabled
  static bool get animationsEnabled => _animationsEnabled;

  /// Creates a fade transition
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Creates a slide transition
  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0.0, 0.1),
    Offset endOffset = Offset.zero,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }

  /// Creates a scale transition
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
    double beginScale = 0.9,
    double endScale = 1.0,
    Alignment alignment = Alignment.center,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return ScaleTransition(
      scale: Tween<double>(
        begin: beginScale,
        end: endScale,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      alignment: alignment,
      child: child,
    );
  }

  /// Creates a fade and slide transition
  static Widget fadeSlideTransition({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0.0, 0.1),
    Offset endOffset = Offset.zero,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: endOffset,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      ),
    );
  }

  /// Creates a fade and scale transition
  static Widget fadeScaleTransition({
    required Widget child,
    required Animation<double> animation,
    double beginScale = 0.9,
    double endScale = 1.0,
    Alignment alignment = Alignment.center,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: beginScale,
          end: endScale,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        alignment: alignment,
        child: child,
      ),
    );
  }

  /// Creates a staggered animation for a list of widgets
  static List<Widget> staggeredList({
    required List<Widget> children,
    required Animation<double> animation,
    Duration staggerDuration = const Duration(milliseconds: 50),
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return children;
    }
    return List.generate(children.length, (index) {
      final delay = staggerDuration * index;
      final staggeredAnimation = CurvedAnimation(
        parent: animation,
        curve: Interval(
          delay.inMilliseconds / (staggerDuration.inMilliseconds * children.length),
          1.0,
          curve: Curves.easeOut,
        ),
      );
      return fadeSlideTransition(
        animation: staggeredAnimation,
        child: children[index],
      );
    });
  }

  /// Creates a hero transition
  static Widget heroTransition({
    required Widget child,
    required String tag,
    bool enabled = true,
  }) {
    if (!_animationsEnabled || !enabled) {
      return child;
    }
    return Hero(
      tag: tag,
      child: child,
    );
  }

  /// Creates a page route transition
  static PageRouteBuilder<T> pageRouteTransition<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    bool enabled = true,
    PageTransitionType transitionType = PageTransitionType.fade,
  }) {
    if (!_animationsEnabled || !enabled) {
      return PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
      );
    }

    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return fadeTransition(
              animation: animation,
              child: child,
            );
          case PageTransitionType.rightToLeft:
            return slideTransition(
              animation: animation,
              beginOffset: const Offset(1.0, 0.0),
              child: child,
            );
          case PageTransitionType.leftToRight:
            return slideTransition(
              animation: animation,
              beginOffset: const Offset(-1.0, 0.0),
              child: child,
            );
          case PageTransitionType.topToBottom:
            return slideTransition(
              animation: animation,
              beginOffset: const Offset(0.0, -1.0),
              child: child,
            );
          case PageTransitionType.bottomToTop:
            return slideTransition(
              animation: animation,
              beginOffset: const Offset(0.0, 1.0),
              child: child,
            );
          case PageTransitionType.scale:
            return scaleTransition(
              animation: animation,
              child: child,
            );
          case PageTransitionType.fadeAndScale:
            return fadeScaleTransition(
              animation: animation,
              child: child,
            );
          case PageTransitionType.fadeAndSlide:
            return fadeSlideTransition(
              animation: animation,
              child: child,
            );
        }
      },
    );
  }
}

/// Page transition types
enum PageTransitionType {
  /// Fade transition
  fade,

  /// Right to left transition
  rightToLeft,

  /// Left to right transition
  leftToRight,

  /// Top to bottom transition
  topToBottom,

  /// Bottom to top transition
  bottomToTop,

  /// Scale transition
  scale,

  /// Fade and scale transition
  fadeAndScale,

  /// Fade and slide transition
  fadeAndSlide,
}
