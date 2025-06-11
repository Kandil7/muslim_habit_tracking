import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations_extension.dart';
import '../../domain/entities/hadith.dart';
import '../bloc/hadith_bloc.dart';
import '../bloc/hadith_event.dart';
import '../bloc/hadith_state.dart';
import '../widgets/hadith_list_item.dart';
import 'hadith_detail_page.dart';

/// Page displaying a collection of hadiths
class HadithCollectionPage extends StatefulWidget {
  /// Creates a new HadithCollectionPage
  const HadithCollectionPage({super.key});

  @override
  State<HadithCollectionPage> createState() => _HadithCollectionPageState();
}

class _HadithCollectionPageState extends State<HadithCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load all hadiths
    context.read<HadithBloc>().add(const GetAllHadithsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('hadith.title')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.tr.translate('hadith.all')),
            Tab(text: context.tr.translate('hadith.categories')),
            Tab(text: context.tr.translate('hadith.bookmarks')),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.tr.translate('hadith.search'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllHadithsTab(),
                _buildCategoriesTab(),
                _buildBookmarksTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllHadithsTab() {
    return BlocBuilder<HadithBloc, HadithState>(
      builder: (context, state) {
        if (state is HadithLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllHadithsLoaded) {
          final hadiths = state.hadiths;

          // Filter hadiths based on search query
          final filteredHadiths =
              _searchQuery.isEmpty
                  ? hadiths
                  : hadiths.where((hadith) {
                    return hadith.text.toLowerCase().contains(_searchQuery) ||
                        hadith.narrator.toLowerCase().contains(_searchQuery) ||
                        hadith.source.toLowerCase().contains(_searchQuery);
                  }).toList();

          if (filteredHadiths.isEmpty) {
            return Center(
              child: Text(context.tr.translate('hadith.noHadithsFound')),
            );
          }

          return ListView.builder(
            itemCount: filteredHadiths.length,
            itemBuilder: (context, index) {
              final hadith = filteredHadiths[index];
              return HadithListItem(
                hadith: hadith,
                onTap: () => _navigateToHadithDetail(hadith),
                onBookmarkToggle: () => _toggleBookmark(hadith.id),
              );
            },
          );
        } else if (state is HadithError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HadithBloc>().add(const GetAllHadithsEvent());
                  },
                  child: Text(context.tr.translate('home.retry')),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCategoriesTab() {
    // List of hadith categories/tags
    final categories = [
      'Character',
      'Faith',
      'Family',
      'Brotherhood',
      'Self-control',
      'Speech',
      'Deeds',
      'Intention',
      'Safety',
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category),
          leading: const Icon(Icons.label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.read<HadithBloc>().add(GetHadithsByTagEvent(tag: category));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _CategoryHadithsPage(category: category),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookmarksTab() {
    // Load bookmarked hadiths when tab is selected
    context.read<HadithBloc>().add(const GetBookmarkedHadithsEvent());

    return BlocBuilder<HadithBloc, HadithState>(
      builder: (context, state) {
        if (state is HadithLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookmarkedHadithsLoaded) {
          final hadiths = state.hadiths;

          if (hadiths.isEmpty) {
            return Center(
              child: Text(context.tr.translate('hadith.noBookmarkedHadiths')),
            );
          }

          return ListView.builder(
            itemCount: hadiths.length,
            itemBuilder: (context, index) {
              final hadith = hadiths[index];
              return HadithListItem(
                hadith: hadith,
                onTap: () => _navigateToHadithDetail(hadith),
                onBookmarkToggle: () => _toggleBookmark(hadith.id),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _navigateToHadithDetail(Hadith hadith) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HadithDetailPage(hadith: hadith)),
    );
  }

  void _toggleBookmark(String hadithId) {
    context.read<HadithBloc>().add(ToggleHadithBookmarkEvent(id: hadithId));
  }
}

/// Page displaying hadiths filtered by category
class _CategoryHadithsPage extends StatelessWidget {
  final String category;

  const _CategoryHadithsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.tr.translate('hadith.categories')}: $category'),
      ),
      body: BlocBuilder<HadithBloc, HadithState>(
        builder: (context, state) {
          if (state is HadithLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HadithsByTagLoaded && state.tag == category) {
            final hadiths = state.hadiths;

            if (hadiths.isEmpty) {
              return Center(
                child: Text(
                  '${context.tr.translate('hadith.noHadithsFound')} - $category',
                ),
              );
            }

            return ListView.builder(
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                return HadithListItem(
                  hadith: hadith,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HadithDetailPage(hadith: hadith),
                      ),
                    );
                  },
                  onBookmarkToggle: () {
                    context.read<HadithBloc>().add(
                      ToggleHadithBookmarkEvent(id: hadith.id),
                    );
                  },
                );
              },
            );
          } else {
            // If we're not in the right state, request the data again
            context.read<HadithBloc>().add(GetHadithsByTagEvent(tag: category));
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
