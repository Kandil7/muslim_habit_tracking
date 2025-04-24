import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/app_localizations_extension.dart';
import '../../utils/accessibility_utils.dart';

/// Text size options
enum TextSizeOption {
  /// Small text size
  small(0.8, 'Small'),

  /// Normal text size
  normal(1.0, 'Normal'),

  /// Large text size
  large(1.2, 'Large'),

  /// Extra large text size
  extraLarge(1.5, 'Extra Large');

  /// The scale factor
  final double scaleFactor;

  /// The display name
  final String displayName;

  /// Creates a [TextSizeOption]
  const TextSizeOption(this.scaleFactor, this.displayName);
}

/// A widget for selecting text size
class TextSizeSelector extends StatefulWidget {
  /// The current text size option
  final TextSizeOption currentSize;

  /// The callback when the text size changes
  final ValueChanged<TextSizeOption> onTextSizeChanged;

  /// Creates a [TextSizeSelector]
  const TextSizeSelector({
    super.key,
    required this.currentSize,
    required this.onTextSizeChanged,
  });

  @override
  State<TextSizeSelector> createState() => _TextSizeSelectorState();
}

class _TextSizeSelectorState extends State<TextSizeSelector> {
  late TextSizeOption _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.currentSize;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccessibilityUtils.addSemanticLabelToHeader(
          Text(
            context.tr.translate('settings.textSize'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          label: context.tr.translate('settings.textSize'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: TextSizeOption.values.map((size) {
            return _buildSizeOption(context, size);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeOption(BuildContext context, TextSizeOption size) {
    final isSelected = _selectedSize == size;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14 * size.scaleFactor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        );

    return AccessibilityUtils.createSemanticButton(
      label: size.displayName,
      hint: isSelected
          ? context.tr.translate('settings.textSizeSelected')
          : context.tr.translate('settings.selectTextSize'),
      onPressed: () => _selectSize(size),
      child: InkWell(
        onTap: () => _selectSize(size),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            size.displayName,
            style: textStyle,
          ),
        ),
      ),
    );
  }

  void _selectSize(TextSizeOption size) {
    setState(() {
      _selectedSize = size;
    });
    widget.onTextSizeChanged(size);
    _saveTextSizePreference(size);
  }

  Future<void> _saveTextSizePreference(TextSizeOption size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('text_size', size.name);
  }
}

/// A provider for text size
class TextSizeProvider extends ChangeNotifier {
  /// The current text size option
  TextSizeOption _textSize = TextSizeOption.normal;

  /// Gets the current text size option
  TextSizeOption get textSize => _textSize;

  /// Gets the current text scale factor
  double get textScaleFactor => _textSize.scaleFactor;

  /// Creates a [TextSizeProvider]
  TextSizeProvider() {
    _loadTextSizePreference();
  }

  /// Sets the text size
  void setTextSize(TextSizeOption size) {
    _textSize = size;
    notifyListeners();
    _saveTextSizePreference(size);
  }

  Future<void> _loadTextSizePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final sizeName = prefs.getString('text_size');
    if (sizeName != null) {
      try {
        _textSize = TextSizeOption.values.firstWhere(
          (size) => size.name == sizeName,
        );
        notifyListeners();
      } catch (e) {
        // Ignore if the saved value is invalid
      }
    }
  }

  Future<void> _saveTextSizePreference(TextSizeOption size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('text_size', size.name);
  }
}
