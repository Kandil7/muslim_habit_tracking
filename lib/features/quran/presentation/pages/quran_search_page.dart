import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';

import '../../../../core/localization/app_localizations_extension.dart';

import '../../../../core/utils/navigation.dart';
import '../views/sura_view.dart';

/// Page for searching the Quran
class QuranSearchPage extends StatefulWidget {
  /// Constructor
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final _searchController = TextEditingController();
  final _quranCtrl = QuranCtrl.instance;
  List<AyahModel> _searchResults = [];
  bool _isSearching = false;

  // Search filters
  String _searchType = 'text'; // 'text' or 'surah'
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _quranCtrl.loadQuran();
  }

  @override
  void dispose() {
    _searchController.dispose();
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

    List<AyahModel> results = [];

    if (_searchType == 'text') {
      // Search by ayah text
      results = _quranCtrl.search(query);
    } else if (_searchType == 'surah') {
      // Search by surah name
      try {
        // Get all surahs
        final surahs = QuranLibrary().getAllSurahs();

        // Find surahs that match the query
        final matchingSurahs =
            surahs.where((dynamic surah) {
              final surahName = surah['name'].toString();
              final englishName = surah['englishName'].toString();
              final translation = surah['englishNameTranslation'].toString();

              return surahName.contains(query) ||
                  englishName.toLowerCase().contains(query.toLowerCase()) ||
                  translation.toLowerCase().contains(query.toLowerCase());
            }).toList();

        // For each matching surah, add the first ayah to results
        for (final dynamic surah in matchingSurahs) {
          // Get first ayah of the surah by searching for the surah name
          final surahName = surah['name'].toString();
          final firstAyahResults = _quranCtrl.search(surahName);
          if (firstAyahResults.isNotEmpty) {
            results.add(firstAyahResults.first);
          }
        }
      } catch (e) {
        debugPrint('Error searching by surah: $e');
      }
    }

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('quran.search')),
        actions: [
          // Search type toggle
          IconButton(
            icon: Icon(
              _searchType == 'text' ? Icons.text_fields : Icons.menu_book,
            ),
            tooltip:
                _searchType == 'text'
                    ? 'Searching by text'
                    : 'Searching by surah',
            onPressed: () {
              setState(() {
                _searchType = _searchType == 'text' ? 'surah' : 'text';
                // Re-run search with new type
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              });

              // Show a snackbar to confirm the search type
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Searching by ${_searchType == 'text' ? 'ayah text' : 'surah name'}',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          // Translation toggle
          IconButton(
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.translate_outlined,
            ),
            tooltip: _showTranslation ? 'Hide translation' : 'Show translation',
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.tr.translate('quran.search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _performSearch,
            ),
          ),
          Expanded(
            child:
                _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? Center(
                      child:
                          _searchController.text.isEmpty
                              ? Text(
                                context.tr.translate('quran.enterSurahName'),
                              )
                              : Text(context.tr.translate('quran.noResults')),
                    )
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final ayah = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigation.push(
                                context,
                                SuraView(initialPage: ayah.page),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ayah.text,
                                    style: const TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 20,
                                      height: 1.5,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                  ),
                                  if (_showTranslation) ...[
                                    const SizedBox(height: 8),
                                    // Since QuranLibrary doesn't have a direct getTranslation method,
                                    // we'll display a simplified translation
                                    Text(
                                      'Surah ${ayah.surahNumber}, Ayah ${ayah.ayahNumber}',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${context.tr.translate('quran.surah')} ${ayah.surahNumber} - ${context.tr.translate('quran.ayah')} ${ayah.ayahNumber}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withAlpha(50),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${context.tr.translate('quran.page')} ${ayah.page}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
