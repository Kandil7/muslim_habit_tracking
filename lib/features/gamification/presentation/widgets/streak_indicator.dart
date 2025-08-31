import 'package:flutter/material.dart';

/// Widget to display a streak indicator
class StreakIndicator extends StatelessWidget {
  final int streak;
  final int? targetStreak;
  final String label;
  final IconData icon;
  final Color? color;

  /// Creates a new StreakIndicator
  const StreakIndicator({
    super.key,
    required this.streak,
    this.targetStreak,
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Streak icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveColor.withValues(alpha:0.1),
              ),
              child: Icon(
                icon,
                color: effectiveColor,
                size: 24,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Streak count
            Text(
              '$streak',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Streak label
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            // Target streak indicator
            if (targetStreak != null && targetStreak! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: streak / targetStreak!,
                      backgroundColor: theme.colorScheme.onSurface.withValues(alpha:0.1),
                      color: effectiveColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target: $targetStreak',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha:0.6),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
