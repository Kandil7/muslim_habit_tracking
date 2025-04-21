import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../widgets/add_bookmark_dialog.dart';
import 'widgets/sura_view_body.dart';

/// Widget for displaying a Quran surah
class SuraView extends StatelessWidget {
  /// Initial page to display
  final int initialPage;

  /// Constructor
  const SuraView({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    // Ensure the page number is within valid range (1-604)
    final validPage = initialPage.clamp(1, 604);

    return BlocProvider(
      create: (context) {
        // Create the QuranBloc and initialize it
        final quranBloc =
            di.sl<QuranBloc>()
              ..add(const GetBookmarksEvent())
              // Initialize with the correct page index
              ..add(InitQuranPageControllerEvent(initialPage: validPage - 1));

        // Set the current page directly in the bloc
        quranBloc.currentPage = validPage;

        // Save reading history
        final timestamp = DateTime.now();
        final history = QuranReadingHistory(
          id: timestamp.millisecondsSinceEpoch,
          pageNumber: validPage,
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
              title: BlocBuilder<QuranBloc, QuranState>(
                buildWhen: (previous, current) => current is QuranPageChanged,
                builder: (context, state) {
                  if (state is QuranPageChanged) {
                    return Text(
                      'Page ${state.pageNumber}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }
                  return Text(
                    'Page $validPage',
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
                          (b) => b.page == validPage,
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
                    state.pageNumber != validPage) {
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
                return SuraViewBody(initialPage: validPage);
              },
            ),
          );
        },
      ),
    );
  }

  void _handleBookmarkAction(BuildContext context) async {
    // Ensure the page number is within valid range (1-604)
    final validPage = initialPage.clamp(1, 604);

    final quranBloc = context.read<QuranBloc>();
    final state = quranBloc.state;

    if (state is BookmarksLoaded) {
      final isBookmarked = state.bookmarks.any((b) => b.page == validPage);

      if (isBookmarked) {
        // Remove bookmark
        final bookmark = state.bookmarks.firstWhere((b) => b.page == validPage);
        _showRemoveBookmarkDialog(context, bookmark.id);
      } else {
        // Add bookmark
        _showAddBookmarkDialog(context, validPage);
      }
    } else {
      // If state is not BookmarksLoaded, load bookmarks first
      quranBloc.add(const GetBookmarksEvent());
      // Then show add dialog
      _showAddBookmarkDialog(context, validPage);
    }
  }

  void _showAddBookmarkDialog(BuildContext context, [int? pageNumber]) async {
    // Get the QuranBloc from the current context before showing the dialog
    final quranBloc = context.read<QuranBloc>();

    // Use the provided page number or fall back to initialPage
    final validPage = (pageNumber ?? initialPage).clamp(1, 604);

    // We'll just use the page number for now
    // In a real app, you would get the surah name and ayah number from the Quran library

    final result = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AddBookmarkDialog(
            pageNumber: validPage,
            // We'll pass null for surahName and ayahNumber for now
            onBookmarkAdded: (bookmark) {
              // Use the quranBloc instance we got from the parent context
              quranBloc.add(AddBookmarkEvent(bookmark: bookmark));
            },
          ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bookmark added')));

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
            title: const Text('Remove Bookmark'),
            content: const Text(
              'Are you sure you want to remove this bookmark?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  // Use the quranBloc instance we got from the parent context
                  quranBloc.add(RemoveBookmarkEvent(id: bookmarkId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookmark removed')),
                  );

                  // Refresh bookmarks using the quranBloc instance
                  quranBloc.add(const GetBookmarksEvent());
                },
                child: const Text('REMOVE'),
              ),
            ],
          ),
    );
  }
}
