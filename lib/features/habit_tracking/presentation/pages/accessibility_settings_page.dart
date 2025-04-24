import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/presentation/widgets/contrast_selector.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/presentation/widgets/text_size_selector.dart';
import '../../../../core/utils/accessibility_utils.dart';

/// A page for accessibility settings
class AccessibilitySettingsPage extends StatefulWidget {
  /// Creates an [AccessibilitySettingsPage]
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() =>
      _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    final contrastProvider = Provider.of<ContrastProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: AccessibilityUtils.addSemanticLabelToHeader(
          Text(context.tr.translate('settings.accessibility')),
          label: context.tr.translate('settings.accessibility'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: context.tr.translate('settings.textSize'),
            ),
            const SizedBox(height: 16),
            TextSizeSelector(
              currentSize: textSizeProvider.textSize,
              onTextSizeChanged: (size) {
                textSizeProvider.setTextSize(size);
              },
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: context.tr.translate('settings.contrast'),
            ),
            const SizedBox(height: 16),
            ContrastSelector(
              currentContrast: contrastProvider.contrast,
              onContrastChanged: (contrast) {
                contrastProvider.setContrast(contrast);
              },
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: context.tr.translate('settings.screenReader'),
            ),
            const SizedBox(height: 16),
            _buildScreenReaderInfo(context),
            const SizedBox(height: 24),
            SectionHeader(
              title: context.tr.translate('settings.animations'),
            ),
            const SizedBox(height: 16),
            _buildAnimationsSwitch(context),
            const SizedBox(height: 24),
            SectionHeader(
              title: context.tr.translate('settings.hapticFeedback'),
            ),
            const SizedBox(height: 16),
            _buildHapticFeedbackSwitch(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenReaderInfo(BuildContext context) {
    return AccessibilityUtils.addSemanticLabel(
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.translate('settings.screenReaderInfo'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                context.tr.translate('settings.screenReaderDescription'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Open system accessibility settings
                },
                icon: const Icon(Icons.settings),
                label: Text(
                  context.tr.translate('settings.openSystemSettings'),
                ),
              ),
            ],
          ),
        ),
      ),
      label: context.tr.translate('settings.screenReaderInfo'),
      hint: context.tr.translate('settings.screenReaderDescription'),
    );
  }

  Widget _buildAnimationsSwitch(BuildContext context) {
    return AccessibilityUtils.addSemanticLabel(
      SwitchListTile(
        title: Text(context.tr.translate('settings.reduceAnimations')),
        subtitle: Text(context.tr.translate('settings.reduceAnimationsDescription')),
        value: false, // TODO: Get from provider
        onChanged: (value) {
          // TODO: Set in provider
        },
        secondary: const Icon(Icons.animation),
      ),
      label: context.tr.translate('settings.reduceAnimations'),
      hint: context.tr.translate('settings.reduceAnimationsDescription'),
    );
  }

  Widget _buildHapticFeedbackSwitch(BuildContext context) {
    return AccessibilityUtils.addSemanticLabel(
      SwitchListTile(
        title: Text(context.tr.translate('settings.enableHapticFeedback')),
        subtitle: Text(context.tr.translate('settings.hapticFeedbackDescription')),
        value: true, // TODO: Get from provider
        onChanged: (value) {
          // TODO: Set in provider
        },
        secondary: const Icon(Icons.vibration),
      ),
      label: context.tr.translate('settings.enableHapticFeedback'),
      hint: context.tr.translate('settings.hapticFeedbackDescription'),
    );
  }
}
