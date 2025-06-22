import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dhikr_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dua_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dhikr_item.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dua_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.menu_book)),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildFavoriteDuasTab(), _buildFavoriteDhikrsTab()],
        ),
      ),
    );
  }

  Widget _buildFavoriteDuasTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteDuasLoaded) {
          return _buildFavoriteDuasList(state.duas);
        } else if (state is OperationFailed) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No favorite duas'));
      },
    );
  }

  Widget _buildFavoriteDhikrsTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteDhikrsLoaded) {
          return _buildFavoriteDhikrsList(state.dhikrs);
        } else if (state is OperationFailed) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No favorite dhikrs'));
      },
    );
  }

  Widget _buildFavoriteDuasList(List<Dua> duas) {
    return ListView.builder(
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

  Widget _buildFavoriteDhikrsList(List<Dhikr> dhikrs) {
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
