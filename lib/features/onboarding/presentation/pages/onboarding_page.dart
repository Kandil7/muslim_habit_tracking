import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_theme.dart';

/// Onboarding page to introduce the app to new users
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to SunnahTrack',
      description:
          'Your companion for building and maintaining consistent Islamic practices.',
      image: 'assets/images/onboarding_welcome.png',
      backgroundColor: AppColors.primary,
    ),
    OnboardingItem(
      title: 'Track Your Habits',
      description:
          'Create and track your daily Islamic habits like prayers, Quran reading, and more.',
      image: 'assets/images/onboarding_habits.png',
      backgroundColor: AppColors.secondary,
    ),
    OnboardingItem(
      title: 'Prayer Times',
      description:
          'Get accurate prayer times based on your location and receive timely notifications.',
      image: 'assets/images/onboarding_prayer.png',
      backgroundColor: AppColors.primaryDark,
    ),
    OnboardingItem(
      title: 'Duas & Dhikr',
      description:
          'Access a collection of duas and dhikrs with a built-in counter to help you remember Allah.',
      image: 'assets/images/onboarding_dua.png',
      backgroundColor: AppColors.secondaryDark,
    ),
    OnboardingItem(
      title: 'Track Your Progress',
      description:
          'View detailed analytics to see your progress and stay motivated on your spiritual journey.',
      image: 'assets/images/onboarding_analytics.png',
      backgroundColor: AppColors.primary,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    // Navigate to home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingItems.length,
            itemBuilder: (context, index) {
              final item = _onboardingItems[index];
              return _buildOnboardingPage(item);
            },
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          // Indicators and next button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingItems.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 40),
                // Next/Get Started button
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                        _onboardingItems[_currentPage].backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentPage == _onboardingItems.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Container(
      color: item.backgroundColor,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image placeholder (would be replaced with actual image)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51), // 0.2 opacity
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForImage(item.image),
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            item.description,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        color:
            isActive
                ? Colors.white
                : Colors.white.withAlpha(102), // 0.4 opacity
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  IconData _getIconForImage(String imagePath) {
    if (imagePath.contains('welcome')) {
      return Icons.waving_hand;
    } else if (imagePath.contains('habits')) {
      return Icons.check_circle;
    } else if (imagePath.contains('prayer')) {
      return Icons.access_time;
    } else if (imagePath.contains('dua')) {
      return Icons.menu_book;
    } else if (imagePath.contains('analytics')) {
      return Icons.bar_chart;
    }
    return Icons.image;
  }
}

/// Model class for onboarding items
class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}
