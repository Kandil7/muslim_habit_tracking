import 'package:flutter/material.dart';

import '../../domain/entities/badge.dart' as custom;

/// Widget to display a badge
class BadgeCard extends StatelessWidget {
  final custom.Badge badge;
  final VoidCallback? onTap;

  /// Creates a new BadgeCard
  const BadgeCard({super.key, required this.badge, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              badge.isEarned
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha:0.5),
          width: badge.isEarned ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge icon with overlay for locked badges
              Stack(
                alignment: Alignment.center,
                children: [
                  // Badge image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getLevelColor(badge.level).withValues(alpha:0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        badge.iconPath,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.emoji_events,
                            size: 40,
                            color: _getLevelColor(badge.level),
                          );
                        },
                      ),
                    ),
                  ),

                  // Lock overlay for unearned badges
                  if (!badge.isEarned)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha:0.5),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                  // Progress indicator for unearned badges
                  if (!badge.isEarned && badge.progress > 0)
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: badge.progress / 100,
                        strokeWidth: 3,
                        backgroundColor: Colors.grey.withValues(alpha:0.3),
                        color: _getLevelColor(badge.level),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Badge name
              Text(
                badge.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      badge.isEarned
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Badge description
              Text(
                badge.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Badge level and points
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColor(badge.level).withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge.level.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getLevelColor(badge.level),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.star,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${badge.points} pts',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              // Earned date
              if (badge.isEarned && badge.earnedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Earned on ${_formatDate(badge.earnedDate!)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
