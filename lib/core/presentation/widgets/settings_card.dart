import 'package:flutter/material.dart';

/// A reusable settings card widget used throughout the app
class SettingsCard extends StatelessWidget {
  /// The title of the settings card
  final String title;
  
  /// The subtitle or description of the settings card
  final String subtitle;
  
  /// The leading icon to display
  final Widget? leading;
  
  /// The trailing widget, defaults to a chevron icon
  final Widget? trailing;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional padding for the card
  final EdgeInsetsGeometry? padding;
  
  /// Optional margin for the card
  final EdgeInsetsGeometry? margin;
  
  /// Optional title style
  final TextStyle? titleStyle;
  
  /// Optional subtitle style
  final TextStyle? subtitleStyle;

  /// Creates a settings card widget
  const SettingsCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing = const Icon(Icons.chevron_right),
    this.onTap,
    this.padding,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: ListTile(
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: leading,
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: subtitleStyle ?? Theme.of(context).textTheme.bodySmall,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
