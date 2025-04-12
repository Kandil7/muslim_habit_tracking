import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracking/core/presentation/widgets/custom_button.dart';

/// A reusable empty state widget
class EmptyState extends StatelessWidget {
  /// The title to display
  final String title;
  
  /// Optional message to display
  final String? message;
  
  /// Optional icon to display
  final IconData icon;
  
  /// Optional action button text
  final String? actionText;
  
  /// Optional callback when action button is pressed
  final VoidCallback? onAction;
  
  /// Optional title style
  final TextStyle? titleStyle;
  
  /// Optional message style
  final TextStyle? messageStyle;
  
  /// Optional icon size
  final double iconSize;
  
  /// Optional icon color
  final Color? iconColor;
  
  /// Optional spacing between elements
  final double spacing;

  /// Creates an empty state widget
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
    this.titleStyle,
    this.messageStyle,
    this.iconSize = 80.0,
    this.iconColor,
    this.spacing = 16.0,
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
              size: iconSize,
              color: iconColor ?? theme.colorScheme.primary.withOpacity(0.7),
            ),
            SizedBox(height: spacing),
            Text(
              title,
              style: titleStyle ?? theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: spacing / 2),
              Text(
                message!,
                style: messageStyle ?? theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: spacing),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                buttonType: ButtonType.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
