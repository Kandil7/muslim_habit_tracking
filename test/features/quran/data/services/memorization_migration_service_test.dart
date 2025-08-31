import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_habbit/features/quran/data/services/memorization_migration_service.dart';
import 'package:muslim_habbit/features/quran/data/datasources/memorization_local_data_source.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/data/models/memorization_preferences_model.dart';

import 'memorization_migration_service_test.mocks.dart';

@GenerateMocks([MemorizationLocalDataSource, SharedPreferences])
void main() {
  late MemorizationMigrationService migrationService;
  late MockMemorizationLocalDataSource mockLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockLocalDataSource = MockMemorizationLocalDataSource();
    mockSharedPreferences = MockSharedPreferences();
    migrationService = MemorizationMigrationService(
      localDataSource: mockLocalDataSource,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('migrateData', () {
    test('should migrate to version 1 when current version is 0', () async {
      // Arrange
      when(mockSharedPreferences.getInt(any)).thenReturn(0);
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

      // Mock the preferences behavior
      when(mockLocalDataSource.getPreferences())
          .thenThrow(Exception('Preferences not found'));
      
      final defaultPreferences = MemorizationPreferencesModel(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
      );
      
      when(mockLocalDataSource.updatePreferences(any))
          .thenAnswer((_) async => defaultPreferences);

      // Act
      await migrationService.migrateData();

      // Assert
      verify(mockSharedPreferences.getInt('memorization_migration_version'))
          .called(1);
      verify(mockLocalDataSource.getPreferences()).called(1);
      verify(mockLocalDataSource.updatePreferences(any)).called(1);
      verify(mockSharedPreferences.setInt(
              'memorization_migration_version', 1))
          .called(1);
    });

    test('should not migrate when current version is already up to date', () async {
      // Arrange
      when(mockSharedPreferences.getInt(any)).thenReturn(1);
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

      // Act
      await migrationService.migrateData();

      // Assert
      verify(mockSharedPreferences.getInt('memorization_migration_version'))
          .called(1);
      verifyNever(mockLocalDataSource.getPreferences());
      verify(mockSharedPreferences.setInt(
              'memorization_migration_version', 1))
          .called(1);
    });
  });

  group('_migrateToVersion1', () {
    test('should create default preferences when none exist', () async {
      // Arrange
      when(mockLocalDataSource.getPreferences())
          .thenThrow(Exception('Preferences not found'));
      
      final defaultPreferences = MemorizationPreferencesModel(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
      );
      
      when(mockLocalDataSource.updatePreferences(any))
          .thenAnswer((_) async => defaultPreferences);

      // Act
      // We need to call the private method through the public migrateData method
      when(mockSharedPreferences.getInt(any)).thenReturn(0);
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);
      
      await migrationService.migrateData();

      // Assert
      verify(mockLocalDataSource.getPreferences()).called(1);
      verify(mockLocalDataSource.updatePreferences(any)).called(1);
    });

    test('should not modify preferences when they already exist', () async {
      // Arrange
      final existingPreferences = MemorizationPreferencesModel(
        reviewPeriod: 7,
        memorizationDirection: MemorizationDirection.fromNas,
      );
      
      when(mockLocalDataSource.getPreferences())
          .thenAnswer((_) async => existingPreferences);

      // Act
      // We need to call the private method through the public migrateData method
      when(mockSharedPreferences.getInt(any)).thenReturn(0);
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);
      
      await migrationService.migrateData();

      // Assert
      verify(mockLocalDataSource.getPreferences()).called(1);
      verifyNever(mockLocalDataSource.updatePreferences(any));
    });
  });
}