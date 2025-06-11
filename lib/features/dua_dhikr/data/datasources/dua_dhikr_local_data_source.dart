import 'dart:convert';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/dua_model.dart';
import '../models/dhikr_model.dart';

/// Interface for local data source for duas and dhikrs
abstract class DuaDhikrLocalDataSource {
  /// Get all duas
  Future<List<DuaModel>> getAllDuas();

  /// Get duas by category
  Future<List<DuaModel>> getDuasByCategory(String category);

  /// Get favorite duas
  Future<List<DuaModel>> getFavoriteDuas();

  /// Toggle dua favorite status
  Future<DuaModel> toggleDuaFavorite(String id);

  /// Get all dhikrs
  Future<List<DhikrModel>> getAllDhikrs();

  /// Get favorite dhikrs
  Future<List<DhikrModel>> getFavoriteDhikrs();

  /// Toggle dhikr favorite status
  Future<DhikrModel> toggleDhikrFavorite(String id);

  /// Get dua categories
  Future<List<String>> getDuaCategories();

  /// Initialize default duas and dhikrs
  Future<void> initializeDefaultDuasDhikrs();
}

/// Implementation of DuaDhikrLocalDataSource using Hive
class DuaDhikrLocalDataSourceImpl implements DuaDhikrLocalDataSource {
  final Box duaDhikrBox;

  DuaDhikrLocalDataSourceImpl({required this.duaDhikrBox});

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
      throw CacheException(message: 'Failed to get duas from local storage');
    }
  }

  @override
  Future<List<DuaModel>> getDuasByCategory(String category) async {
    try {
      final duas = await getAllDuas();
      return duas.where((dua) => dua.category == category).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get duas by category from local storage',
      );
    }
  }

  @override
  Future<List<DuaModel>> getFavoriteDuas() async {
    try {
      final duas = await getAllDuas();
      return duas.where((dua) => dua.isFavorite).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get favorite duas from local storage',
      );
    }
  }

  @override
  Future<DuaModel> toggleDuaFavorite(String id) async {
    try {
      final duas = await getAllDuas();
      final index = duas.indexWhere((dua) => dua.id == id);

      if (index == -1) {
        throw CacheException(message: 'Dua not found');
      }

      final updatedDua = duas[index].copyWith(
        isFavorite: !duas[index].isFavorite,
      );
      duas[index] = updatedDua;

      await duaDhikrBox.put(
        'duas',
        json.encode(duas.map((dua) => dua.toJson()).toList()),
      );

      return updatedDua;
    } catch (e) {
      throw CacheException(message: 'Failed to toggle dua favorite status');
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
      throw CacheException(message: 'Failed to get dhikrs from local storage');
    }
  }

  @override
  Future<List<DhikrModel>> getFavoriteDhikrs() async {
    try {
      final dhikrs = await getAllDhikrs();
      return dhikrs.where((dhikr) => dhikr.isFavorite).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get favorite dhikrs from local storage',
      );
    }
  }

  @override
  Future<DhikrModel> toggleDhikrFavorite(String id) async {
    try {
      final dhikrs = await getAllDhikrs();
      final index = dhikrs.indexWhere((dhikr) => dhikr.id == id);

      if (index == -1) {
        throw CacheException(message: 'Dhikr not found');
      }

      final updatedDhikr = dhikrs[index].copyWith(
        isFavorite: !dhikrs[index].isFavorite,
      );
      dhikrs[index] = updatedDhikr;

      await duaDhikrBox.put(
        'dhikrs',
        json.encode(dhikrs.map((dhikr) => dhikr.toJson()).toList()),
      );

      return updatedDhikr;
    } catch (e) {
      throw CacheException(message: 'Failed to toggle dhikr favorite status');
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
        message: 'Failed to get dua categories from local storage',
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
          arabicText:
              'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ',
          transliteration:
              "Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la shareeka lah, lahul mulku walahul hamd, wa huwa 'ala kulli shay'in qadeer",
          translation:
              'We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.',
          reference: 'Abu Dawud 4:317',
          category: 'Morning',
          isFavorite: false,
        ),
        DuaModel(
          id: '2',
          title: 'Evening Dua',
          arabicText:
              'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ للهِ، وَالْحَمْدُ للهِ، لَا إِلَهَ إِلاَّ اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              "Amsayna wa amsal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la shareeka lah, lahul mulku walahul hamd, wa huwa 'ala kulli shay'in qadeer",
          translation:
              'We have reached the evening and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.',
          reference: 'Abu Dawud 4:318',
          category: 'Evening',
          isFavorite: false,
        ),
        DuaModel(
          id: '3',
          title: 'Before Sleep',
          arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amootu wa ahya',
          translation: 'In Your name, O Allah, I die and I live.',
          reference: 'Bukhari 11:113',
          category: 'Sleep',
          isFavorite: false,
        ),
        DuaModel(
          id: '4',
          title: 'After Prayer',
          arabicText:
              'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          transliteration:
              "Allahumma a'inni 'ala dhikrika wa shukrika wa husni 'ibadatik",
          translation:
              'O Allah, help me to remember You, to thank You, and to worship You in the best manner.',
          reference: 'Abu Dawud 2:86',
          category: 'Prayer',
          isFavorite: false,
        ),
        DuaModel(
          id: '5',
          title: 'Entering Masjid',
          arabicText: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          transliteration: 'Allahumma iftah li abwaba rahmatik',
          translation: 'O Allah, open for me the doors of Your mercy.',
          reference: 'Muslim 1:494',
          category: 'Masjid',
          isFavorite: false,
        ),
      ];

      // Default dhikrs
      final List<DhikrModel> defaultDhikrs = [
        DhikrModel(
          id: '1',
          title: 'Subhanallah',
          arabicText: 'سُبْحَانَ اللهِ',
          transliteration: 'Subhanallah',
          translation: 'Glory be to Allah',
          reference: 'Bukhari 8:75',
          recommendedCount: 33,
          isFavorite: false,
        ),
        DhikrModel(
          id: '2',
          title: 'Alhamdulillah',
          arabicText: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is due to Allah',
          reference: 'Bukhari 8:75',
          recommendedCount: 33,
          isFavorite: false,
        ),
        DhikrModel(
          id: '3',
          title: 'Allahu Akbar',
          arabicText: 'اللهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest',
          reference: 'Bukhari 8:75',
          recommendedCount: 33,
          isFavorite: false,
        ),
        DhikrModel(
          id: '4',
          title: 'La ilaha illallah',
          arabicText: 'لَا إِلَهَ إِلَّا اللهُ',
          transliteration: 'La ilaha illallah',
          translation: 'There is no god but Allah',
          reference: 'Tirmidhi 5:6',
          recommendedCount: 100,
          isFavorite: false,
        ),
        DhikrModel(
          id: '5',
          title: 'Astaghfirullah',
          arabicText: 'أَسْتَغْفِرُ اللهَ',
          transliteration: 'Astaghfirullah',
          translation: 'I seek forgiveness from Allah',
          reference: 'Muslim 4:2075',
          recommendedCount: 100,
          isFavorite: false,
        ),
      ];

      // Save to Hive
      await duaDhikrBox.put(
        'duas',
        json.encode(defaultDuas.map((dua) => dua.toJson()).toList()),
      );
      await duaDhikrBox.put(
        'dhikrs',
        json.encode(defaultDhikrs.map((dhikr) => dhikr.toJson()).toList()),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to initialize default duas and dhikrs',
      );
    }
  }
}
