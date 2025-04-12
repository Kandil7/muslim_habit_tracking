import 'package:flutter/material.dart';

/// Button types for the CustomButton
enum ButtonType {
  /// Primary filled button
  primary,
  
  /// Secondary outlined button
  secondary,
  
  /// Text-only button
  text,
}

/// A reusable custom button widget
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback when the button is pressed
  final VoidCallback? onPressed;
  
  /// The type of button to display
  final ButtonType buttonType;
  
  /// Optional icon to display before the text
  final IconData? icon;
  
  /// Optional width for the button
  final double? width;
  
  /// Optional height for the button
  final double height;
  
  /// Optional padding for the button
  final EdgeInsetsGeometry padding;
  
  /// Optional text style
  final TextStyle? textStyle;
  
  /// Optional background color (only applies to primary button)
  final Color? backgroundColor;
  
  /// Optional foreground/text color
  final Color? foregroundColor;
  
  /// Optional border radius
  final double borderRadius;
  
  /// Optional loading state
  final bool isLoading;

  /// Creates a custom button widget
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = ButtonType.primary,
    this.icon,
    this.width,
    this.height = 50.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 8.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Button content
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                buttonType == ButtonType.primary
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
    
    // Container for fixed width/height
    if (width != null) {
      buttonContent = SizedBox(
        width: width,
        height: height,
        child: Center(child: buttonContent),
      );
    }
    
    // Disable button when loading
    final effectiveOnPressed = isLoading ? null : onPressed;
    
    // Build the appropriate button type
    switch (buttonType) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: buttonContent,
        );
        
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            side: BorderSide(
              color: foregroundColor ?? theme.colorScheme.primary,
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: buttonContent,
        );
        
      case ButtonType.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(width ?? 0, height),
          ),
          child: buttonContent,
        );
    }
  }
}
