import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// Bottom actions bar for the Surah detail page
class SurahActionsBar extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onSettingsPressed;

  const SurahActionsBar({
    super.key,
    required this.isBookmarked,
    required this.onBookmarkPressed,
    required this.onSharePressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? AppColors.primary : null,
            onPressed: onBookmarkPressed,
          ),
          _buildActionButton(
            context,
            icon: Icons.share,
            onPressed: onSharePressed,
          ),
          _buildActionButton(
            context,
            icon: Icons.settings,
            onPressed: onSettingsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color ?? AppColors.textSecondary),
      onPressed: onPressed,
    );
  }
}
