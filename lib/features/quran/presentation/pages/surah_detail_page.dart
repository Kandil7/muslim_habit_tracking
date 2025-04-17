import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/presentation/widgets/custom_app_bar.dart';
import 'package:muslim_habbit/core/presentation/widgets/error_message.dart';
import 'package:muslim_habbit/core/presentation/widgets/loading_indicator.dart';
import 'package:quran_library/quran_library.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/bookmark.dart';
import '../../domain/entities/reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../widgets/surah_actions_bar.dart';

/// Page for displaying a Quran surah
class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final int initialPage;

  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.initialPage,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isBookmarked = false;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage - 1);
    _currentPage = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<QuranBloc>()
        ..add(LoadSurah(surahId: widget.surahId))
        ..add(const LoadBookmarks()),
      child: BlocConsumer<QuranBloc, QuranState>(
        listener: (context, state) {
          if (state is BookmarksLoaded) {
            // Check if current page is bookmarked
            final isBookmarked = state.bookmarks.any((bookmark) => 
              bookmark.surahId == widget.surahId && bookmark.page == _currentPage);
            setState(() {
              _isBookmarked = isBookmarked;
            });
          } else if (state is BookmarkAdded) {
            setState(() {
              _isBookmarked = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.translate('quran.bookmarkAdded')),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is BookmarkRemoved) {
            setState(() {
              _isBookmarked = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.translate('quran.bookmarkRemoved')),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context, state),
            body: _buildBody(context, state),
            bottomNavigationBar: SurahActionsBar(
              isBookmarked: _isBookmarked,
              onBookmarkPressed: () => _toggleBookmark(context),
              onSharePressed: () => _shareSurah(context),
              onSettingsPressed: () => _openSettings(context),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, QuranState state) {
    String title = context.tr.translate('quran.surah');
    
    if (state is SurahLoaded) {
      title = context.isRtl
          ? "سورة ${state.surah.arabicName}"
          : "Surah ${state.surah.englishName}";
    }
    
    return customAppBar(title);
  }

  Widget _buildBody(BuildContext context, QuranState state) {
    if (state is QuranLoading) {
      return const LoadingIndicator();
    } else if (state is SurahLoaded) {
      return Stack(
        children: [
          QuranLibraryScreen(
            useDefaultAppBar: false,
            backgroundColor: const Color(0xffFEFFDD),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index + 1;
              });
              
              // Update reading history
              _updateReadingHistory(context, state.surah, index + 1);
            },
          ),
        ],
      );
    } else if (state is QuranError) {
      return ErrorMessage(
        message: state.message,
        onRetry: () {
          context.read<QuranBloc>().add(LoadSurah(surahId: widget.surahId));
        },
      );
    }
    
    return const SizedBox.shrink();
  }

  void _toggleBookmark(BuildContext context) {
    if (_isBookmarked) {
      // Find the bookmark ID and remove it
      context.read<QuranBloc>().add(const LoadBookmarks());
      final state = context.read<QuranBloc>().state;
      if (state is BookmarksLoaded) {
        final bookmark = state.bookmarks.firstWhere(
          (bookmark) => bookmark.surahId == widget.surahId && bookmark.page == _currentPage,
          orElse: () => const QuranBookmark(
            id: '',
            surahId: 0,
            ayahNumber: 0,
            page: 0,
            surahName: '',
            arabicSurahName: '',
            timestamp: null,
          ),
        );
        
        if (bookmark.id.isNotEmpty) {
          context.read<QuranBloc>().add(RemoveBookmarkEvent(bookmarkId: bookmark.id));
        }
      }
    } else {
      // Add a new bookmark
      final state = context.read<QuranBloc>().state;
      if (state is SurahLoaded) {
        final bookmark = QuranBookmark(
          id: _uuid.v4(),
          surahId: widget.surahId,
          ayahNumber: 1, // Default to first ayah
          page: _currentPage,
          surahName: state.surah.englishName,
          arabicSurahName: state.surah.arabicName,
          timestamp: DateTime.now(),
        );
        
        context.read<QuranBloc>().add(AddBookmarkEvent(bookmark: bookmark));
      }
    }
  }

  void _shareSurah(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr.translate('quran.shareComingSoon')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    // TODO: Implement settings functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr.translate('quran.settingsComingSoon')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateReadingHistory(BuildContext context, Quran surah, int page) {
    final history = QuranReadingHistory(
      id: _uuid.v4(),
      surahId: surah.id,
      ayahNumber: 1, // Default to first ayah
      page: page,
      surahName: surah.englishName,
      arabicSurahName: surah.arabicName,
      timestamp: DateTime.now(),
    );
    
    // Update last read position
    context.read<QuranBloc>().add(UpdateLastReadPosition(history: history));
    
    // Add to reading history
    context.read<QuranBloc>().add(AddReadingHistoryEvent(history: history));
  }
}
