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
  static const minPage = 1;
  static const maxPage = 604;

  final int initialPage;

  const SuraView({super.key, required this.initialPage});

  int get _validPage => initialPage.clamp(minPage, maxPage);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createAndInitBloc(context),
      child: Scaffold(body: _buildBody(context)),
    );
  }

  QuranBloc _createAndInitBloc(BuildContext context) {
    final quranBloc =
        di.sl<QuranBloc>()
          ..add(const GetBookmarksEvent())
          ..add(InitQuranPageControllerEvent(initialPage: _validPage));

    quranBloc.currentPage = _validPage;
    _saveReadingHistory(quranBloc, _validPage);

    return quranBloc;
  }

  void _saveReadingHistory(QuranBloc bloc, int page) {
    final history = QuranReadingHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      pageNumber: page,
      timestamp: DateTime.now(),
    );
    bloc.add(UpdateLastReadPositionEvent(history: history));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          final currentPage = context.read<QuranBloc>().currentPage;
          return Text(
            'Page $currentPage',
            style: const TextStyle(fontSize: 16),
          );
        },
      ),
      actions: [_buildBookmarkButton(context)],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return BlocSelector<QuranBloc, QuranState, bool>(
      selector: (state) {
        if (state is! BookmarksLoaded) return false;
        final currentPage = context.read<QuranBloc>().currentPage;
        return state.bookmarks.any((b) => b.page == currentPage);
      },
      builder: (context, isBookmarked) {
        return IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.amber : null,
          ),
          onPressed: () => _handleBookmarkAction(context),
          tooltip: 'Bookmark',
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<QuranBloc, QuranState>(
      listenWhen:
          (previous, current) =>
              current is QuranPageControllerCreated ||
              current is QuranPageChanged,
      listener: (context, state) {
        if (state is QuranPageChanged && state.pageNumber != _validPage) {
          _saveReadingHistory(context.read<QuranBloc>(), state.pageNumber);
        }
      },
      child: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          return SuraViewBody(initialPage: initialPage);
        },
      ),
    );
  }

  void _handleBookmarkAction(BuildContext context) {
    final quranBloc = context.read<QuranBloc>();
    final currentPage = quranBloc.currentPage!.clamp(minPage, maxPage);
    final state = quranBloc.state;

    if (state is BookmarksLoaded) {
      final isBookmarked = state.bookmarks.any((b) => b.page == currentPage);

      if (isBookmarked) {
        final bookmark = state.bookmarks.firstWhere(
          (b) => b.page == currentPage,
        );
        _showRemoveBookmarkDialog(context, bookmark.id);
      } else {
        _showAddBookmarkDialog(context, currentPage);
      }
    } else {
      quranBloc.add(const GetBookmarksEvent());
      _showAddBookmarkDialog(context, currentPage);
    }
  }

  Future<void> _showAddBookmarkDialog(
    BuildContext context,
    int pageNumber,
  ) async {
    final quranBloc = context.read<QuranBloc>();
    final validPage = pageNumber.clamp(minPage, maxPage);

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AddBookmarkDialog(
            pageNumber: validPage,
            onBookmarkAdded: (bookmark) {
              quranBloc.add(AddBookmarkEvent(bookmark: bookmark));
            },
          ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bookmark added')));
      quranBloc.add(const GetBookmarksEvent());
    }
  }

  void _showRemoveBookmarkDialog(BuildContext context, int bookmarkId) {
    final quranBloc = context.read<QuranBloc>();

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
                  quranBloc.add(RemoveBookmarkEvent(id: bookmarkId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookmark removed')),
                  );
                  quranBloc.add(const GetBookmarksEvent());
                },
                child: const Text('REMOVE'),
              ),
            ],
          ),
    );
  }
}
