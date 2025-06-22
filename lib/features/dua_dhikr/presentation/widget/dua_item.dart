import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';

class DuaItem extends StatelessWidget {
  final Dua dua;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const DuaItem({
    super.key,
    required this.dua,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          dua.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          dua.category,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(
            dua.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: dua.isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
