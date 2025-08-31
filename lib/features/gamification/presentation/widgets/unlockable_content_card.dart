import 'package:flutter/material.dart';

import '../../domain/entities/unlockable_content.dart';

/// Widget to display unlockable content
class UnlockableContentCard extends StatelessWidget {
  final UnlockableContent content;
  final VoidCallback? onTap;
  final VoidCallback? onUnlock;
  final bool canUnlock;

  /// Creates a new UnlockableContentCard
  const UnlockableContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.onUnlock,
    this.canUnlock = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              content.isUnlocked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha:0.5),
          width: content.isUnlocked ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Preview image
                  Image.asset(
                    content.previewPath,
                    height: 120,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          _getContentTypeIcon(content.contentType),
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),

                  // Lock overlay for locked content
                  if (!content.isUnlocked)
                    Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.black.withValues(alpha:0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, color: Colors.white, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            '${content.pointsRequired} points to unlock',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Content details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content name
                  Text(
                    content.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          content.isUnlocked
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Content description
                  Text(
                    content.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Unlock button or status
                  if (content.isUnlocked)
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Unlocked',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (content.unlockedDate != null)
                          Expanded(
                            child: Text(
                              ' on ${_formatDate(content.unlockedDate!)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha:
                                  0.6,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: canUnlock ? onUnlock : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        disabledBackgroundColor: theme.colorScheme.onSurface
                            .withValues(alpha:0.12),
                        disabledForegroundColor: theme.colorScheme.onSurface
                            .withValues(alpha:0.38),
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: Text(
                        canUnlock ? 'Unlock Now' : 'Not Enough Points',
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

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get icon based on content type
  IconData _getContentTypeIcon(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'quote':
        return Icons.format_quote;
      case 'dua':
        return Icons.auto_stories;
      case 'wallpaper':
        return Icons.wallpaper;
      case 'feature':
        return Icons.extension;
      default:
        return Icons.star;
    }
  }
}
