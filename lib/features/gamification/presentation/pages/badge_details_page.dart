import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/badge.dart' as custom;
import '../bloc/badge_bloc.dart';
import '../bloc/badge_event.dart';
import '../bloc/user_points_bloc.dart';
import '../bloc/user_points_event.dart';

/// Page to display badge details
class BadgeDetailsPage extends StatelessWidget {
  final custom.Badge badge;

  /// Creates a new BadgeDetailsPage
  const BadgeDetailsPage({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Badge Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getLevelColor(badge.level).withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Image.asset(
                  badge.iconPath,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.emoji_events,
                      size: 60,
                      color: _getLevelColor(badge.level),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Badge name
            Text(
              badge.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    badge.isEarned
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Badge level and points
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getLevelColor(badge.level).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    badge.level.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _getLevelColor(badge.level),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.star, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  '${badge.points} points',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Badge status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    badge.isEarned
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      badge.isEarned
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    badge.isEarned ? Icons.check_circle : Icons.hourglass_top,
                    color:
                        badge.isEarned
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          badge.isEarned ? 'Badge Earned' : 'Badge Not Earned',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                badge.isEarned
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (badge.isEarned && badge.earnedDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Earned on ${_formatDate(badge.earnedDate!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        if (!badge.isEarned && badge.progress > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${badge.progress}% progress',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Badge description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(badge.description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Badge requirements
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requirements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...badge.requirements.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatRequirement(entry.key, entry.value),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Debug buttons (for testing)
            if (!badge.isEarned)
              ElevatedButton(
                onPressed: () {
                  // Award the badge (for testing)
                  context.read<BadgeBloc>().add(
                    AwardBadgeEvent(badgeId: badge.id),
                  );

                  // Add points
                  context.read<UserPointsBloc>().add(
                    AddPointsEvent(
                      points: badge.points,
                      reason: 'Earned badge: ${badge.name}',
                    ),
                  );

                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Badge awarded: ${badge.name}'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );

                  // Navigate back
                  Navigator.pop(context);
                },
                child: const Text('Award Badge (Debug)'),
              ),
          ],
        ),
      ),
    );
  }

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format requirement to a readable string
  String _formatRequirement(String key, dynamic value) {
    switch (key) {
      case 'prayer_streak':
        return 'Complete all daily prayers for $value consecutive days';
      case 'quran_pages':
        return 'Read $value pages of Quran';
      case 'quran_streak':
        return 'Read Quran for $value consecutive days';
      case 'fasting_days':
        return 'Complete $value days of fasting';
      case 'ramadan_days':
        return 'Complete $value days of fasting in Ramadan';
      case 'monday_thursday_fasts':
        return 'Fast on $value Mondays and Thursdays';
      case 'dhikr_count':
        return 'Perform $value dhikrs';
      case 'dhikr_types':
        return 'Use $value different types of dhikr';
      case 'charity_count':
        return 'Record $value charity acts';
      case 'charity_streak':
        return 'Give charity for $value consecutive days';
      case 'any_habit_streak':
        return 'Maintain any habit for $value consecutive days';
      case 'habit_count':
        return 'Track $value different habits';
      case 'tahajjud_count':
        return 'Perform Tahajjud prayer $value times';
      default:
        return '$key: $value';
    }
  }

  /// Get color based on badge level
  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return Colors.brown;
      case 'silver':
        return Colors.blueGrey;
      case 'gold':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }
}
