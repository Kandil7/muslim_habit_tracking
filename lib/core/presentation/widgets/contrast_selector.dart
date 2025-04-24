import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/app_localizations_extension.dart';
import '../../utils/accessibility_utils.dart';

/// Contrast options
enum ContrastOption {
  /// Normal contrast
  normal('Normal'),

  /// High contrast
  high('High Contrast');

  /// The display name
  final String displayName;

  /// Creates a [ContrastOption]
  const ContrastOption(this.displayName);
}

/// A widget for selecting contrast
class ContrastSelector extends StatefulWidget {
  /// The current contrast option
  final ContrastOption currentContrast;

  /// The callback when the contrast changes
  final ValueChanged<ContrastOption> onContrastChanged;

  /// Creates a [ContrastSelector]
  const ContrastSelector({
    super.key,
    required this.currentContrast,
    required this.onContrastChanged,
  });

  @override
  State<ContrastSelector> createState() => _ContrastSelectorState();
}

class _ContrastSelectorState extends State<ContrastSelector> {
  late ContrastOption _selectedContrast;

  @override
  void initState() {
    super.initState();
    _selectedContrast = widget.currentContrast;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccessibilityUtils.addSemanticLabelToHeader(
          Text(
            context.tr.translate('settings.contrast'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          label: context.tr.translate('settings.contrast'),
        ),
        const SizedBox(height: 16),
        Row(
          children: ContrastOption.values.map((contrast) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildContrastOption(context, contrast),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContrastOption(BuildContext context, ContrastOption contrast) {
    final isSelected = _selectedContrast == contrast;
    final backgroundColor = contrast == ContrastOption.high
        ? Colors.black
        : Theme.of(context).colorScheme.surface;
    final textColor = contrast == ContrastOption.high
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    return AccessibilityUtils.createSemanticButton(
      label: contrast.displayName,
      hint: isSelected
          ? context.tr.translate('settings.contrastSelected')
          : context.tr.translate('settings.selectContrast'),
      onPressed: () => _selectContrast(contrast),
      child: InkWell(
        onTap: () => _selectContrast(contrast),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            contrast.displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _selectContrast(ContrastOption contrast) {
    setState(() {
      _selectedContrast = contrast;
    });
    widget.onContrastChanged(contrast);
    _saveContrastPreference(contrast);
  }

  Future<void> _saveContrastPreference(ContrastOption contrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contrast', contrast.name);
  }
}

/// A provider for contrast
class ContrastProvider extends ChangeNotifier {
  /// The current contrast option
  ContrastOption _contrast = ContrastOption.normal;

  /// Gets the current contrast option
  ContrastOption get contrast => _contrast;

  /// Gets whether high contrast is enabled
  bool get isHighContrast => _contrast == ContrastOption.high;

  /// Creates a [ContrastProvider]
  ContrastProvider() {
    _loadContrastPreference();
  }

  /// Sets the contrast
  void setContrast(ContrastOption contrast) {
    _contrast = contrast;
    notifyListeners();
    _saveContrastPreference(contrast);
  }

  Future<void> _loadContrastPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final contrastName = prefs.getString('contrast');
    if (contrastName != null) {
      try {
        _contrast = ContrastOption.values.firstWhere(
          (contrast) => contrast.name == contrastName,
        );
        notifyListeners();
      } catch (e) {
        // Ignore if the saved value is invalid
      }
    }
  }

  Future<void> _saveContrastPreference(ContrastOption contrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contrast', contrast.name);
  }
}
