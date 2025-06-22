import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';

class DhikrItem extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const DhikrItem({
    super.key,
    required this.dhikr,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          dhikr.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${dhikr.recommendedCount} times',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(
            dhikr.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: dhikr.isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
