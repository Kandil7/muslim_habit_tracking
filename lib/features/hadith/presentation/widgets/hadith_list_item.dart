import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/hadith.dart';

/// Widget for displaying a hadith in a list
class HadithListItem extends StatelessWidget {
  /// The hadith to display
  final Hadith hadith;
  
  /// Callback when the item is tapped
  final VoidCallback onTap;
  
  /// Callback when the bookmark button is tapped
  final VoidCallback onBookmarkToggle;

  /// Creates a new HadithListItem
  const HadithListItem({
    super.key,
    required this.hadith,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _truncateText(hadith.text, 100),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      hadith.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: hadith.isBookmarked ? AppColors.primary : null,
                    ),
                    onPressed: onBookmarkToggle,
                    tooltip: hadith.isBookmarked
                        ? 'Remove bookmark'
                        : 'Add bookmark',
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hadith.narrator,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${hadith.source} ${hadith.number}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (hadith.tags.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: hadith.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      backgroundColor: AppColors.secondary.withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
