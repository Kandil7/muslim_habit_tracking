import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/quran/presentation/pages/quran_page.dart';
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
          MaterialPageRoute(builder: (context) => const QuranPage()),
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
                  AppColors.secondary.withOpacity(0.7),
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
                    color: Colors.white.withOpacity(0.2),
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
                          color: Colors.white.withOpacity(0.8),
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
                  // Navigate to Quran page with search tab
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuranPage()),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.bookmark,
                label: 'Bookmarks',
                onTap: () {
                  // Navigate to Quran page with bookmarks tab
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranPage(),
                      settings: const RouteSettings(
                        arguments: {'initialTab': 1},
                      ),
                    ),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.history,
                label: 'History',
                onTap: () {
                  // Navigate to Quran page with history tab
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranPage(),
                      settings: const RouteSettings(
                        arguments: {'initialTab': 2},
                      ),
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
