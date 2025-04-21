import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/utils/navigation.dart';
import 'package:quran_library/quran_library.dart' hide QuranState;

import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../pages/quran_bookmarks_page.dart';
import '../pages/quran_reading_history_page.dart';
import '../pages/quran_search_page.dart';
import '../widgets/add_bookmark_dialog.dart';
import 'widgets/sura_view_body.dart';

class SuraView extends StatelessWidget {
  const SuraView({super.key, required this.initialPage});
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    // Set the current page in QuranCtrl immediately
    QuranCtrl.instance.state.currentPageNumber.value = initialPage;

    return BlocProvider(
      create: (context) {
        final quranBloc =
            di.sl<QuranBloc>()
              ..add(const GetBookmarksEvent())
              // Initialize with 0-based index for PageController
              ..add(InitQuranPageControllerEvent(initialPage: initialPage - 1));

        // Save reading history
        final timestamp = DateTime.now();
        final history = QuranReadingHistory(
          id: timestamp.millisecondsSinceEpoch,
          pageNumber: initialPage,
          timestamp: timestamp,
        );
        quranBloc.add(UpdateLastReadPositionEvent(history: history));

        return quranBloc;
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: BlocBuilder<QuranBloc, QuranState>(
                buildWhen: (previous, current) => current is QuranPageChanged,
                builder: (context, state) {
                  if (state is QuranPageChanged) {
                    return Text(
                      '${context.tr.translate('quran.page')} ${state.pageNumber}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }
                  return Text(
                    '${context.tr.translate('quran.page')} $initialPage',
                    style: const TextStyle(fontSize: 16),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: BlocBuilder<QuranBloc, QuranState>(
                    buildWhen:
                        (previous, current) => current is BookmarksLoaded,
                    builder: (context, state) {
                      if (state is BookmarksLoaded) {
                        final isBookmarked = state.bookmarks.any(
                          (b) => b.page == initialPage,
                        );
                        return Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : null,
                        );
                      }
                      return const Icon(Icons.bookmark_border);
                    },
                  ),
                  onPressed: () => _handleBookmarkAction(context),
                  tooltip: 'Bookmark',
                ),
              ],
            ),
            body: BlocConsumer<QuranBloc, QuranState>(
              listenWhen:
                  (previous, current) =>
                      current is QuranPageControllerCreated ||
                      current is QuranPageChanged,
              listener: (context, state) {
                // When page changes, update reading history
                if (state is QuranPageChanged &&
                    state.pageNumber != initialPage) {
                  final timestamp = DateTime.now();
                  final history = QuranReadingHistory(
                    id: timestamp.millisecondsSinceEpoch,
                    pageNumber: state.pageNumber,
                    timestamp: timestamp,
                  );
                  context.read<QuranBloc>().add(
                    UpdateLastReadPositionEvent(history: history),
                  );
                }
              },
              buildWhen:
                  (previous, current) =>
                      current is QuranPageControllerCreated ||
                      current is QuranInitial,
              builder: (context, state) {
                // Only show loading indicator when we're in the initial state
                // and haven't created the page controller yet
                if (state is QuranInitial) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // In all other cases, show the SuraViewBody
                return SuraViewBody(initialPage: initialPage);
              },
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: context.tr.translate('quran.search'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigation.push(context, const QuranSearchPage());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark),
                      tooltip: context.tr.translate('quran.bookmarks'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigation.push(context, const QuranBookmarksPage());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      tooltip: context.tr.translate('quran.history'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigation.push(
                          context,
                          const QuranReadingHistoryPage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleBookmarkAction(BuildContext context) async {
    final quranBloc = context.read<QuranBloc>();
    final state = quranBloc.state;

    if (state is BookmarksLoaded) {
      final isBookmarked = state.bookmarks.any((b) => b.page == initialPage);

      if (isBookmarked) {
        // Remove bookmark
        final bookmark = state.bookmarks.firstWhere(
          (b) => b.page == initialPage,
        );
        _showRemoveBookmarkDialog(context, bookmark.id);
      } else {
        // Add bookmark
        _showAddBookmarkDialog(context);
      }
    } else {
      // If state is not BookmarksLoaded, load bookmarks first
      quranBloc.add(const GetBookmarksEvent());
      // Then show add dialog
      _showAddBookmarkDialog(context);
    }
  }

  void _showAddBookmarkDialog(BuildContext context) async {
    // Get the QuranBloc from the current context before showing the dialog
    final quranBloc = context.read<QuranBloc>();

    // We'll just use the page number for now
    // In a real app, you would get the surah name and ayah number from the Quran library

    final result = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AddBookmarkDialog(
            pageNumber: initialPage,
            // We'll pass null for surahName and ayahNumber for now
            onBookmarkAdded: (bookmark) {
              // Use the quranBloc instance we got from the parent context
              quranBloc.add(AddBookmarkEvent(bookmark: bookmark));
            },
          ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.translate('quran.bookmarkAdded'))),
      );

      // Refresh bookmarks using the quranBloc instance
      quranBloc.add(const GetBookmarksEvent());
    }
  }

  void _showRemoveBookmarkDialog(BuildContext context, int bookmarkId) {
    // Get the QuranBloc from the current context before showing the dialog
    final quranBloc = context.read<QuranBloc>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr.translate('quran.bookmark')),
            content: Text(context.tr.translate('quran.bookmarkRemoved')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  context.tr.translate('common.cancel').toUpperCase(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  // Use the quranBloc instance we got from the parent context
                  quranBloc.add(RemoveBookmarkEvent(id: bookmarkId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.tr.translate('quran.bookmarkRemoved'),
                      ),
                    ),
                  );

                  // Refresh bookmarks using the quranBloc instance
                  quranBloc.add(const GetBookmarksEvent());
                },
                child: Text(
                  context.tr.translate('common.delete').toUpperCase(),
                ),
              ),
            ],
          ),
    );
  }
}
