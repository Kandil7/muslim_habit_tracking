import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/archive_item.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'archive_item_test.mocks.dart';

@GenerateMocks([MemorizationRepository])
void main() {
  late ArchiveItem usecase;
  late MockMemorizationRepository mockRepository;

  setUp(() {
    mockRepository = MockMemorizationRepository();
    usecase = ArchiveItem(mockRepository);
  });

  final testItem = MemorizationItem(
    id: '1',
    surahNumber: 2,
    surahName: 'Al-Baqarah',
    startPage: 2,
    endPage: 49,
    dateAdded: DateTime(2023, 1, 1),
    status: MemorizationStatus.archived,
    consecutiveReviewDays: 0,
    lastReviewed: null,
    reviewHistory: [],
  );

  test('should archive an item through the repository', () async {
    // Arrange
    when(mockRepository.archiveItem(any))
        .thenAnswer((_) async => Right(testItem));

    // Act
    final result = await usecase('1');

    // Assert
    expect(result, Right(testItem));
    verify(mockRepository.archiveItem('1'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository returns failure', () async {
    // Arrange
    final failure = CacheFailure(message: 'Failed to archive item');
    when(mockRepository.archiveItem(any))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase('1');

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.archiveItem('1'));
    verifyNoMoreInteractions(mockRepository);
  });
}