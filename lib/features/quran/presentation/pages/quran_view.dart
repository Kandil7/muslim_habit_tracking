import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';
import 'quran_bookmarks_page.dart';
import 'quran_reading_history_page.dart';
import 'quran_search_page.dart';
import 'widgets/quran_view_body.dart';

/// Main page for the Quran feature
class QuranView extends StatelessWidget {
  /// Constructor
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a new BlocProvider to avoid issues with the parent BLoC being closed
    return BlocProvider(
      create:
          (context) =>
              context.read<QuranBloc>()..add(const GetLastReadPositionEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuranSearchPage(),
                  ),
                );
              },
              tooltip: 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuranBookmarksPage(),
                  ),
                );
              },
              tooltip: 'Bookmarks',
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuranReadingHistoryPage(),
                  ),
                );
              },
              tooltip: 'Reading History',
            ),
          ],
        ),
        body: const QuranViewBody(),
        floatingActionButton: BlocBuilder<QuranBloc, QuranState>(
          buildWhen:
              (previous, current) =>
                  current is LastReadPositionLoaded ||
                  current is LastReadPositionUpdated,
          builder: (context, state) {
            if ((state is LastReadPositionLoaded &&
                    state.lastPosition != null) ||
                state is LastReadPositionUpdated) {
              final lastPosition =
                  state is LastReadPositionLoaded
                      ? state.lastPosition!
                      : (state as LastReadPositionUpdated).lastPosition;

              return FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SuraView(initialPage: lastPosition.pageNumber),
                    ),
                  );
                },
                label: const Text('Continue Reading'),
                icon: const Icon(Icons.book),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
