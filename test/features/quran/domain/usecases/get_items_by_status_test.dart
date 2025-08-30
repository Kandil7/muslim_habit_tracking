import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_items_by_status.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'get_items_by_status_test.mocks.dart';

@GenerateMocks([MemorizationRepository])
void main() {
  late GetItemsByStatus usecase;
  late MockMemorizationRepository mockRepository;

  setUp(() {
    mockRepository = MockMemorizationRepository();
    usecase = GetItemsByStatus(mockRepository);
  });

  final testItems = [
    const MemorizationItem(
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
    ),
  ];

  test('should get items by status from the repository', () async {
    // Arrange
    when(mockRepository.getItemsByStatus(any))
        .thenAnswer((_) async => const Right(testItems));

    // Act
    final result = await usecase(MemorizationStatus.newStatus);

    // Assert
    expect(result, const Right(testItems));
    verify(mockRepository.getItemsByStatus(MemorizationStatus.newStatus));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository returns failure', () async {
    // Arrange
    final failure = CacheFailure(message: 'Failed to get items');
    when(mockRepository.getItemsByStatus(any))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(MemorizationStatus.newStatus);

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.getItemsByStatus(MemorizationStatus.newStatus));
    verifyNoMoreInteractions(mockRepository);
  });
}