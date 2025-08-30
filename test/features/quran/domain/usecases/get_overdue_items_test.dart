import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_overdue_items.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'get_overdue_items_test.mocks.dart';

@GenerateMocks([MemorizationRepository])
void main() {
  late GetOverdueItems usecase;
  late MockMemorizationRepository mockRepository;

  setUp(() {
    mockRepository = MockMemorizationRepository();
    usecase = GetOverdueItems(mockRepository);
  });

  final testItems = [
    const MemorizationItem(
      id: '1',
      surahNumber: 2,
      surahName: 'Al-Baqarah',
      startPage: 2,
      endPage: 49,
      dateAdded: DateTime(2023, 1, 1),
      status: MemorizationStatus.memorized,
      consecutiveReviewDays: 5,
      lastReviewed: DateTime(2023, 1, 1),
      reviewHistory: [DateTime(2023, 1, 1)],
      overdueCount: 1,
    ),
  ];

  test('should get overdue items from the repository', () async {
    // Arrange
    when(mockRepository.getOverdueItems())
        .thenAnswer((_) async => const Right(testItems));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(testItems));
    verify(mockRepository.getOverdueItems());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository returns failure', () async {
    // Arrange
    final failure = CacheFailure(message: 'Failed to get overdue items');
    when(mockRepository.getOverdueItems())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(mockRepository.getOverdueItems());
    verifyNoMoreInteractions(mockRepository);
  });
}