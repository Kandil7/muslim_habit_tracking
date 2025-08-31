import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/unlockable_content.dart';

/// Page to display unlockable content details
class UnlockableContentDetailsPage extends StatelessWidget {
  final UnlockableContent content;

  /// Creates a new UnlockableContentDetailsPage
  const UnlockableContentDetailsPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(content.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
                            SharePlus.instance.share(
                ShareParams(
                  text:
                      'Check out this ${content.contentType} from Muslim Habit Tracker: ${content.name}',
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content image
            if (content.contentType == 'wallpaper')
              Image.asset(
                content.contentPath,
                fit: BoxFit.cover,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.wallpaper,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              )
            else
              Container(
                height: 200,
                color: theme.colorScheme.primaryContainer,
                child: Center(
                  child: Icon(
                    _getContentTypeIcon(content.contentType),
                    size: 64,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content name
                  Text(
                    content.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Content description
                  Text(content.description, style: theme.textTheme.bodyLarge),

                  const SizedBox(height: 16),

                  // Content details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha:0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          context,
                          'Type',
                          _formatContentType(content.contentType),
                        ),
                        _buildDetailRow(
                          context,
                          'Unlocked On',
                          content.unlockedDate != null
                              ? _formatDate(content.unlockedDate!)
                              : 'Unknown',
                        ),
                        _buildDetailRow(
                          context,
                          'Points Cost',
                          '${content.pointsRequired} points',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  if (content.contentType == 'wallpaper')
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement wallpaper setting
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Wallpaper set as device background'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.wallpaper),
                      label: const Text('Set as Wallpaper'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    )
                  else if (content.contentType == 'quote')
                    ElevatedButton.icon(
                      onPressed: () {
                        // Copy quote to clipboard
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                'Quote from Muslim Habit Tracker: ${content.name}',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote copied to clipboard'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy to Clipboard'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    )
                  else if (content.contentType == 'dua')
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add to favorites
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dua added to favorites'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Add to Favorites'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format content type to a readable string
  String _formatContentType(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'quote':
        return 'Motivational Quote';
      case 'dua':
        return 'Dua Card';
      case 'wallpaper':
        return 'Wallpaper';
      case 'feature':
        return 'Special Feature';
      default:
        return contentType;
    }
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
