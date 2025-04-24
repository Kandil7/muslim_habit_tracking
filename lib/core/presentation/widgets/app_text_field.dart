import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/accessibility_utils.dart';

/// A standardized text field component
class AppTextField extends StatefulWidget {
  /// The controller for the text field
  final TextEditingController? controller;

  /// The focus node for the text field
  final FocusNode? focusNode;

  /// The label text
  final String? labelText;

  /// The hint text
  final String? hintText;

  /// The helper text
  final String? helperText;

  /// The error text
  final String? errorText;

  /// The prefix icon
  final IconData? prefixIcon;

  /// The suffix icon
  final IconData? suffixIcon;

  /// The callback when the suffix icon is pressed
  final VoidCallback? onSuffixIconPressed;

  /// The callback when the text changes
  final ValueChanged<String>? onChanged;

  /// The callback when the text field is submitted
  final ValueChanged<String>? onSubmitted;

  /// The callback when the text field is tapped
  final VoidCallback? onTap;

  /// The text input type
  final TextInputType? keyboardType;

  /// The text input action
  final TextInputAction? textInputAction;

  /// The text capitalization
  final TextCapitalization textCapitalization;

  /// Whether the text field is obscured
  final bool obscureText;

  /// Whether the text field is enabled
  final bool enabled;

  /// Whether the text field is read-only
  final bool readOnly;

  /// Whether the text field is auto-focused
  final bool autofocus;

  /// Whether the text field expands to fill available space
  final bool expands;

  /// The maximum number of lines
  final int? maxLines;

  /// The minimum number of lines
  final int? minLines;

  /// The maximum length of the text
  final int? maxLength;

  /// Whether to show the counter
  final bool showCounter;

  /// The input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// The text field border radius
  final double borderRadius;

  /// The text field border width
  final double borderWidth;

  /// The text field filled color
  final Color? fillColor;

  /// Whether the text field is filled
  final bool filled;

  /// The text field content padding
  final EdgeInsetsGeometry? contentPadding;

  /// The text style
  final TextStyle? textStyle;

  /// The label style
  final TextStyle? labelStyle;

  /// The hint style
  final TextStyle? hintStyle;

  /// The error style
  final TextStyle? errorStyle;

  /// The helper style
  final TextStyle? helperStyle;

  /// The prefix icon color
  final Color? prefixIconColor;

  /// The suffix icon color
  final Color? suffixIconColor;

  /// The semantic label for accessibility
  final String? semanticLabel;

  /// The semantic hint for accessibility
  final String? semanticHint;

  /// Creates an [AppTextField]
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.expands = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.inputFormatters,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.semanticLabel,
    this.semanticHint,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build the text field
    final textField = TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? colorScheme.primary,
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        filled: widget.filled,
        fillColor: widget.fillColor ?? colorScheme.surface,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: widget.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: widget.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: widget.borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: widget.borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: widget.borderWidth,
          ),
        ),
        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle,
        errorStyle: widget.errorStyle,
        helperStyle: widget.helperStyle,
        counterText: widget.showCounter ? null : '',
      ),
      style: widget.textStyle ?? theme.textTheme.bodyMedium,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      expands: widget.expands,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.expands ? null : widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
    );

    // Add semantic label for accessibility
    if (widget.semanticLabel != null) {
      return AccessibilityUtils.addSemanticLabelToTextField(
        textField,
        label: widget.semanticLabel!,
        hint: widget.semanticHint,
      );
    }

    return textField;
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: widget.suffixIconColor ?? Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: widget.suffixIconColor ?? Theme.of(context).colorScheme.primary,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    return null;
  }
}
