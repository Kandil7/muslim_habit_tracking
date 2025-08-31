import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/bloc/enhanced_dashboard_state.dart';

/// Widget showing quick access buttons for core modules
class QuickAccessWidget extends StatelessWidget {
  final List<QuickAction> quickActions;

  const QuickAccessWidget({super.key, required this.quickActions});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: quickActions.length,
              itemBuilder: (context, index) {
                return _QuickActionButton(action: quickActions[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for a single quick action button
class _QuickActionButton extends StatelessWidget {
  final QuickAction action;

  const _QuickActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: _getIconColor(), size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                action.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get icon background color
  Color _getIconBackgroundColor() {
    // In a real implementation, this would be based on the action type
    return Colors.blue.withValues(alpha: 0.1);
  }

  /// Get icon color
  Color _getIconColor() {
    // In a real implementation, this would be based on the action type
    return Colors.blue;
  }
}