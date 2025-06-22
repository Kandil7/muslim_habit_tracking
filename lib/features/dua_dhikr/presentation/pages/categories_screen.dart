import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/presentation/pages/duas_by_category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DuaCategoriesLoaded) {
          return _buildCategoryList(state.categories);
        } else if (state is OperationFailed) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No categories available'));
      },
    );
  }

  Widget _buildCategoryList(List<String> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category),
          trailing: const Icon(Icons.chevron_right),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DuasByCategoryScreen(category: category),
                ),
              ),
        );
      },
    );
  }
}
