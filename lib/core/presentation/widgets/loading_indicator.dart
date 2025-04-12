import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracking/core/theme/app_theme.dart';

/// A reusable loading indicator widget
class LoadingIndicator extends StatelessWidget {
  /// Optional size of the loading indicator
  final double size;
  
  /// Optional color of the loading indicator
  final Color? color;
  
  /// Optional text to display below the loading indicator
  final String? text;
  
  /// Optional text style
  final TextStyle? textStyle;

  /// Creates a loading indicator widget
  const LoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final indicatorColor = color ?? 
      (isDarkMode ? AppColors.darkPrimary : AppColors.primary);
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              strokeWidth: 3.0,
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text!,
              style: textStyle ?? theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
