import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'animated_dashboard_card.dart';

/// Card widget for Hadith of the Day
class HadithCard extends StatelessWidget {
  final VoidCallback? onReorder;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;
  final bool isReorderable;

  const HadithCard({
    super.key,
    this.onReorder,
    this.onVisibilityToggle,
    this.isVisible = true,
    this.isReorderable = false,
  });

  @override
  Widget build(BuildContext context) {
    // In a real app, this would come from an API or database
    const String hadithText = 'The best of you are those who are best to their families, and I am the best of you to my family.';
    const String hadithSource = 'Sunan al-Tirmidhī 3895';
    const String hadithNarrator = 'Narrated by Aisha (RA)';
    
    return AnimatedDashboardCard(
      title: 'Hadith of the Day',
      icon: Icons.format_quote,
      iconColor: AppColors.secondary,
      isReorderable: isReorderable,
      onReorder: onReorder,
      onVisibilityToggle: onVisibilityToggle,
      isVisible: isVisible,
      onTap: () {
        // Navigate to Hadith collection page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hadith Collection feature coming soon!'),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  hadithText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        hadithSource,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        hadithNarrator,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                context,
                icon: Icons.bookmark_outline,
                label: 'Save',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hadith saved to bookmarks!'),
                    ),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                    ),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.refresh,
                label: 'New Hadith',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New hadith loaded!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
