import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dua_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dua_item.dart';

class DuasByCategoryScreen extends StatelessWidget {
  final String category;

  const DuasByCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DuasByCategoryLoaded) {
            return _buildDuaList(state.duas);
          } else if (state is OperationFailed) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No duas available'));
        },
      ),
    );
  }

  Widget _buildDuaList(List<Dua> duas) {
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
