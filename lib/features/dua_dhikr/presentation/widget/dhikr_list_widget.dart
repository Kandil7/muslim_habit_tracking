import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dhikr_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dhikr_item.dart';

class DhikrListWidget extends StatelessWidget {
  final List<Dhikr> dhikrs;

  const DhikrListWidget({super.key, required this.dhikrs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = dhikrs[index];
        return DhikrItem(
          dhikr: dhikr,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DhikrDetailScreen(dhikr: dhikr),
                ),
              ),
          onFavoriteToggle:
              () => context.read<DuaDhikrBloc>().add(
                ToggleDhikrFavoriteStatus(dhikr.id),
              ),
        );
      },
    );
  }
}
