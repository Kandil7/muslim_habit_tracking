import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dhikr_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dhikr_item.dart';

class DhikrListScreen extends StatelessWidget {
  const DhikrListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dhikrs')),
      body: BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DhikrsLoaded) {
            return _buildDhikrList(state.dhikrs);
          } else if (state is OperationFailed) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No dhikrs available'));
        },
      ),
    );
  }

  Widget _buildDhikrList(List<Dhikr> dhikrs) {
    return ListView.builder(
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
