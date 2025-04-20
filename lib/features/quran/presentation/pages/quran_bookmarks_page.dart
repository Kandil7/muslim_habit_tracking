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
import '../widgets/bookmark_filter_chip.dart';

/// Page to display Quran bookmarks
class QuranBookmarksPage extends StatefulWidget {
  /// Constructor
  const QuranBookmarksPage({super.key});

  @override
  State<QuranBookmarksPage> createState() => _QuranBookmarksPageState();
}

/// Sort options for bookmarks
enum BookmarkSortOption {
  /// Sort by name
  name,

  /// Sort by date added (id)
  dateAdded,

  /// Sort by surah
  surah,

  /// Sort by page number
  page,
}

class _QuranBookmarksPageState extends State<QuranBookmarksPage> {
  BookmarkSortOption _sortOption = BookmarkSortOption.dateAdded;
  String? _filterSurah;
  bool _showFilters = false;

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
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        tooltip: 'Filter bookmarks',
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        tooltip: 'Sort bookmarks',
                        onPressed: () {
                          _showSortOptions(context);
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Filter chips
            if (_showFilters)
              BlocBuilder<QuranBloc, QuranState>(
                builder: (context, state) {
                  if (state is BookmarksLoaded && state.bookmarks.isNotEmpty) {
                    // Get unique surah names
                    final surahNames =
                        state.bookmarks
                            .map((b) => b.surahName)
                            .where((name) => name != null)
                            .toSet()
                            .cast<String>();

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Filter by Surah',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                BookmarkFilterChip(
                                  label: 'All',
                                  icon: Icons.book,
                                  isSelected: _filterSurah == null,
                                  onTap: () {
                                    setState(() {
                                      _filterSurah = null;
                                    });
                                  },
                                ),
                                ...surahNames.map(
                                  (name) => BookmarkFilterChip(
                                    label: name,
                                    icon: Icons.bookmark,
                                    isSelected: _filterSurah == name,
                                    onTap: () {
                                      setState(() {
                                        _filterSurah = name;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Bookmarks list
            Expanded(
              child: BlocBuilder<QuranBloc, QuranState>(
                builder: (context, state) {
                  if (state is QuranLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookmarksLoaded) {
                    // Apply filtering
                    var filteredBookmarks = state.bookmarks;
                    if (_filterSurah != null) {
                      filteredBookmarks =
                          filteredBookmarks
                              .where((b) => b.surahName == _filterSurah)
                              .toList();
                    }

                    // Apply sorting
                    filteredBookmarks = _sortBookmarks(filteredBookmarks);

                    return _buildBookmarksList(context, filteredBookmarks);
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
          ],
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

  /// Sort bookmarks based on the current sort option
  List<QuranBookmark> _sortBookmarks(List<QuranBookmark> bookmarks) {
    final sortedBookmarks = List<QuranBookmark>.from(bookmarks);

    switch (_sortOption) {
      case BookmarkSortOption.name:
        sortedBookmarks.sort((a, b) => a.name.compareTo(b.name));
        break;
      case BookmarkSortOption.dateAdded:
        // Sort by ID (assuming higher ID means more recent)
        sortedBookmarks.sort((a, b) => b.id.compareTo(a.id));
        break;
      case BookmarkSortOption.surah:
        // Sort by surah name, handling nulls
        sortedBookmarks.sort((a, b) {
          if (a.surahName == null && b.surahName == null) return 0;
          if (a.surahName == null) return 1;
          if (b.surahName == null) return -1;
          return a.surahName!.compareTo(b.surahName!);
        });
        break;
      case BookmarkSortOption.page:
        // Sort by page number, handling nulls
        sortedBookmarks.sort((a, b) {
          if (a.page == null && b.page == null) return 0;
          if (a.page == null) return 1;
          if (b.page == null) return -1;
          return a.page!.compareTo(b.page!);
        });
        break;
    }

    return sortedBookmarks;
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sort Bookmarks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Sort by Name'),
                leading: const Icon(Icons.sort_by_alpha),
                trailing:
                    _sortOption == BookmarkSortOption.name
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _sortOption = BookmarkSortOption.name;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Date Added'),
                leading: const Icon(Icons.access_time),
                trailing:
                    _sortOption == BookmarkSortOption.dateAdded
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _sortOption = BookmarkSortOption.dateAdded;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Surah'),
                leading: const Icon(Icons.menu_book),
                trailing:
                    _sortOption == BookmarkSortOption.surah
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _sortOption = BookmarkSortOption.surah;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Page Number'),
                leading: const Icon(Icons.numbers),
                trailing:
                    _sortOption == BookmarkSortOption.page
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _sortOption = BookmarkSortOption.page;
                  });
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
