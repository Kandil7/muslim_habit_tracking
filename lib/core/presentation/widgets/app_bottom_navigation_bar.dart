import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';

/// A bottom navigation item
class BottomNavItem {
  /// The item icon
  final IconData icon;

  /// The item active icon
  final IconData? activeIcon;

  /// The item label
  final String label;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates a [BottomNavItem]
  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.semanticLabel,
  });
}

/// A standardized bottom navigation bar component
class AppBottomNavigationBar extends StatelessWidget {
  /// The navigation items
  final List<BottomNavItem> items;

  /// The current index
  final int currentIndex;

  /// The callback when an item is tapped
  final ValueChanged<int> onTap;

  /// The background color
  final Color? backgroundColor;

  /// The selected item color
  final Color? selectedItemColor;

  /// The unselected item color
  final Color? unselectedItemColor;

  /// The selected item icon size
  final double selectedIconSize;

  /// The unselected item icon size
  final double unselectedIconSize;

  /// The item label style
  final TextStyle? labelStyle;

  /// The selected label style
  final TextStyle? selectedLabelStyle;

  /// The unselected label style
  final TextStyle? unselectedLabelStyle;

  /// The type of bottom navigation bar
  final BottomNavigationBarType type;

  /// The elevation
  final double elevation;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show unselected labels
  final bool showUnselectedLabels;

  /// Creates an [AppBottomNavigationBar]
  const AppBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconSize = 24,
    this.unselectedIconSize = 24,
    this.labelStyle,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.type = BottomNavigationBarType.fixed,
    this.elevation = 8,
    this.showLabels = true,
    this.showUnselectedLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Convert items to BottomNavigationBarItem
    final bottomNavItems = items.map((item) {
      final isSelected = items.indexOf(item) == currentIndex;
      
      // Create the icon with semantic label
      Widget icon = Icon(
        item.icon,
        size: isSelected ? selectedIconSize : unselectedIconSize,
      );
      
      if (item.semanticLabel != null) {
        icon = AccessibilityUtils.addSemanticLabel(
          icon,
          label: item.semanticLabel!,
          hint: isSelected ? 'Selected' : null,
          isButton: true,
          onTap: () => onTap(items.indexOf(item)),
        );
      }
      
      return BottomNavigationBarItem(
        icon: icon,
        activeIcon: item.activeIcon != null
            ? AccessibilityUtils.addSemanticLabel(
                Icon(
                  item.activeIcon,
                  size: selectedIconSize,
                ),
                label: item.semanticLabel ?? item.label,
                hint: 'Selected',
                isButton: true,
                onTap: () => onTap(items.indexOf(item)),
              )
            : null,
        label: item.label,
        tooltip: item.semanticLabel ?? item.label,
      );
    }).toList();

    return BottomNavigationBar(
      items: bottomNavItems,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      unselectedItemColor:
          unselectedItemColor ?? colorScheme.onSurface.withOpacity(0.6),
      selectedLabelStyle: selectedLabelStyle ??
          labelStyle ??
          theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      unselectedLabelStyle: unselectedLabelStyle ??
          labelStyle ??
          theme.textTheme.labelSmall,
      type: type,
      elevation: elevation,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showUnselectedLabels && showLabels,
    );
  }
}
