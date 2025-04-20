import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_bookmarks_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_reading_history_page.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_search_page.dart';
import 'package:muslim_habbit/features/quran/presentation/views/quran_view.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import 'dashboard_card.dart';

/// Card widget for Quran reading
class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Quran',
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
          Container(
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
                      const Text(
                        'Continue Reading',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Surah Al-Baqarah',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        'Verse 255 (Ayatul Kursi)',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                context,
                icon: Icons.search,
                label: 'Search',
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
                label: 'Bookmarks',
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
                label: 'History',
                onTap: () {
                  // Navigate to Quran reading history page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranReadingHistoryPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
