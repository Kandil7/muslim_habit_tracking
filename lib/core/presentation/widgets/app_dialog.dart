import 'package:flutter/material.dart';

import '../../utils/accessibility_utils.dart';
import 'app_button.dart';

/// A standardized dialog component
class AppDialog extends StatelessWidget {
  /// The dialog title
  final String title;

  /// The dialog content
  final String? content;

  /// The dialog content widget
  final Widget? contentWidget;

  /// The primary button text
  final String? primaryButtonText;

  /// The secondary button text
  final String? secondaryButtonText;

  /// The callback when the primary button is pressed
  final VoidCallback? onPrimaryButtonPressed;

  /// The callback when the secondary button is pressed
  final VoidCallback? onSecondaryButtonPressed;

  /// The dialog icon
  final IconData? icon;

  /// The dialog icon color
  final Color? iconColor;

  /// The dialog title style
  final TextStyle? titleStyle;

  /// The dialog content style
  final TextStyle? contentStyle;

  /// The dialog border radius
  final double borderRadius;

  /// The dialog elevation
  final double elevation;

  /// The dialog background color
  final Color? backgroundColor;

  /// The dialog padding
  final EdgeInsetsGeometry padding;

  /// The dialog width
  final double? width;

  /// The dialog max width
  final double maxWidth;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// Creates an [AppDialog]
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.icon,
    this.iconColor,
    this.titleStyle,
    this.contentStyle,
    this.borderRadius = 16,
    this.elevation = 24,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(24),
    this.width,
    this.maxWidth = 400,
    this.semanticLabel,
  }) : assert(content != null || contentWidget != null,
            'Either content or contentWidget must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: AccessibilityUtils.addSemanticLabel(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            minWidth: width ?? 280,
          ),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Center(
                    child: Icon(
                      icon,
                      size: 48,
                      color: iconColor ?? colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  title,
                  style: titleStyle ?? theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                contentWidget ??
                    Text(
                      content!,
                      style: contentStyle ?? theme.textTheme.bodyMedium,
                    ),
                const SizedBox(height: 24),
                _buildButtons(context),
              ],
            ),
          ),
        ),
        label: semanticLabel ?? title,
        hint: content,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (secondaryButtonText != null)
          AppButton(
            text: secondaryButtonText!,
            onPressed: onSecondaryButtonPressed ??
                () => Navigator.of(context).pop(false),
            type: AppButtonType.outline,
            size: AppButtonSize.small,
            semanticLabel: secondaryButtonText,
          ),
        if (secondaryButtonText != null) const SizedBox(width: 8),
        if (primaryButtonText != null)
          AppButton(
            text: primaryButtonText!,
            onPressed: onPrimaryButtonPressed ??
                () => Navigator.of(context).pop(true),
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            semanticLabel: primaryButtonText,
          ),
      ],
    );
  }
}

/// Shows a dialog with the given parameters
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  String? content,
  Widget? contentWidget,
  String? primaryButtonText,
  String? secondaryButtonText,
  VoidCallback? onPrimaryButtonPressed,
  VoidCallback? onSecondaryButtonPressed,
  IconData? icon,
  Color? iconColor,
  TextStyle? titleStyle,
  TextStyle? contentStyle,
  double borderRadius = 16,
  double elevation = 24,
  Color? backgroundColor,
  EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  double? width,
  double maxWidth = 400,
  String? semanticLabel,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AppDialog(
      title: title,
      content: content,
      contentWidget: contentWidget,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryButtonPressed: onPrimaryButtonPressed,
      onSecondaryButtonPressed: onSecondaryButtonPressed,
      icon: icon,
      iconColor: iconColor,
      titleStyle: titleStyle,
      contentStyle: contentStyle,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      padding: padding,
      width: width,
      maxWidth: maxWidth,
      semanticLabel: semanticLabel,
    ),
  );
}

/// Shows a confirmation dialog
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  IconData? icon,
  Color? iconColor,
  bool barrierDismissible = true,
}) {
  return showAppDialog<bool>(
    context: context,
    title: title,
    content: content,
    primaryButtonText: confirmText,
    secondaryButtonText: cancelText,
    icon: icon,
    iconColor: iconColor,
    barrierDismissible: barrierDismissible,
  );
}

/// Shows an error dialog
Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'OK',
  bool barrierDismissible = true,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: content,
    primaryButtonText: buttonText,
    icon: Icons.error_outline,
    iconColor: Theme.of(context).colorScheme.error,
    barrierDismissible: barrierDismissible,
  );
}

/// Shows a success dialog
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'OK',
  bool barrierDismissible = true,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: content,
    primaryButtonText: buttonText,
    icon: Icons.check_circle_outline,
    iconColor: Colors.green,
    barrierDismissible: barrierDismissible,
  );
}

/// Shows an info dialog
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'OK',
  bool barrierDismissible = true,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: content,
    primaryButtonText: buttonText,
    icon: Icons.info_outline,
    iconColor: Theme.of(context).colorScheme.primary,
    barrierDismissible: barrierDismissible,
  );
}

/// Shows a warning dialog
Future<void> showWarningDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'OK',
  bool barrierDismissible = true,
}) {
  return showAppDialog(
    context: context,
    title: title,
    content: content,
    primaryButtonText: buttonText,
    icon: Icons.warning_amber_outlined,
    iconColor: Colors.orange,
    barrierDismissible: barrierDismissible,
  );
}
