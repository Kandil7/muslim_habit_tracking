import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// Enhanced onboarding page with additional features
class EnhancedOnboardingPage extends StatefulWidget {
  const EnhancedOnboardingPage({super.key});

  @override
  State<EnhancedOnboardingPage> createState() => _EnhancedOnboardingPageState();
}

class _EnhancedOnboardingPageState extends State<EnhancedOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to SunnahTrack',
      description:
          'Your companion for building and maintaining consistent Islamic practices.',
      image: 'assets/images/app_logo_4.png',
      backgroundColor: AppColors.primary,
    ),
    OnboardingItem(
      title: 'Track Your Habits',
      description:
          'Create and track your daily Islamic habits like prayers, Quran reading, and more.',
      image: 'assets/images/home.png',
      backgroundColor: AppColors.secondary,
    ),
    OnboardingItem(
      title: 'Prayer Times',
      description:
          'Get accurate prayer times based on your location and receive timely notifications.',
      image: 'assets/images/time.png',
      backgroundColor: AppColors.primaryDark,
    ),
    OnboardingItem(
      title: 'Duas & Dhikr',
      description:
          'Access a collection of duas and dhikrs with a built-in counter to help you remember Allah.',
      image: 'assets/images/muslim_remembrances.png',
      backgroundColor: AppColors.secondaryDark,
    ),
    OnboardingItem(
      title: 'Track Your Progress',
      description:
          'View detailed analytics to see your progress and stay motivated on your spiritual journey.',
      image: 'assets/images/quran_kareem.png',
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
    
    // Save user preferences
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('location_enabled', _locationEnabled);

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
              return _buildOnboardingPage(item, index);
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
                const SizedBox(height: 20),
                // Permission toggles on the last page
                if (_currentPage == _onboardingItems.length - 1)
                  _buildPermissionToggles(),
                const SizedBox(height: 20),
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

  Widget _buildOnboardingPage(OnboardingItem item, int index) {
    return Container(
      color: item.backgroundColor,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51), // 0.2 opacity
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              item.image,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
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

  Widget _buildPermissionToggles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const Text(
            'Enable Permissions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile.adaptive(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: Colors.white,
          ),
          SwitchListTile.adaptive(
            title: const Text(
              'Location Services',
              style: TextStyle(color: Colors.white),
            ),
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
            activeColor: Colors.white,
          ),
        ],
      ),
    );
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