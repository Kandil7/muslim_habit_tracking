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

    // Use the QuranCtrl search method
    final results = _quranCtrl.search(query);

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.translate('quran.search'))),
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
                        return ListTile(
                          title: Text(
                            ayah.text,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 18,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Text(
                            'Surah ${ayah.surahNumber} - Ayah ${ayah.ayahNumber} - Page ${ayah.page}',
                          ),
                          onTap: () {
                            Navigation.push(
                              context,
                              SuraView(initialPage: ayah.page),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
