import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// A reusable section header widget used throughout the app
class SectionHeader extends StatelessWidget {
  /// The title of the section
  final String title;
  
  /// Optional padding for the header
  final EdgeInsetsGeometry padding;
  
  /// Optional text style for the title
  final TextStyle? textStyle;
  
  /// Optional color for the title
  final Color? color;

  /// Creates a section header widget
  const SectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.only(left: 16, bottom: 8, top: 16),
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: textStyle ?? 
          theme.textTheme.bodyMedium?.copyWith(
            color: color ?? (isDarkMode ? AppColors.darkPrimary : AppColors.primary),
            fontWeight: FontWeight.bold,
          ),
      ),
    );
  }
}
