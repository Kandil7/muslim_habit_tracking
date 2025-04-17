import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// A reusable error message widget
class ErrorMessage extends StatelessWidget {
  /// The error message to display
  final String message;
  
  /// Optional callback when retry button is pressed
  final VoidCallback? onRetry;
  
  /// Optional icon to display
  final IconData icon;
  
  /// Optional title to display
  final String? title;
  
  /// Optional retry button text
  final String retryText;
  
  /// Optional icon color
  final Color? iconColor;
  
  /// Optional title style
  final TextStyle? titleStyle;
  
  /// Optional message style
  final TextStyle? messageStyle;

  /// Creates an error message widget
  const ErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.title,
    this.retryText = 'Retry',
    this.iconColor,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: iconColor ?? AppColors.error,
            ),
            const SizedBox(height: 16),
            if (title != null) ...[
              Text(
                title!,
                style: titleStyle ?? theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: messageStyle ?? theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
