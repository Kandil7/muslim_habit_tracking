import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quran_bookmark.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import 'add_bookmark_dialog.dart';

/// Button to add or remove a bookmark
class BookmarkButton extends StatelessWidget {
  /// The page number to bookmark
  final int pageNumber;

  /// The surah name (optional)
  final String? surahName;

  /// The ayah number (optional)
  final int? ayahNumber;

  /// The ayah ID (optional)
  final int? ayahId;

  /// Constructor
  const BookmarkButton({
    Key? key,
    required this.pageNumber,
    this.surahName,
    this.ayahNumber,
    this.ayahId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state is BookmarksLoaded) {
          final isBookmarked = state.bookmarks.any((b) => b.page == pageNumber);

          return IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
            ),
            onPressed: () {
              if (isBookmarked) {
                _removeBookmark(context, state.bookmarks);
              } else {
                _addBookmark(context);
              }
            },
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
          );
        }

        return IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () => _addBookmark(context),
          tooltip: 'Add Bookmark',
        );
      },
    );
  }

  void _addBookmark(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AddBookmarkDialog(
            pageNumber: pageNumber,
            surahName: surahName,
            ayahNumber: ayahNumber,
            ayahId: ayahId,
            onBookmarkAdded: (bookmark) {
              context.read<QuranBloc>().add(
                AddBookmarkEvent(bookmark: bookmark),
              );
            },
          ),
    );

    if (result == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bookmark added')));

        // Refresh bookmarks
        context.read<QuranBloc>().add(const GetBookmarksEvent());
      }
    }
  }

  void _removeBookmark(BuildContext context, List<QuranBookmark> bookmarks) {
    final bookmark = bookmarks.firstWhere((b) => b.page == pageNumber);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Bookmark'),
            content: const Text(
              'Are you sure you want to remove this bookmark?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<QuranBloc>().add(
                    RemoveBookmarkEvent(id: bookmark.id),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookmark removed')),
                  );
                },
                child: const Text('REMOVE'),
              ),
            ],
          ),
    );
  }
}
