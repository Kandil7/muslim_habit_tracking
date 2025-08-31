import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart' hide QuranRepository;
import 'package:muslim_habbit/features/quran/data/services/quran_integration_service.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';

import 'quran_integration_service_test.mocks.dart';

@GenerateMocks([QuranLibrary, QuranCtrl])
void main() {
  late QuranIntegrationService integrationService;
  late MockQuranLibrary mockQuranLibrary;
  late MockQuranCtrl mockQuranCtrl;
  late RxList<SurahNamesModel> mockSurahsList;

  setUp(() {
    mockQuranLibrary = MockQuranLibrary();
    mockQuranCtrl = MockQuranCtrl();
    mockSurahsList = RxList<SurahNamesModel>([
      SurahNamesModel(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatihah',
        englishNameTranslation: 'The Opening',
        revelationType: 'Makkah',
        ayahsNumber: 7,
        surahInfo: '',
        surahInfoFromBook: '',
        surahNames: '',
        surahNamesFromBook: '',
      ),
      SurahNamesModel(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqarah',
        englishNameTranslation: 'The Cow',
        revelationType: 'Madinah',
        ayahsNumber: 286,
        surahInfo: '',
        surahInfoFromBook: '',
        surahNames: '',
        surahNamesFromBook: '',
      ),
    ]);
    
    when(mockQuranLibrary.quranCtrl).thenReturn(mockQuranCtrl);
    when(mockQuranCtrl.surahsList).thenReturn(mockSurahsList);
    
    integrationService = QuranIntegrationService(quranLibrary: mockQuranLibrary);
  });

  group('getAllSurahs', () {
    test('should return all surahs from the Quran library', () {
      // Act
      final result = integrationService.getAllSurahs();

      // Assert
      expect(result, mockSurahsList);
    });
  });

  group('getSurahByNumber', () {
    test('should return a surah when it exists', () {
      // Act
      final result = integrationService.getSurahByNumber(2);

      // Assert
      expect(result, isNotNull);
      expect(result!.englishName, 'Al-Baqarah');
    });

    test('should return null when surah number is out of range', () {
      // Act
      final result = integrationService.getSurahByNumber(999);

      // Assert
      expect(result, isNull);
    });

    test('should return null when surah number is less than 1', () {
      // Act
      final result = integrationService.getSurahByNumber(0);

      // Assert
      expect(result, isNull);
    });
  });

  group('createMemorizationItemFromSurah', () {
    test('should create a memorization item with correct data', () {
      // Act
      final result = integrationService.createMemorizationItemFromSurah(2);

      // Assert
      expect(result.surahNumber, 2);
      expect(result.surahName, 'Al-Baqarah');
      expect(result.startPage, 1);
      expect(result.endPage, 1);
      expect(result.status, MemorizationStatus.newStatus);
      expect(result.consecutiveReviewDays, 0);
      expect(result.reviewHistory, isEmpty);
    });

    test('should create a memorization item with default name when surah not found', () {
      // Act
      final result = integrationService.createMemorizationItemFromSurah(999);

      // Assert
      expect(result.surahName, 'Unknown Surah');
    });
  });

  group('getSurahsInDirection', () {
    test('should return surahs in normal order for fromBaqarah direction', () {
      // Act
      final result = integrationService.getSurahsInDirection(MemorizationDirection.fromBaqarah);

      // Assert
      expect(result.length, 2);
      expect(result[0].englishName, 'Al-Fatihah');
      expect(result[1].englishName, 'Al-Baqarah');
    });

    test('should return surahs in reverse order for fromNas direction', () {
      // Act
      final result = integrationService.getSurahsInDirection(MemorizationDirection.fromNas);

      // Assert
      expect(result.length, 2);
      expect(result[0].englishName, 'Al-Baqarah');
      expect(result[1].englishName, 'Al-Fatihah');
    });
  });
}