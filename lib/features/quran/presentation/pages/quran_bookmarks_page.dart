import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page for displaying Quran bookmarks
class QuranBookmarksPage extends StatefulWidget {
  /// Constructor
  const QuranBookmarksPage({super.key});

  @override
  State<QuranBookmarksPage> createState() => _QuranBookmarksPageState();
}

class _QuranBookmarksPageState extends State<QuranBookmarksPage> {
  @override
  void initState() {
    super.initState();
    // Trigger loading of bookmarks in initState instead of build
    _loadBookmarks();
  }

  void _loadBookmarks() {
    // Safely add the event with error handling
    try {
      context.read<QuranBloc>().add(const GetBookmarksEvent());
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('quran.bookmarks')),
        actions: [
          // Sort button
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: context.tr.translate('quran.sortBy'),
            onSelected: (value) {
              // Implement sorting logic here
              // For now, we'll just show a snackbar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sorting by $value')));
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'date',
                    child: Text(context.tr.translate('quran.sortByDateAdded')),
                  ),
                  PopupMenuItem(
                    value: 'page',
                    child: Text(context.tr.translate('quran.sortByPageNumber')),
                  ),
                  PopupMenuItem(
                    value: 'title',
                    child: Text(context.tr.translate('quran.sortByName')),
                  ),
                ],
          ),
        ],
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuranError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading bookmarks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        context.read<QuranBloc>().add(
                          const GetBookmarksEvent(),
                        );
                      } catch (e) {
                        debugPrint('Error reloading bookmarks: $e');
                      }
                    },
                    child: Text(context.tr.translate('common.retry')),
                  ),
                ],
              ),
            );
          } else if (state is BookmarksLoaded) {
            final bookmarks = state.bookmarks;
            if (bookmarks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.tr.translate('quran.noBookmarks'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add bookmarks while reading to save your favorite pages',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
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
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // Show confirmation dialog
                    return await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Remove Bookmark'),
                                content: Text(
                                  'Are you sure you want to remove this bookmark?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: Text(
                                      context.tr.translate('common.cancel'),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: Text(
                                      context.tr.translate('common.delete'),
                                    ),
                                  ),
                                ],
                              ),
                        ) ??
                        false;
                  },
                  onDismissed: (direction) {
                    try {
                      context.read<QuranBloc>().add(
                        RemoveBookmarkEvent(id: bookmark.id),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr.translate('quran.bookmarkRemoved'),
                            ),
                            action: SnackBarAction(
                              label: context.tr.translate('common.undo'),
                              onPressed: () {
                                // Re-add the bookmark
                                try {
                                  context.read<QuranBloc>().add(
                                    AddBookmarkEvent(bookmark: bookmark),
                                  );
                                } catch (e) {
                                  debugPrint('Error re-adding bookmark: $e');
                                }
                              },
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint('Error removing bookmark: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error removing bookmark')),
                        );
                      }
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigation.push(
                          context,
                          SuraView(initialPage: bookmark.page),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: AppColors.secondary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    bookmark.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withAlpha(50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${context.tr.translate('quran.page')} ${bookmark.page}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (bookmark.surahName != null)
                              Text(
                                bookmark.surahName!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().add_jm().format(
                                bookmark.timestamp,
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withAlpha(150),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // If we're not in a loading or loaded state, trigger loading
            try {
              context.read<QuranBloc>().add(const GetBookmarksEvent());
            } catch (e) {
              debugPrint('Error loading bookmarks: $e');
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Quran view to add bookmarks
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SuraView(initialPage: 1),
            ),
          );
        },
        tooltip: 'Add Bookmark',
        child: const Icon(Icons.add),
      ),
    );
  }
}
