import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';

class DhikrDetailScreen extends StatelessWidget {
  final Dhikr dhikr;

  const DhikrDetailScreen({super.key, required this.dhikr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dhikr.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic Text
            Text(
              dhikr.arabicText,
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
              dhikr.transliteration,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Translation
            Text(
              dhikr.translation,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Reference
            Text(
              'Reference: ${dhikr.reference}',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Count
            Text(
              'Recommended count: ${dhikr.recommendedCount}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.read<DuaDhikrBloc>().add(
              ToggleDhikrFavoriteStatus(dhikr.id),
            ),
        child: Icon(
          dhikr.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
