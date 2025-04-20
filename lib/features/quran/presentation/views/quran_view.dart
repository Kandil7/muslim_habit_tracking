import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/utils/navigation.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_bookmarks_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_reading_history_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_search_page.dart';

import 'widgets/quran_view_body.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('quran.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigation.push(context, const QuranSearchPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Bookmarks',
            onPressed: () {
              Navigation.push(context, const QuranBookmarksPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Reading History',
            onPressed: () {
              Navigation.push(context, const QuranReadingHistoryPage());
            },
          ),
        ],
      ),
      body: const QuranViewBody(),
    );
  }
}
