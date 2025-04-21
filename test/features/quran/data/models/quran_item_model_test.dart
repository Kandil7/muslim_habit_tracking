// import 'package:flutter_test/flutter_test.dart';
// import 'package:muslim_habbit/features/quran/data/models/quran_item_model.dart';
// import 'package:muslim_habbit/features/quran/domain/entities/quran_item.dart';

// void main() {
//   group('QuranItemModel', () {
//     test('should be a subclass of QuranItem entity', () {
//       // Arrange
//       const quranItemModel = QuranItemModel(
//         number: 1,
//         name: 'الفاتحة',
//         englishName: 'Al-Fatiha',
//         englishNameTranslation: 'The Opening',
//         numberOfAyahs: 7,
//         revelationType: 'Meccan',
//         start: 1,
//       );

//       // Assert
//       expect(quranItemModel, isA<QuranItem>());
//     });

//     test('should create a valid QuranItemModel from JSON', () {
//       // Arrange
//       final json = {
//         'number': 1,
//         'name': 'الفاتحة',
//         'englishName': 'Al-Fatiha',
//         'englishNameTranslation': 'The Opening',
//         'numberOfAyahs': 7,
//         'revelationType': 'Meccan',
//         'start': 1,
//       };

//       // Act
//       final result = QuranItemModel.fromJson(json);

//       // Assert
//       expect(result, isA<QuranItemModel>());
//       expect(result.number, 1);
//       expect(result.name, 'الفاتحة');
//       expect(result.englishName, 'Al-Fatiha');
//       expect(result.englishNameTranslation, 'The Opening');
//       expect(result.numberOfAyahs, 7);
//       expect(result.revelationType, 'Meccan');
//       expect(result.start, 1);
//     });

//     test('should convert QuranItemModel to JSON', () {
//       // Arrange
//       const quranItemModel = QuranItemModel(
//         number: 1,
//         name: 'الفاتحة',
//         englishName: 'Al-Fatiha',
//         englishNameTranslation: 'The Opening',
//         numberOfAyahs: 7,
//         revelationType: 'Meccan',
//         start: 1,
//       );

//       // Act
//       final result = quranItemModel.toJson();

//       // Assert
//       final expectedJson = {
//         'number': 1,
//         'name': 'الفاتحة',
//         'englishName': 'Al-Fatiha',
//         'englishNameTranslation': 'The Opening',
//         'numberOfAyahs': 7,
//         'revelationType': 'Meccan',
//         'start': 1,
//       };
//       expect(result, expectedJson);
//     });

//     test('should create a copy with updated fields', () {
//       // Arrange
//       const quranItemModel = QuranItemModel(
//         number: 1,
//         name: 'الفاتحة',
//         englishName: 'Al-Fatiha',
//         englishNameTranslation: 'The Opening',
//         numberOfAyahs: 7,
//         revelationType: 'Meccan',
//         start: 1,
//       );

//       // Act
//       final updatedModel = quranItemModel.copyWith(
//         englishName: 'Updated Name',
//         numberOfAyahs: 8,
//       );

//       // Assert
//       expect(updatedModel, isA<QuranItemModel>());
//       expect(updatedModel.number, 1); // unchanged
//       expect(updatedModel.name, 'الفاتحة'); // unchanged
//       expect(updatedModel.englishName, 'Updated Name'); // changed
//       expect(updatedModel.englishNameTranslation, 'The Opening'); // unchanged
//       expect(updatedModel.numberOfAyahs, 8); // changed
//       expect(updatedModel.revelationType, 'Meccan'); // unchanged
//       expect(updatedModel.start, 1); // unchanged
//     });
//   });
// }
