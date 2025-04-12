import 'package:flutter/material.dart';

/// A reusable stat item widget used for displaying statistics
class StatItem extends StatelessWidget {
  /// The label for the stat
  final String label;
  
  /// The value of the stat
  final String value;
  
  /// Optional icon to display
  final IconData? icon;
  
  /// Optional color for the icon and value
  final Color? color;
  
  /// Optional value text style
  final TextStyle? valueStyle;
  
  /// Optional label text style
  final TextStyle? labelStyle;

  /// Creates a stat item widget
  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.valueStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
        ],
        Text(
          value,
          style: valueStyle ?? 
            theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: labelStyle ?? theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
