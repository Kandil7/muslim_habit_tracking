import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';

/// A standardized list tile component
class AppListTile extends StatelessWidget {
  /// The list tile title
  final String title;

  /// The list tile subtitle
  final String? subtitle;

  /// The list tile leading widget
  final Widget? leading;

  /// The list tile trailing widget
  final Widget? trailing;

  /// The callback when the list tile is tapped
  final VoidCallback? onTap;

  /// The callback when the list tile is long pressed
  final VoidCallback? onLongPress;

  /// Whether the list tile is selected
  final bool isSelected;

  /// Whether the list tile is enabled
  final bool isEnabled;

  /// The list tile padding
  final EdgeInsetsGeometry? contentPadding;

  /// The list tile background color
  final Color? backgroundColor;

  /// The list tile selected color
  final Color? selectedColor;

  /// The list tile title style
  final TextStyle? titleStyle;

  /// The list tile subtitle style
  final TextStyle? subtitleStyle;

  /// The list tile border radius
  final double borderRadius;

  /// The list tile dense spacing
  final bool dense;

  /// The list tile three line
  final bool isThreeLine;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates an [AppListTile]
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isEnabled = true,
    this.contentPadding,
    this.backgroundColor,
    this.selectedColor,
    this.titleStyle,
    this.subtitleStyle,
    this.borderRadius = 8,
    this.dense = false,
    this.isThreeLine = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on selection and enabled state
    final bgColor = isSelected
        ? selectedColor ?? colorScheme.primaryContainer
        : backgroundColor ?? Colors.transparent;
    
    // Build the list tile

    // Build the list tile
    Widget listTile = ListTile(
      title: Text(
        title,
        style: titleStyle?.copyWith(color: colorScheme.onSurface) ??
            theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: subtitleStyle?.copyWith(color: colorScheme.onSurfaceVariant) ??
                  theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            )
          : null,
      leading: leading,
      trailing: trailing,
      onTap: isEnabled ? onTap : null,
      onLongPress: isEnabled ? onLongPress : null,
      selected: isSelected,
      enabled: isEnabled,
      contentPadding: contentPadding,
      tileColor: bgColor,
      dense: dense,
      isThreeLine: isThreeLine,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    // Add semantic label for accessibility
    if (semanticLabel != null) {
      listTile = AccessibilityUtils.addSemanticLabel(
        listTile,
        label: semanticLabel!,
        hint: subtitle,
        isButton: onTap != null,
        onTap: isEnabled ? onTap : null,
        onLongPress: isEnabled ? onLongPress : null,
      );
    }

    return listTile;
  }
}
