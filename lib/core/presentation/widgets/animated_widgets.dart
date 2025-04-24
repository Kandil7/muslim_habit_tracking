import 'package:flutter/material.dart';

import '../../utils/animation_utils.dart';

/// An animated list item
class AnimatedListItem extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// The animation duration
  final Duration duration;

  /// The animation delay
  final Duration delay;

  /// The animation curve
  final Curve curve;

  /// The animation type
  final AnimatedListItemType type;

  /// Creates an [AnimatedListItem]
  const AnimatedListItem({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.type = AnimatedListItemType.fadeSlide,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return widget.child;
    }

    switch (widget.type) {
      case AnimatedListItemType.fade:
        return AnimationUtils.fadeTransition(
          animation: _animation,
          child: widget.child,
        );
      case AnimatedListItemType.slide:
        return AnimationUtils.slideTransition(
          animation: _animation,
          child: widget.child,
        );
      case AnimatedListItemType.scale:
        return AnimationUtils.scaleTransition(
          animation: _animation,
          child: widget.child,
        );
      case AnimatedListItemType.fadeSlide:
        return AnimationUtils.fadeSlideTransition(
          animation: _animation,
          child: widget.child,
        );
      case AnimatedListItemType.fadeScale:
        return AnimationUtils.fadeScaleTransition(
          animation: _animation,
          child: widget.child,
        );
    }
  }
}

/// Animated list item types
enum AnimatedListItemType {
  /// Fade animation
  fade,

  /// Slide animation
  slide,

  /// Scale animation
  scale,

  /// Fade and slide animation
  fadeSlide,

  /// Fade and scale animation
  fadeScale,
}

/// An animated list
class AnimatedList extends StatelessWidget {
  /// The list items
  final List<Widget> children;

  /// The animation duration
  final Duration duration;

  /// The stagger duration
  final Duration staggerDuration;

  /// The animation curve
  final Curve curve;

  /// The animation type
  final AnimatedListItemType type;

  /// The list padding
  final EdgeInsetsGeometry? padding;

  /// The list physics
  final ScrollPhysics? physics;

  /// The list controller
  final ScrollController? controller;

  /// The list shrink wrap
  final bool shrinkWrap;

  /// Creates an [AnimatedList]
  const AnimatedList({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.staggerDuration = const Duration(milliseconds: 50),
    this.curve = Curves.easeOut,
    this.type = AnimatedListItemType.fadeSlide,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return ListView(
        padding: padding,
        physics: physics,
        controller: controller,
        shrinkWrap: shrinkWrap,
        children: children,
      );
    }

    return ListView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          duration: duration,
          delay: staggerDuration * index,
          curve: curve,
          type: type,
          child: children[index],
        );
      },
    );
  }
}

/// An animated container
class AnimatedAppContainer extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// The animation duration
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// The container width
  final double? width;

  /// The container height
  final double? height;

  /// The container padding
  final EdgeInsetsGeometry? padding;

  /// The container margin
  final EdgeInsetsGeometry? margin;

  /// The container alignment
  final Alignment? alignment;

  /// The container decoration
  final BoxDecoration? decoration;

  /// The container foreground decoration
  final BoxDecoration? foregroundDecoration;

  /// The container transform
  final Matrix4? transform;

  /// The container transform alignment
  final AlignmentGeometry? transformAlignment;

  /// The container clip behavior
  final Clip clipBehavior;

  /// Creates an [AnimatedAppContainer]
  const AnimatedAppContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  @override
  State<AnimatedAppContainer> createState() => _AnimatedAppContainerState();
}

class _AnimatedAppContainerState extends State<AnimatedAppContainer> {
  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        alignment: widget.alignment,
        decoration: widget.decoration,
        foregroundDecoration: widget.foregroundDecoration,
        transform: widget.transform,
        transformAlignment: widget.transformAlignment,
        clipBehavior: widget.clipBehavior,
        child: widget.child,
      );
    }

    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      alignment: widget.alignment,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

/// An animated opacity
class AnimatedAppOpacity extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// The opacity value
  final double opacity;

  /// The animation duration
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// Creates an [AnimatedAppOpacity]
  const AnimatedAppOpacity({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedAppOpacity> createState() => _AnimatedAppOpacityState();
}

class _AnimatedAppOpacityState extends State<AnimatedAppOpacity> {
  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return Opacity(
        opacity: widget.opacity,
        child: widget.child,
      );
    }

    return AnimatedOpacity(
      opacity: widget.opacity,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}

/// An animated size
class AnimatedAppSize extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// The animation duration
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// The alignment
  final Alignment alignment;

  /// The clip behavior
  final Clip clipBehavior;

  /// Creates an [AnimatedAppSize]
  const AnimatedAppSize({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<AnimatedAppSize> createState() => _AnimatedAppSizeState();
}

class _AnimatedAppSizeState extends State<AnimatedAppSize> {
  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return widget.child;
    }

    return AnimatedSize(
      duration: widget.duration,
      curve: widget.curve,
      alignment: widget.alignment,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

/// An animated positioned
class AnimatedAppPositioned extends StatefulWidget {
  /// The child widget
  final Widget child;

  /// The left position
  final double? left;

  /// The top position
  final double? top;

  /// The right position
  final double? right;

  /// The bottom position
  final double? bottom;

  /// The width
  final double? width;

  /// The height
  final double? height;

  /// The animation duration
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// Creates an [AnimatedAppPositioned]
  const AnimatedAppPositioned({
    super.key,
    required this.child,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedAppPositioned> createState() => _AnimatedAppPositionedState();
}

class _AnimatedAppPositionedState extends State<AnimatedAppPositioned> {
  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return Positioned(
        left: widget.left,
        top: widget.top,
        right: widget.right,
        bottom: widget.bottom,
        width: widget.width,
        height: widget.height,
        child: widget.child,
      );
    }

    return AnimatedPositioned(
      left: widget.left,
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      width: widget.width,
      height: widget.height,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}

/// An animated switcher
class AnimatedAppSwitcher extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// The animation duration
  final Duration duration;

  /// The animation type
  final AnimatedSwitcherType type;

  /// The animation curve
  final Curve curve;

  /// Creates an [AnimatedAppSwitcher]
  const AnimatedAppSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.type = AnimatedSwitcherType.fade,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    if (!AnimationUtils.animationsEnabled) {
      return child;
    }

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        switch (type) {
          case AnimatedSwitcherType.fade:
            return AnimationUtils.fadeTransition(
              animation: animation,
              child: child,
            );
          case AnimatedSwitcherType.scale:
            return AnimationUtils.scaleTransition(
              animation: animation,
              child: child,
            );
          case AnimatedSwitcherType.fadeScale:
            return AnimationUtils.fadeScaleTransition(
              animation: animation,
              child: child,
            );
          case AnimatedSwitcherType.fadeSlide:
            return AnimationUtils.fadeSlideTransition(
              animation: animation,
              child: child,
            );
        }
      },
      child: child,
    );
  }
}

/// Animated switcher types
enum AnimatedSwitcherType {
  /// Fade animation
  fade,

  /// Scale animation
  scale,

  /// Fade and scale animation
  fadeScale,

  /// Fade and slide animation
  fadeSlide,
}
