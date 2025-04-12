import 'package:flutter/material.dart';

/// A reusable expansion card widget used for Duas, Dhikrs, and other expandable content
class ExpansionCard extends StatelessWidget {
  /// The title of the expansion card
  final String title;
  
  /// The subtitle or description
  final String? subtitle;
  
  /// The content to display when expanded
  final Widget content;
  
  /// Optional trailing widget
  final Widget? trailing;
  
  /// Optional leading widget
  final Widget? leading;
  
  /// Optional initial expanded state
  final bool initiallyExpanded;
  
  /// Optional title style
  final TextStyle? titleStyle;
  
  /// Optional subtitle style
  final TextStyle? subtitleStyle;
  
  /// Optional margin for the card
  final EdgeInsetsGeometry margin;
  
  /// Optional callback when expansion state changes
  final Function(bool)? onExpansionChanged;

  /// Creates an expansion card widget
  const ExpansionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.trailing,
    this.leading,
    this.initiallyExpanded = false,
    this.titleStyle,
    this.subtitleStyle,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: ExpansionTile(
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: subtitleStyle ?? Theme.of(context).textTheme.bodySmall,
              )
            : null,
        leading: leading,
        trailing: trailing,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ],
      ),
    );
  }
}
