/// Application-wide constants
class AppConstants {
  // App info
  static const String appName = 'SunnahTrack';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String prayerTimesBaseUrl = 'https://api.aladhan.com/v1';
  
  // Local storage keys
  static const String habitsBoxName = 'habits';
  static const String prayerTimesBoxName = 'prayerTimes';
  static const String settingsBoxName = 'settings';
  static const String duaDhikrBoxName = 'duaDhikr';
  
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
}
