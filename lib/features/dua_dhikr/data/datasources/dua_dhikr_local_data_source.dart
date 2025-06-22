import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:muslim_habbit/core/error/exceptions.dart';
import 'package:muslim_habbit/features/dua_dhikr/data/models/dhikr_model.dart';
import 'package:muslim_habbit/features/dua_dhikr/data/models/dua_model.dart';

abstract class DuaDhikrLocalDataSource {
  Future<List<DuaModel>> getAllDuas();
  Future<List<DuaModel>> getDuasByCategory(String category);
  Future<List<DuaModel>> getFavoriteDuas();
  Future<DuaModel> toggleDuaFavorite(String id);
  Future<List<DhikrModel>> getAllDhikrs();
  Future<List<DhikrModel>> getFavoriteDhikrs();
  Future<DhikrModel> toggleDhikrFavorite(String id);
  Future<List<String>> getDuaCategories();
  Future<void> initializeDefaultDuasDhikrs();
}

class DuaDhikrLocalDataSourceImpl implements DuaDhikrLocalDataSource {
  final Box duaDhikrBox;
  final String adhkarAssetPath;

  DuaDhikrLocalDataSourceImpl({
    required this.duaDhikrBox,
    this.adhkarAssetPath = 'assets/json/adhkar.json',
  });

  @override
  Future<List<DuaModel>> getAllDuas() async {
    try {
      final duasJson = duaDhikrBox.get('duas');
      if (duasJson == null) {
        await initializeDefaultDuasDhikrs();
        return getAllDuas();
      }

      final List<dynamic> duasList = json.decode(duasJson);
      return duasList.map((duaJson) => DuaModel.fromJson(duaJson)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get duas: ${e.toString()}');
    }
  }

  @override
  Future<List<DuaModel>> getDuasByCategory(String category) async {
    try {
      final duas = await getAllDuas();
      return duas.where((dua) => dua.category == category).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get duas by category: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DuaModel>> getFavoriteDuas() async {
    try {
      final duas = await getAllDuas();
      return duas.where((dua) => dua.toEntity().isFavorite).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get favorite duas: ${e.toString()}',
      );
    }
  }

  @override
  Future<DuaModel> toggleDuaFavorite(String id) async {
    try {
      final duas = await getAllDuas();
      final index = duas.indexWhere((dua) => dua.id == id);

      if (index == -1) throw CacheException(message: 'Dua not found');

      final updatedDua =
          duas[index].copyWith(isFavorite: !duas[index].isFavorite) as DuaModel;
      duas[index] = updatedDua;

      await duaDhikrBox.put(
        'duas',
        json.encode(duas.map((dua) => dua.toJson()).toList()),
      );

      return updatedDua;
    } catch (e) {
      throw CacheException(
        message: 'Failed to toggle dua favorite: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DhikrModel>> getAllDhikrs() async {
    try {
      final dhikrsJson = duaDhikrBox.get('dhikrs');
      if (dhikrsJson == null) {
        await initializeDefaultDuasDhikrs();
        return getAllDhikrs();
      }

      final List<dynamic> dhikrsList = json.decode(dhikrsJson);
      return dhikrsList
          .map((dhikrJson) => DhikrModel.fromJson(dhikrJson))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get dhikrs: ${e.toString()}');
    }
  }

  @override
  Future<List<DhikrModel>> getFavoriteDhikrs() async {
    try {
      final dhikrs = await getAllDhikrs();
      return dhikrs.where((dhikr) => dhikr.isFavorite).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get favorite dhikrs: ${e.toString()}',
      );
    }
  }

  @override
  Future<DhikrModel> toggleDhikrFavorite(String id) async {
    try {
      final dhikrs = await getAllDhikrs();
      final index = dhikrs.indexWhere((dhikr) => dhikr.id == id);

      if (index == -1) throw CacheException(message: 'Dhikr not found');

      final updatedDhikr =
          dhikrs[index].copyWith(isFavorite: !dhikrs[index].isFavorite)
              as DhikrModel;
      dhikrs[index] = updatedDhikr;

      await duaDhikrBox.put(
        'dhikrs',
        json.encode(dhikrs.map((dhikr) => dhikr.toJson()).toList()),
      );

      return updatedDhikr;
    } catch (e) {
      throw CacheException(
        message: 'Failed to toggle dhikr favorite: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<String>> getDuaCategories() async {
    try {
      final duas = await getAllDuas();
      final categories = duas.map((dua) => dua.category).toSet().toList();
      return categories;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get dua categories: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> initializeDefaultDuasDhikrs() async {
    try {
      // Default duas
      final List<DuaModel> defaultDuas = [
        DuaModel(
          id: '1',
          title: 'Morning Dua',
          arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ...',
          transliteration: 'Asbahna wa asbahal mulku lillah...',
          translation: 'We have reached the morning...',
          reference: 'Abu Dawud 4:317',
          category: 'Morning',
          isFavorite: false,
        ),
        // ... other duas
      ];

      // Load dhikrs from JSON
      final List<DhikrModel> defaultDhikrs = await _loadDhikrsFromAsset();

      await duaDhikrBox.put(
        'duas',
        json.encode(defaultDuas.map((e) => e.toJson()).toList()),
      );
      await duaDhikrBox.put(
        'dhikrs',
        json.encode(defaultDhikrs.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      throw CacheException(message: 'Initialization failed: ${e.toString()}');
    }
  }

  Future<List<DhikrModel>> _loadDhikrsFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(adhkarAssetPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      final List<DhikrModel> dhikrs = [];
      int globalIndex = 0;

      for (final categoryData in jsonData) {
        final category = categoryData['category'] as String? ?? 'Uncategorized';
        final array = categoryData['array'] as List<dynamic>? ?? [];

        for (final item in array) {
          final zekr = item['zekr'] as String? ?? '';
          final description = item['description'] as String? ?? 'Dhikr';
          final reference = item['reference'] as String? ?? '';

          dhikrs.add(
            DhikrModel(
              id: 'dhikr_${globalIndex++}',
              title: description,
              arabicText: zekr,
              transliteration: '',
              translation: '',
              reference: reference,
              recommendedCount: _parseRecommendedCount(item['count']),
              isFavorite: false,
            ),
          );
        }
      }

      return dhikrs;
    } catch (e) {
      throw CacheException(
        message: 'Failed to load dhikrs from asset: ${e.toString()}',
      );
    }
  }

  int _parseRecommendedCount(dynamic count) {
    if (count == null) return 1;
    if (count is int) return count;
    if (count is String) return int.tryParse(count) ?? 1;
    return 1;
  }
}
