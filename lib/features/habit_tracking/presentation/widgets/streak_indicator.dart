import 'package:flutter/material.dart';

/// Widget to display a streak indicator
class StreakIndicator extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int? targetStreak;
  final Color? color;

  /// Creates a new StreakIndicator
  const StreakIndicator({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.targetStreak,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: effectiveColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Streak',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Current streak
            Row(
              children: [
                Expanded(
                  child: _buildStreakItem(
                    context,
                    'Current',
                    currentStreak,
                    effectiveColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStreakItem(
                    context,
                    'Longest',
                    longestStreak,
                    effectiveColor,
                  ),
                ),
              ],
            ),
            
            // Target streak
            if (targetStreak != null && targetStreak! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target: $targetStreak days',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: currentStreak / targetStreak!,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                      color: effectiveColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currentStreak > targetStreak! ? 100 : ((currentStreak / targetStreak!) * 100).toInt()}% complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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
  
  Widget _buildStreakItem(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$value',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'days',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
