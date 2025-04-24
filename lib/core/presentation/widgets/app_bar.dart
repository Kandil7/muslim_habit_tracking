import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';

/// A standardized app bar component
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The app bar title
  final String title;

  /// The app bar leading widget
  final Widget? leading;

  /// The app bar actions
  final List<Widget>? actions;

  /// The app bar bottom widget
  final PreferredSizeWidget? bottom;

  /// Whether to center the title
  final bool centerTitle;

  /// Whether to show a back button
  final bool showBackButton;

  /// The callback when the back button is pressed
  final VoidCallback? onBackPressed;

  /// The app bar elevation
  final double elevation;

  /// The app bar background color
  final Color? backgroundColor;

  /// The app bar foreground color
  final Color? foregroundColor;

  /// The app bar title style
  final TextStyle? titleStyle;

  /// The app bar icon theme
  final IconThemeData? iconTheme;

  /// The app bar action icon theme
  final IconThemeData? actionsIconTheme;

  /// The app bar shadow color
  final Color? shadowColor;

  /// The app bar shape
  final ShapeBorder? shape;

  /// The app bar title spacing
  final double? titleSpacing;

  /// The app bar toolbar height
  final double? toolbarHeight;

  /// The app bar title widget
  final Widget? titleWidget;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates an [AppAppBar]
  const AppAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.titleStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.shadowColor,
    this.shape,
    this.titleSpacing,
    this.toolbarHeight,
    this.titleWidget,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build the app bar
    Widget appBar = AppBar(
      title: titleWidget ??
          Text(
            title,
            style: titleStyle,
          ),
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      shadowColor: shadowColor,
      shape: shape,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
    );

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      appBar = AccessibilityUtils.addSemanticLabelToHeader(
        appBar,
        label: semanticLabel!,
        hint: title,
      );
    }

    return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
