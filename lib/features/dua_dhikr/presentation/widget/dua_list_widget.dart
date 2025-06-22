import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dua_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dua_item.dart';

class DuaListWidget extends StatelessWidget {
  final List<Dua> duas;

  const DuaListWidget({super.key, required this.duas});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return DuaItem(
          dua: dua,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DuaDetailScreen(dua: dua),
                ),
              ),
          onFavoriteToggle:
              () => context.read<DuaDhikrBloc>().add(
                ToggleDuaFavoriteStatus(dua.id),
              ),
        );
      },
    );
  }
}
