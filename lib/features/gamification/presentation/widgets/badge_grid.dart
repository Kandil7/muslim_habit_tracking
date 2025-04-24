import 'package:flutter/material.dart';

import '../../domain/entities/badge.dart' as custom;
import 'badge_card.dart';

/// Widget to display a grid of badges
class BadgeGrid extends StatelessWidget {
  final List<custom.Badge> badges;
  final Function(custom.Badge)? onBadgeTap;
  final String emptyMessage;

  /// Creates a new BadgeGrid
  const BadgeGrid({
    super.key,
    required this.badges,
    this.onBadgeTap,
    this.emptyMessage = 'No badges found',
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final custom.Badge badge = badges[index];
        return BadgeCard(
          badge: badge,
          onTap: onBadgeTap != null ? () => onBadgeTap!(badge) : null,
        );
      },
    );
  }
}
