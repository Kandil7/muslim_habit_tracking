import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';

class DuaDetailScreen extends StatelessWidget {
  final Dua dua;

  const DuaDetailScreen({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dua.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic Text
            Text(
              dua.arabicText,
              style: const TextStyle(
                fontSize: 28,
                fontFamily: 'Uthmanic',
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Transliteration
            Text(
              dua.transliteration,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Translation
            Text(
              dua.translation,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Reference
            Text(
              'Reference: ${dua.reference}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.read<DuaDhikrBloc>().add(
              ToggleDuaFavoriteStatus(dua.id),
            ),
        child: Icon(
          dua.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
