import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;
import 'package:quran_library/quran_library.dart' hide QuranState;

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
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
      create:
          (context) =>
              di.sl<QuranBloc>()
                ..add(const GetBookmarksEvent())
                // Initialize with 0-based index for PageController
                ..add(
                  InitQuranPageControllerEvent(initialPage: initialPage - 1),
                ),
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
                  (previous, current) => current is QuranPageControllerCreated,
              listener: (context, state) {
                // Do nothing, just ensure the controller is created
                debugPrint('Listener Controller called');
              },
              buildWhen:
                  (previous, current) =>
                      current is QuranPageControllerCreated ||
                      current is QuranInitial ||
                      current is QuranLoading,
              builder: (context, state) {
                if (state is QuranPageControllerCreated ||
                    (state is! QuranInitial && state is! QuranLoading)) {
                  return SuraViewBody(initialPage: initialPage);
                }
                return const Center(child: CircularProgressIndicator());
              },
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
