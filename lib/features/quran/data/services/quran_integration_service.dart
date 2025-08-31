import 'package:quran_library/quran_library.dart' hide QuranRepository;
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';

/// Service to integrate with the existing Quran library
class QuranIntegrationService {
  final QuranLibrary _quranLibrary;

  QuranIntegrationService({required QuranLibrary quranLibrary})
      : _quranLibrary = quranLibrary;

  /// Get all surahs from the Quran library
  List<SurahNamesModel> getAllSurahs() {
    return _quranLibrary.quranCtrl.surahsList;
  }

  /// Get a surah by its number
  SurahNamesModel? getSurahByNumber(int surahNumber) {
    try {
      // Surah numbers are 1-based, but the list is 0-based
      if (surahNumber < 1 || surahNumber > _quranLibrary.quranCtrl.surahsList.length) {
        return null;
      }
      return _quranLibrary.quranCtrl.surahsList[surahNumber - 1];
    } catch (e) {
      return null;
    }
  }

  /// Create a MemorizationItem from a surah number
  MemorizationItem createMemorizationItemFromSurah(int surahNumber) {
    final surah = getSurahByNumber(surahNumber);
    
    return MemorizationItem(
      id: '', // Will be set by the repository
      surahNumber: surahNumber,
      surahName: surah?.englishName ?? 'Unknown Surah',
      startPage: 1, // Default values since we don't have page info
      endPage: 1,   // Default values since we don't have page info
      dateAdded: DateTime.now(),
      status: MemorizationStatus.newStatus,
      consecutiveReviewDays: 0,
      lastReviewed: null,
      reviewHistory: [],
    );
  }

  /// Get surahs in the specified memorization direction
  List<SurahNamesModel> getSurahsInDirection(MemorizationDirection direction) {
    final allSurahs = getAllSurahs();
    
    if (direction == MemorizationDirection.fromNas) {
      // Reverse the list for memorizing from Nas to Baqarah
      return allSurahs.reversed.toList();
    }
    
    // Default is from Baqarah to Nas
    return allSurahs;
  }
}