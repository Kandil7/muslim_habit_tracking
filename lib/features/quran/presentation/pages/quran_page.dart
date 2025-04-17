import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/presentation/widgets/custom_app_bar.dart';
import 'package:muslim_habbit/core/presentation/widgets/error_message.dart';
import 'package:muslim_habbit/core/presentation/widgets/loading_indicator.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../widgets/quran_list_view.dart';
import '../widgets/quran_search_bar.dart';
import '../widgets/quran_tabs.dart';

/// Page for displaying the Quran feature
class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Check if we need to switch to a specific tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        final initialTab = args['initialTab'];
        if (initialTab != null && initialTab is int) {
          _tabController.animateTo(initialTab);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<QuranBloc>()..add(const LoadSurahs()),
      child: Scaffold(
        appBar: customAppBar(context.tr.translate('quran.title')),
        body: Column(
          children: [
            // Search bar
            QuranSearchBar(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),

            // Tabs
            QuranTabs(tabController: _tabController),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Surah tab
                  _buildSurahTab(),

                  // Bookmarks tab
                  _buildBookmarksTab(),

                  // History tab
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahTab() {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state is QuranLoading) {
          return const LoadingIndicator();
        } else if (state is SurahsLoaded) {
          final filteredSurahs =
              state.surahs.where((surah) {
                if (_searchQuery.isEmpty) return true;
                return surah.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    surah.arabicName.contains(_searchQuery) ||
                    surah.englishName.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );
              }).toList();

          return QuranListView(surahs: filteredSurahs);
        } else if (state is QuranError) {
          return ErrorMessage(
            message: state.message,
            onRetry: () {
              context.read<QuranBloc>().add(const LoadSurahs());
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookmarksTab() {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        // Load bookmarks when tab is selected
        if (_tabController.index == 1 &&
            state is! BookmarksLoaded &&
            state is! QuranLoading) {
          context.read<QuranBloc>().add(const LoadBookmarks());
        }

        if (state is QuranLoading) {
          return const LoadingIndicator();
        } else if (state is BookmarksLoaded) {
          if (state.bookmarks.isEmpty) {
            return Center(
              child: Text(
                context.tr.translate('quran.noBookmarks'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // TODO: Implement bookmarks list view
          return const Center(child: Text('Bookmarks coming soon!'));
        } else if (state is QuranError) {
          return ErrorMessage(
            message: state.message,
            onRetry: () {
              context.read<QuranBloc>().add(const LoadBookmarks());
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHistoryTab() {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        // Load reading history when tab is selected
        if (_tabController.index == 2 &&
            state is! ReadingHistoryLoaded &&
            state is! QuranLoading) {
          context.read<QuranBloc>().add(const LoadReadingHistory());
        }

        if (state is QuranLoading) {
          return const LoadingIndicator();
        } else if (state is ReadingHistoryLoaded) {
          if (state.history.isEmpty) {
            return Center(
              child: Text(
                context.tr.translate('quran.noHistory'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // TODO: Implement reading history list view
          return const Center(child: Text('Reading history coming soon!'));
        } else if (state is QuranError) {
          return ErrorMessage(
            message: state.message,
            onRetry: () {
              context.read<QuranBloc>().add(const LoadReadingHistory());
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
