import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as ql;

import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page to display Quran bookmarks
class QuranBookmarksPage extends StatelessWidget {
  /// Constructor
  const QuranBookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranBloc>()..add(const GetBookmarksEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
          actions: [
            BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                if (state is BookmarksLoaded && state.bookmarks.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.sort),
                    tooltip: 'Sort bookmarks',
                    onPressed: () {
                      _showSortOptions(context);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookmarksLoaded) {
              return _buildBookmarksList(context, state.bookmarks);
            } else if (state is QuranError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No bookmarks found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildBookmarksList(
    BuildContext context,
    List<QuranBookmark> bookmarks,
  ) {
    if (bookmarks.isEmpty) {
      return EmptyState(
        title: 'No Bookmarks Yet',
        message:
            'Add bookmarks while reading the Quran to save your favorite verses',
        icon: Icons.bookmark_border,
        actionText: 'Go to Quran',
        onAction: () => Navigator.pop(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Dismissible(
            key: Key(bookmark.id.toString()),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              context.read<QuranBloc>().add(
                RemoveBookmarkEvent(id: bookmark.id),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Bookmark removed'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      // Re-add the bookmark
                      // This would require storing the removed bookmark temporarily
                      // and implementing an undo feature in the bloc
                    },
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(bookmark.colorCode),
                  child: Text(
                    bookmark.surahName?.substring(0, 1) ?? 'Q',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  bookmark.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  bookmark.surahName != null
                      ? 'Surah ${bookmark.surahName}, Page ${bookmark.page}'
                      : 'Page ${bookmark.page}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to the Quran page
                  if (bookmark.page != null) {
                    // Navigate to the specific page in the Quran
                    ql.QuranCtrl.instance.state.currentPageNumber.value =
                        bookmark.page!;

                    // Navigate to the SuraView with the page number
                    Navigation.push(
                      context,
                      SuraView(initialPage: bookmark.page!),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by Name'),
                leading: const Icon(Icons.sort_by_alpha),
                onTap: () {
                  // Implement sorting by name
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Date Added'),
                leading: const Icon(Icons.access_time),
                onTap: () {
                  // Implement sorting by date
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Surah'),
                leading: const Icon(Icons.menu_book),
                onTap: () {
                  // Implement sorting by surah
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
