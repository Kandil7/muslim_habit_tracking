import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';

/// Button types
enum AppButtonType {
  /// Primary button
  primary,

  /// Secondary button
  secondary,

  /// Outline button
  outline,

  /// Text button
  text,

  /// Icon button
  icon,
}

/// Button sizes
enum AppButtonSize {
  /// Small button
  small,

  /// Medium button
  medium,

  /// Large button
  large,
}

/// A standardized button component
class AppButton extends StatelessWidget {
  /// The button text
  final String? text;

  /// The button icon
  final IconData? icon;

  /// The callback when the button is pressed
  final VoidCallback? onPressed;

  /// The button type
  final AppButtonType type;

  /// The button size
  final AppButtonSize size;

  /// Whether the button is loading
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// The button width
  final double? width;

  /// The button height
  final double? height;

  /// The button border radius
  final double? borderRadius;

  /// The button text style
  final TextStyle? textStyle;

  /// The button icon size
  final double? iconSize;

  /// The button icon color
  final Color? iconColor;

  /// The button background color
  final Color? backgroundColor;

  /// The button foreground color
  final Color? foregroundColor;

  /// The button border color
  final Color? borderColor;

  /// The button elevation
  final double? elevation;

  /// The button padding
  final EdgeInsetsGeometry? padding;

  /// The button margin
  final EdgeInsetsGeometry? margin;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates an [AppButton]
  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.padding,
    this.margin,
    this.semanticLabel,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided');

  @override
  Widget build(BuildContext context) {
    // Determine if the button is enabled
    final isEnabled = onPressed != null && !isDisabled && !isLoading;

    // Get the theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine button style based on type
    ButtonStyle buttonStyle;
    switch (type) {
      case AppButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          elevation: elevation ?? 2,
          padding: padding ?? _getPaddingForSize(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: _getSizeForButton(size),
        );
        break;
      case AppButtonType.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          foregroundColor: foregroundColor ?? colorScheme.onSecondary,
          elevation: elevation ?? 1,
          padding: padding ?? _getPaddingForSize(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: _getSizeForButton(size),
        );
        break;
      case AppButtonType.outline:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? colorScheme.primary,
          side: BorderSide(
            color: borderColor ?? colorScheme.primary,
            width: 1.5,
          ),
          padding: padding ?? _getPaddingForSize(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: _getSizeForButton(size),
        );
        break;
      case AppButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: foregroundColor ?? colorScheme.primary,
          padding: padding ?? _getPaddingForSize(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: _getSizeForButton(size),
        );
        break;
      case AppButtonType.icon:
        buttonStyle = IconButton.styleFrom(
          foregroundColor: foregroundColor ?? colorScheme.primary,
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          minimumSize: _getSizeForIconButton(size),
        );
        break;
    }

    // Build the button content
    Widget buttonContent;
    if (isLoading) {
      buttonContent = SizedBox(
        width: _getLoadingSize(size),
        height: _getLoadingSize(size),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.outline || type == AppButtonType.text
                ? colorScheme.primary
                : colorScheme.onPrimary,
          ),
        ),
      );
    } else if (text != null && icon != null) {
      // Button with both text and icon
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize ?? _getIconSizeForButton(size),
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            text!,
            style: textStyle,
          ),
        ],
      );
    } else if (icon != null) {
      // Icon-only button
      buttonContent = Icon(
        icon,
        size: iconSize ?? _getIconSizeForButton(size),
        color: iconColor,
      );
    } else {
      // Text-only button
      buttonContent = Text(
        text!,
        style: textStyle,
      );
    }

    // Apply margin if provided
    Widget button;
    if (type == AppButtonType.icon) {
      button = IconButton(
        onPressed: isEnabled ? onPressed : null,
        icon: buttonContent,
        style: buttonStyle,
      );
    } else if (type == AppButtonType.outline) {
      button = OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    } else if (type == AppButtonType.text) {
      button = TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    } else {
      button = ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    }

    // Apply fixed width and height if provided
    if (width != null || height != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    // Apply margin if provided
    if (margin != null) {
      button = Padding(
        padding: margin!,
        child: button,
      );
    }

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      button = AccessibilityUtils.addSemanticLabel(
        button,
        label: semanticLabel!,
        isButton: true,
        onTap: isEnabled ? onPressed : null,
      );
    }

    return button;
  }

  /// Gets the padding for the button based on size
  EdgeInsetsGeometry _getPaddingForSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  /// Gets the size for the button based on size
  Size _getSizeForButton(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const Size(80, 32);
      case AppButtonSize.medium:
        return const Size(120, 40);
      case AppButtonSize.large:
        return const Size(160, 48);
    }
  }

  /// Gets the size for the icon button based on size
  Size _getSizeForIconButton(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const Size(32, 32);
      case AppButtonSize.medium:
        return const Size(40, 40);
      case AppButtonSize.large:
        return const Size(48, 48);
    }
  }

  /// Gets the icon size for the button based on size
  double _getIconSizeForButton(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  /// Gets the loading size for the button based on size
  double _getLoadingSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}
