import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';

/// A standardized card component
class AppCard extends StatelessWidget {
  /// The card title
  final String? title;

  /// The card subtitle
  final String? subtitle;

  /// The card icon
  final IconData? icon;

  /// The card content
  final Widget? child;

  /// The callback when the card is tapped
  final VoidCallback? onTap;

  /// The callback when the card is long pressed
  final VoidCallback? onLongPress;

  /// The card elevation
  final double elevation;

  /// The card border radius
  final double borderRadius;

  /// The card padding
  final EdgeInsetsGeometry padding;

  /// The card margin
  final EdgeInsetsGeometry? margin;

  /// The card background color
  final Color? backgroundColor;

  /// The card border color
  final Color? borderColor;

  /// The card border width
  final double borderWidth;

  /// The card shadow color
  final Color? shadowColor;

  /// The card title style
  final TextStyle? titleStyle;

  /// The card subtitle style
  final TextStyle? subtitleStyle;

  /// The card icon color
  final Color? iconColor;

  /// The card icon size
  final double iconSize;

  /// Whether to show a divider between the header and content
  final bool showDivider;

  /// The divider color
  final Color? dividerColor;

  /// The divider thickness
  final double dividerThickness;

  /// The divider indent
  final double dividerIndent;

  /// The divider end indent
  final double dividerEndIndent;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates an [AppCard]
  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.child,
    this.onTap,
    this.onLongPress,
    this.elevation = 1,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.shadowColor,
    this.titleStyle,
    this.subtitleStyle,
    this.iconColor,
    this.iconSize = 24,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1,
    this.dividerIndent = 0,
    this.dividerEndIndent = 0,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build the card content
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || subtitle != null || icon != null) ...[
          _buildHeader(context),
          if (showDivider && child != null)
            Divider(
              color: dividerColor ?? colorScheme.outline.withValues(alpha: 0.5),
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent: dividerEndIndent,
              height: 16,
            ),
        ],
        if (child != null) child!,
      ],
    );

    // Build the card
    Widget card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderColor != null
            ? BorderSide(
                color: borderColor!,
                width: borderWidth,
              )
            : BorderSide.none,
      ),
      color: backgroundColor ?? colorScheme.surface,
      shadowColor: shadowColor,
      margin: margin ?? EdgeInsets.zero,
      child: Padding(
        padding: padding,
        child: cardContent,
      ),
    );

    // Make the card tappable if onTap is provided
    if (onTap != null || onLongPress != null) {
      card = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      card = AccessibilityUtils.addSemanticLabel(
        card,
        label: semanticLabel!,
        isButton: onTap != null,
        onTap: onTap,
        onLongPress: onLongPress,
      );
    }

    return card;
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? colorScheme.primary,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: titleStyle ?? theme.textTheme.titleMedium,
                ),
              if (subtitle != null) ...[
                if (title != null) const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: subtitleStyle ?? theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
