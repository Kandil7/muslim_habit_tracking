import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/hadith_model.dart';

/// Interface for the local data source for Hadith feature
abstract class HadithLocalDataSource {
  /// Get all hadiths from local storage
  Future<List<HadithModel>> getAllHadiths();

  /// Get a hadith by its ID
  Future<HadithModel> getHadithById(String id);

  /// Get the hadith of the day
  Future<HadithModel> getHadithOfTheDay();

  /// Get hadiths by source (e.g., Bukhari, Muslim)
  Future<List<HadithModel>> getHadithsBySource(String source);

  /// Get hadiths by tag or category
  Future<List<HadithModel>> getHadithsByTag(String tag);

  /// Get bookmarked hadiths
  Future<List<HadithModel>> getBookmarkedHadiths();

  /// Toggle bookmark status for a hadith
  Future<HadithModel> toggleHadithBookmark(String id);

  /// Initialize the data source with sample data if empty
  Future<void> initializeWithSampleData();
}

/// Implementation of the local data source for Hadith feature using Hive
class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  final Box hadithBox;

  /// Creates a new HadithLocalDataSourceImpl instance
  HadithLocalDataSourceImpl({required this.hadithBox});

  @override
  Future<List<HadithModel>> getAllHadiths() async {
    try {
      final hadiths =
          hadithBox.values.map((hadith) {
            return HadithModel.fromHiveObject(hadith as Map);
          }).toList();

      return hadiths;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all hadiths from local storage : $e',
      );
    }
  }

  @override
  Future<HadithModel> getHadithById(String id) async {
    try {
      final hadith = hadithBox.get(id);
      if (hadith == null) {
        throw CacheException(
          message: 'Hadith with ID $id not found in local storage',
        );
      }
      return HadithModel.fromHiveObject(hadith as Map);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get hadith with ID $id from local storage : $e',
      );
    }
  }

  @override
  Future<HadithModel> getHadithOfTheDay() async {
    try {
      final hadiths = await getAllHadiths();
      if (hadiths.isEmpty) {
        throw CacheException(message: 'No hadiths found in local storage');
      }

      // Use the current date to select a hadith deterministically
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      final index = dayOfYear % hadiths.length;

      return hadiths[index];
    } catch (e) {
      throw CacheException(
        message: 'Failed to get hadith of the day from local storage : $e',
      );
    }
  }

  @override
  Future<List<HadithModel>> getHadithsBySource(String source) async {
    try {
      final hadiths = await getAllHadiths();
      return hadiths.where((hadith) => hadith.source == source).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get hadiths by source from local storage : $e',
      );
    }
  }

  @override
  Future<List<HadithModel>> getHadithsByTag(String tag) async {
    try {
      final hadiths = await getAllHadiths();
      return hadiths.where((hadith) => hadith.tags.contains(tag)).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get hadiths by tag from local storage : $e',
      );
    }
  }

  @override
  Future<List<HadithModel>> getBookmarkedHadiths() async {
    try {
      final hadiths = await getAllHadiths();
      return hadiths.where((hadith) => hadith.isBookmarked).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get bookmarked hadiths from local storage : $e',
      );
    }
  }

  @override
  Future<HadithModel> toggleHadithBookmark(String id) async {
    try {
      final hadith = await getHadithById(id);
      final updatedHadith = hadith.copyWith(isBookmarked: !hadith.isBookmarked);

      await hadithBox.put(id, updatedHadith.toHiveObject());

      return updatedHadith;
    } catch (e) {
      throw CacheException(
        message: 'Failed to toggle bookmark status for hadith with ID $id : $e',
      );
    }
  }

  @override
  Future<void> initializeWithSampleData() async {
    try {
      // Only initialize if the box is empty
      if (hadithBox.isEmpty) {
        final sampleHadiths = _getSampleHadiths();

        // Add sample hadiths to the box
        for (final hadith in sampleHadiths) {
          await hadithBox.put(hadith.id, hadith.toHiveObject());
        }
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to initialize with sample data : $e',
      );
    }
  }

  /// Returns a list of sample hadiths for initial data
  List<HadithModel> _getSampleHadiths() {
    return [
      const HadithModel(
        id: 'hadith1',
        text:
            'The best of you are those who are best to their families, and I am the best of you to my family.',
        narrator: 'Aisha (RA)',
        source: 'Sunan al-Tirmidhī',
        book: 'Book of Virtues',
        number: '3895',
        grade: 'Sahih',
        tags: ['Family', 'Character'],
      ),
      const HadithModel(
        id: 'hadith2',
        text:
            'None of you truly believes until he loves for his brother what he loves for himself.',
        narrator: 'Anas ibn Malik (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Faith',
        number: '13',
        grade: 'Sahih',
        tags: ['Faith', 'Brotherhood'],
      ),
      const HadithModel(
        id: 'hadith3',
        text:
            'The strong person is not the one who can wrestle someone else down. The strong person is the one who can control himself when he is angry.',
        narrator: 'Abu Hurairah (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Good Manners',
        number: '6114',
        grade: 'Sahih',
        tags: ['Anger', 'Self-control'],
      ),
      const HadithModel(
        id: 'hadith4',
        text:
            'Whoever believes in Allah and the Last Day, let him speak good or remain silent.',
        narrator: 'Abu Hurairah (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Good Manners',
        number: '6018',
        grade: 'Sahih',
        tags: ['Speech', 'Character'],
      ),
      const HadithModel(
        id: 'hadith5',
        text:
            'The most beloved of deeds to Allah are those that are most consistent, even if they are small.',
        narrator: 'Aisha (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Faith',
        number: '6464',
        grade: 'Sahih',
        tags: ['Deeds', 'Consistency'],
      ),
      const HadithModel(
        id: 'hadith6',
        text:
            'Verily, the reward of deeds depends upon the intention, and every person will be rewarded according to what he intended.',
        narrator: 'Umar ibn al-Khattab (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Revelation',
        number: '1',
        grade: 'Sahih',
        tags: ['Intention', 'Deeds'],
      ),
      const HadithModel(
        id: 'hadith7',
        text:
            'A Muslim is the one from whose tongue and hands other Muslims are safe.',
        narrator: 'Abdullah ibn Amr (RA)',
        source: 'Sahih al-Bukhari',
        book: 'Book of Faith',
        number: '10',
        grade: 'Sahih',
        tags: ['Character', 'Safety'],
      ),
    ];
  }
}
