import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dhikr_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/dua_detail_screen.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dhikr_item.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/widget/dua_item.dart';

class DuaDhikrPage extends StatefulWidget {
  const DuaDhikrPage({super.key});

  @override
  State<DuaDhikrPage> createState() => _DuaDhikrPageState();
}

class _DuaDhikrPageState extends State<DuaDhikrPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load initial data when the page is first created
    context.read<DuaDhikrBloc>().add(const LoadInitialData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duas & Dhikrs'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Theme.of(context).textTheme.bodyLarge?.color,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book)),
            Tab(icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [DuaCategoriesTab(), DhikrListTab()],
      ),
    );
  }
}

class DuaCategoriesTab extends StatelessWidget {
  const DuaCategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InitialDataLoaded) {
          return _buildCategoryList(state.categories);
        } else if (state is OperationFailed) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No categories available'));
      },
    );
  }

  Widget _buildCategoryList(List<String> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToDuasByCategory(context, category),
          ),
        );
      },
    );
  }

  void _navigateToDuasByCategory(BuildContext context, String category) {
    context.read<DuaDhikrBloc>().add(LoadDuasByCategory(category));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuasByCategoryScreen(category: category),
      ),
    );
  }
}

class DhikrListTab extends StatelessWidget {
  const DhikrListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InitialDataLoaded) {
          return _buildDhikrList(state.dhikrs);
        } else if (state is DhikrsLoaded) {
          return _buildDhikrList(state.dhikrs);
        } else if (state is OperationFailed) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No dhikrs available'));
      },
    );
  }

  Widget _buildDhikrList(List<Dhikr> dhikrs) {
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
            return Center(child: Text(state.message));
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
