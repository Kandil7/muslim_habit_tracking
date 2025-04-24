import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// A utility class for accessibility features
class AccessibilityUtils {
  /// Adds semantic labels to a widget
  static Widget addSemanticLabel(
    Widget child, {
    required String label,
    String? hint,
    bool excludeSemantics = false,
    bool isButton = false,
    bool isTextField = false,
    bool isImage = false,
    bool isLink = false,
    bool isHeader = false,
    bool isChecked = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      textField: isTextField,
      image: isImage,
      link: isLink,
      header: isHeader,
      checked: isChecked,
      excludeSemantics: excludeSemantics,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  /// Adds semantic labels to an icon button
  static Widget addSemanticLabelToIconButton(
    Widget child, {
    required String label,
    String? hint,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  /// Adds semantic labels to an image
  static Widget addSemanticLabelToImage(
    Widget child, {
    required String label,
    String? hint,
  }) {
    return Semantics(label: label, hint: hint, image: true, child: child);
  }

  /// Adds semantic labels to a text field
  static Widget addSemanticLabelToTextField(
    Widget child, {
    required String label,
    String? hint,
  }) {
    return Semantics(label: label, hint: hint, textField: true, child: child);
  }

  /// Adds semantic labels to a link
  static Widget addSemanticLabelToLink(
    Widget child, {
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      link: true,
      onTap: onTap,
      child: child,
    );
  }

  /// Adds semantic labels to a header
  static Widget addSemanticLabelToHeader(
    Widget child, {
    required String label,
    String? hint,
  }) {
    return Semantics(label: label, hint: hint, header: true, child: child);
  }

  /// Adds semantic labels to a checkbox
  static Widget addSemanticLabelToCheckbox(
    Widget child, {
    required String label,
    required bool isChecked,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      checked: isChecked,
      child: child,
    );
  }

  /// Creates a semantic button
  static Widget createSemanticButton({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: GestureDetector(onTap: enabled ? onPressed : null, child: child),
    );
  }

  /// Merges semantics for a group of widgets
  static Widget mergeSemantics({
    required List<Widget> children,
    required String label,
    String? hint,
    bool isButton = false,
    bool isTextField = false,
    bool isImage = false,
    bool isLink = false,
    bool isHeader = false,
    bool isChecked = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      textField: isTextField,
      image: isImage,
      link: isLink,
      header: isHeader,
      checked: isChecked,
      onTap: onTap,
      onLongPress: onLongPress,
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  /// Excludes semantics for a widget
  static Widget excludeSemantics(Widget child) {
    return ExcludeSemantics(child: child);
  }

  /// Adds a custom action to a widget
  static Widget addCustomAction({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      customSemanticsActions: {CustomSemanticsAction(label: label): onPressed},
      child: child,
    );
  }
}
