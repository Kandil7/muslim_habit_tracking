import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/navigation.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page for displaying Quran bookmarks
class QuranBookmarksPage extends StatelessWidget {
  /// Constructor
  const QuranBookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookmarksLoaded) {
            final bookmarks = state.bookmarks;
            if (bookmarks.isEmpty) {
              return const Center(
                child: Text('No bookmarks yet'),
              );
            }
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return Dismissible(
                  key: Key('bookmark_${bookmark.id}'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context
                        .read<QuranBloc>()
                        .add(RemoveBookmarkEvent(id: bookmark.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookmark removed')),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(bookmark.title),
                    subtitle: Text(
                      'Page ${bookmark.page} • ${DateFormat.yMMMd().format(bookmark.timestamp)}',
                    ),
                    onTap: () {
                      Navigation.push(
                        context,
                        SuraView(initialPage: bookmark.page),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            // If we're not in a loading or loaded state, trigger loading
            context.read<QuranBloc>().add(const GetBookmarksEvent());
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
