import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as ql;

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page to search the Quran
class QuranSearchPage extends StatefulWidget {
  /// Constructor
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Use the QuranLibrary to search
    final quranLibrary = ql.QuranLibrary();
    
    // Search by surah name
    final surahResults = quranLibrary.getAllSurahs().where((surah) {
      final surahName = surah['name'].toString().toLowerCase();
      final englishName = surah['englishName'].toString().toLowerCase();
      final englishNameTranslation = surah['englishNameTranslation'].toString().toLowerCase();
      
      return surahName.contains(query.toLowerCase()) || 
             englishName.contains(query.toLowerCase()) ||
             englishNameTranslation.contains(query.toLowerCase());
    }).map((surah) => {
      'type': 'surah',
      'data': surah,
    }).toList();
    
    // Search by page number if the query is a number
    List<Map<String, dynamic>> pageResults = [];
    if (int.tryParse(query) != null) {
      final pageNumber = int.parse(query);
      if (pageNumber >= 1 && pageNumber <= 604) {
        pageResults = [{
          'type': 'page',
          'data': {'number': pageNumber},
        }];
      }
    }
    
    setState(() {
      _searchResults = [...surahResults, ...pageResults];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search Quran',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: Theme.of(context).textTheme.titleMedium,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _performSearch(value);
          },
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _searchResults = [];
                });
              },
            ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty && _searchQuery.isNotEmpty
              ? _buildNoResults()
              : _buildSearchResults(),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$_searchQuery"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return _buildSearchSuggestions();
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        
        if (result['type'] == 'surah') {
          return _buildSurahResult(result['data']);
        } else if (result['type'] == 'page') {
          return _buildPageResult(result['data']);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSurahResult(Map<dynamic, dynamic> surah) {
    final surahNumber = surah['number'] as int;
    final englishName = surah['englishName'] as String;
    final englishNameTranslation = surah['englishNameTranslation'] as String;
    final numberOfAyahs = surah['numberOfAyahs'] as int;
    
    // Get the starting page for this surah
    final startPage = ql.QuranLibrary().getSurahStartPage(surahNumber: surahNumber);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            surahNumber.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(englishName),
        subtitle: Text('$englishNameTranslation • $numberOfAyahs verses'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigation.push(
            context,
            SuraView(initialPage: startPage),
          );
        },
      ),
    );
  }

  Widget _buildPageResult(Map<dynamic, dynamic> page) {
    final pageNumber = page['number'] as int;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Icon(Icons.book, color: Colors.white),
        ),
        title: Text('Page $pageNumber'),
        subtitle: const Text('Go to this page in the Quran'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigation.push(
            context,
            SuraView(initialPage: pageNumber),
          );
        },
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Suggestions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            icon: Icons.numbers,
            title: 'Search by Page Number',
            subtitle: 'Enter a page number (1-604)',
            onTap: () {
              _searchController.text = '1';
              _performSearch('1');
            },
          ),
          const SizedBox(height: 8),
          _buildSuggestionItem(
            icon: Icons.menu_book,
            title: 'Search by Surah Name',
            subtitle: 'Enter a surah name (e.g., "Baqarah")',
            onTap: () {
              _searchController.text = 'Baqarah';
              _performSearch('Baqarah');
            },
          ),
          const SizedBox(height: 8),
          _buildSuggestionItem(
            icon: Icons.translate,
            title: 'Search by English Translation',
            subtitle: 'Enter a translation (e.g., "The Cow")',
            onTap: () {
              _searchController.text = 'The Cow';
              _performSearch('The Cow');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
