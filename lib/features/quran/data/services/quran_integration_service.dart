import 'package:quran_library/quran_library.dart' hide QuranRepository;

import '../../domain/entities/memorization_item.dart';

/// Service to integrate with the existing Quran library
class QuranIntegrationService {
  final QuranLibrary _quranLibrary;

  QuranIntegrationService({required QuranLibrary quranLibrary})
      : _quranLibrary = quranLibrary;

  /// Get all surahs from the Quran library
  List<Surah> getAllSurahs() {
    return _quranLibrary.getAllSurahs();
  }

  /// Get a surah by its number
  Surah? getSurahByNumber(int surahNumber) {
    try {
      return _quranLibrary.getSurah(surahNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get the start and end pages for a surah
  (int, int) getSurahPageRange(int surahNumber) {
    final surah = getSurahByNumber(surahNumber);
    if (surah == null) {
      return (1, 1); // Default to first page if surah not found
    }
    
    // Assuming the Quran library provides page information
    // This might need to be adjusted based on the actual Quran library API
    final startPage = surah.startPage ?? 1;
    final endPage = surah.endPage ?? startPage;
    
    return (startPage, endPage);
  }

  /// Create a MemorizationItem from a surah number
  MemorizationItem createMemorizationItemFromSurah(int surahNumber) {
    final surah = getSurahByNumber(surahNumber);
    final (startPage, endPage) = getSurahPageRange(surahNumber);
    
    return MemorizationItem(
      id: '', // Will be set by the repository
      surahNumber: surahNumber,
      surahName: surah?.name ?? 'Unknown Surah',
      startPage: startPage,
      endPage: endPage,
      dateAdded: DateTime.now(),
      status: MemorizationStatus.newStatus,
      consecutiveReviewDays: 0,
      lastReviewed: null,
      reviewHistory: [],
    );
  }

  /// Get surahs in the specified memorization direction
  List<Surah> getSurahsInDirection(MemorizationDirection direction) {
    final allSurahs = getAllSurahs();
    
    if (direction == MemorizationDirection.fromNas) {
      // Reverse the list for memorizing from Nas to Baqarah
      return allSurahs.reversed.toList();
    }
    
    // Default is from Baqarah to Nas
    return allSurahs;
  }
}