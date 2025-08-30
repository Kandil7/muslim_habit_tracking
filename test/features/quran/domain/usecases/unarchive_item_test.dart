import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/unarchive_item.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'unarchive_item_test.mocks.dart';

@GenerateMocks([MemorizationRepository])
void main() {
  late UnarchiveItem usecase;
  late MockMemorizationRepository mockRepository;

  setUp(() {
    mockRepository = MockMemorizationRepository();
    usecase = UnarchiveItem(mockRepository);
  });

  final testItem = MemorizationItem(
    id: '1',
    surahNumber: 2,
    surahName: 'Al-Baqarah',
    startPage: 2,
    endPage: 49,
    dateAdded: DateTime(2023, 1, 1),
    status: MemorizationStatus.newStatus,
    consecutiveReviewDays: 0,
    lastReviewed: null,
    reviewHistory: [],
  );

  test('should unarchive an item through the repository', () async {
    // Arrange
    when(mockRepository.unarchiveItem(any))
        .thenAnswer((_) async => Right(testItem));

    // Act
    final result = await usecase('1');

    // Assert
    expect(result, Right(testItem));
    verify(mockRepository.unarchiveItem('1'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository returns failure', () async {
    // Arrange
    final failure = CacheFailure(message: 'Failed to unarchive item');
    when(mockRepository.unarchiveItem(any))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase('1');

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.unarchiveItem('1'));
    verifyNoMoreInteractions(mockRepository);
  });
}