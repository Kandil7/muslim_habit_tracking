/// Application-wide constants
class AppConstants {
  // App info
  static const String appName = 'SunnahTracker';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String prayerTimesBaseUrl = 'https://api.aladhan.com/v1';

  // Local storage keys
  static const String habitsBoxName = 'habits';
  static const String habitLogsBoxName = 'habit_logs';
  static const String categoriesBoxName = 'habit_categories';
  static const String prayerTimesBoxName = 'prayerTimes';
  static const String settingsBoxName = 'settings';
  static const String duaDhikrBoxName = 'duaDhikr';
  static const String hadithBoxName = 'hadith';
  static const String quranBoxName = 'quran';
  static const String memorizationBoxName = 'memorization';

  // Default settings
  static const int defaultNotificationTime = 15; // minutes before prayer
  static const String defaultCalculationMethod = 'MWL'; // Muslim World League

  // Habit types
  static const String prayerHabit = 'prayer';
  static const String quranHabit = 'quran';
  static const String fastingHabit = 'fasting';
  static const String dhikrHabit = 'dhikr';
  static const String charityHabit = 'charity';
  static const String customHabit = 'custom';

  // Prayer names
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  // Additional prayers
  static const List<String> additionalPrayers = [
    'Tahajjud',
    'Duha',
    'Witr',
    'Tarawih',
  ];

  // asset surah names
  static String assetSurahNames(int num) {
    return 'packages/quran_library/assets/svg/surah_name/00$num.svg';
  }
}
