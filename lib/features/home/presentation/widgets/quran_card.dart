import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_bookmarks_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_reading_history_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_search_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_view.dart';
import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../../features/quran/presentation/bloc/quran_bloc.dart';
import '../../../../features/quran/presentation/bloc/quran_event.dart';
import '../../../../features/quran/presentation/bloc/quran_state.dart';
import '../../../../features/quran/presentation/views/sura_view.dart';
import 'dashboard_card.dart';

/// Card widget for Quran reading
class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Get the QuranBloc instance
        final quranBloc = context.read<QuranBloc>();

        // Safely add the event with error handling
        try {
          quranBloc.add(const GetLastReadPositionEvent());
        } catch (e) {
          debugPrint('Error getting last read position: $e');
        }

        return quranBloc;
      },
      child: BlocBuilder<QuranBloc, QuranState>(
        buildWhen:
            (previous, current) =>
                current is LastReadPositionLoaded ||
                current is LastReadPositionUpdated,
        builder: (context, state) {
          return DashboardCard(
            title: context.tr.translate('quran.title'),
            icon: Icons.menu_book,
            iconColor: AppColors.secondary,
            onTap: () {
              // Navigate to Quran page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuranView()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (state is LastReadPositionLoaded &&
                        state.lastPosition != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SuraView(
                                initialPage: state.lastPosition!.pageNumber,
                              ),
                        ),
                      );
                    } else if (state is LastReadPositionUpdated) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SuraView(
                                initialPage: state.lastPosition.pageNumber,
                              ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuranView(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 179),
                          AppColors.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Icon(
                            Icons.menu_book,
                            size: 60,
                            color: Colors.white.withValues(alpha: 51),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                context.tr.translate('quran.continue'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (state is LastReadPositionLoaded &&
                                  state.lastPosition != null)
                                Text(
                                  '${context.tr.translate('quran.page')} ${state.lastPosition!.pageNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                )
                              else if (state is LastReadPositionUpdated)
                                Text(
                                  '${context.tr.translate('quran.page')} ${state.lastPosition.pageNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                )
                              else
                                Text(
                                  context.tr.translate('quran.startReading'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              Text(
                                context.tr.translate('quran.continueReading'),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 204),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(
                      context,
                      icon: Icons.search,
                      label: context.tr.translate('quran.search'),
                      onTap: () {
                        // Navigate to Quran search page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuranSearchPage(),
                          ),
                        );
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.bookmark,
                      label: context.tr.translate('quran.bookmarks'),
                      onTap: () {
                        // Navigate to Quran bookmarks page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuranBookmarksPage(),
                          ),
                        );
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.history,
                      label: context.tr.translate('quran.history'),
                      onTap: () {
                        // Navigate to Quran reading history page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const QuranReadingHistoryPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
