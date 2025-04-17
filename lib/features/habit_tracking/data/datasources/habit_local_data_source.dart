import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/habit_category_model.dart';
import '../models/habit_model.dart';
import '../models/habit_log_model.dart';

/// Interface for local data source for habits
abstract class HabitLocalDataSource {
  /// Get all habits
  Future<List<HabitModel>> getHabits();

  /// Get a habit by ID
  Future<HabitModel> getHabitById(String id);

  /// Create a new habit
  Future<HabitModel> createHabit(HabitModel habit);

  /// Update an existing habit
  Future<HabitModel> updateHabit(HabitModel habit);

  /// Delete a habit
  Future<void> deleteHabit(String id);

  /// Get all logs for a habit
  Future<List<HabitLogModel>> getHabitLogs(String habitId);

  /// Get logs for a habit within a date range
  Future<List<HabitLogModel>> getHabitLogsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Create a new habit log
  Future<HabitLogModel> createHabitLog(HabitLogModel habitLog);

  /// Update an existing habit log
  Future<HabitLogModel> updateHabitLog(HabitLogModel habitLog);

  /// Delete a habit log
  Future<void> deleteHabitLog(String id);

  /// Get all categories
  Future<List<HabitCategoryModel>> getCategories();

  /// Get a category by ID
  Future<HabitCategoryModel> getCategoryById(String id);

  /// Create a new category
  Future<HabitCategoryModel> createCategory(HabitCategoryModel category);

  /// Update an existing category
  Future<HabitCategoryModel> updateCategory(HabitCategoryModel category);

  /// Delete a category
  Future<void> deleteCategory(String id);

  /// Get habits by category
  Future<List<HabitModel>> getHabitsByCategory(String categoryId);

  /// Update habit streak information
  Future<HabitModel> updateHabitStreak(String habitId, int currentStreak, int longestStreak, DateTime? lastCompletedDate);
}

/// Implementation of HabitLocalDataSource using Hive
class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box habitsBox;
  final Box habitLogsBox;
  final Box categoriesBox;
  final Uuid uuid;

  HabitLocalDataSourceImpl({
    required this.habitsBox,
    required this.habitLogsBox,
    required this.categoriesBox,
    required this.uuid,
  });

  @override
  Future<List<HabitModel>> getHabits() async {
    try {
      final habitsJson = habitsBox.values.toList();
      return habitsJson
          .map((habitJson) => HabitModel.fromJson(json.decode(habitJson)))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get habits from local storage');
    }
  }

  @override
  Future<HabitModel> getHabitById(String id) async {
    try {
      final habitJson = habitsBox.get(id);
      if (habitJson == null) {
        throw CacheException(message: 'Habit not found');
      }
      return HabitModel.fromJson(json.decode(habitJson));
    } catch (e) {
      throw CacheException(message: 'Failed to get habit from local storage');
    }
  }

  @override
  Future<HabitModel> createHabit(HabitModel habit) async {
    try {
      final newHabit = habit.copyWith(
        id: uuid.v4(),
        createdAt: DateTime.now(),
      );
      await habitsBox.put(
        newHabit.id,
        json.encode(newHabit.toJson()),
      );
      return newHabit;
    } catch (e) {
      throw CacheException(message: 'Failed to create habit in local storage');
    }
  }

  @override
  Future<HabitModel> updateHabit(HabitModel habit) async {
    try {
      final updatedHabit = habit.copyWith(
        updatedAt: DateTime.now(),
      );
      await habitsBox.put(
        updatedHabit.id,
        json.encode(updatedHabit.toJson()),
      );
      return updatedHabit;
    } catch (e) {
      throw CacheException(message: 'Failed to update habit in local storage');
    }
  }

  @override
  Future<HabitModel> updateHabitStreak(String habitId, int currentStreak, int longestStreak, DateTime? lastCompletedDate) async {
    try {
      final habit = await getHabitById(habitId);
      final updatedHabit = habit.copyWith(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        lastCompletedDate: lastCompletedDate,
        updatedAt: DateTime.now(),
      );
      await habitsBox.put(
        updatedHabit.id,
        json.encode(updatedHabit.toJson()),
      );
      return updatedHabit;
    } catch (e) {
      throw CacheException(message: 'Failed to update habit streak in local storage');
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    try {
      await habitsBox.delete(id);

      // Delete all logs for this habit
      final logs = await getHabitLogs(id);
      for (final log in logs) {
        await habitLogsBox.delete(log.id);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to delete habit from local storage');
    }
  }

  @override
  Future<List<HabitLogModel>> getHabitLogs(String habitId) async {
    try {
      final logsJson = habitLogsBox.values.toList();
      final logs = logsJson
          .map((logJson) => HabitLogModel.fromJson(json.decode(logJson)))
          .where((log) => log.habitId == habitId)
          .toList();
      return logs;
    } catch (e) {
      throw CacheException(message: 'Failed to get habit logs from local storage');
    }
  }

  @override
  Future<List<HabitLogModel>> getHabitLogsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final logs = await getHabitLogs(habitId);
      return logs
          .where((log) => log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                          log.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get habit logs by date range from local storage');
    }
  }

  @override
  Future<HabitLogModel> createHabitLog(HabitLogModel habitLog) async {
    try {
      final newLog = habitLog.copyWith(
        id: uuid.v4(),
        createdAt: DateTime.now(),
      );
      await habitLogsBox.put(
        newLog.id,
        json.encode(newLog.toJson()),
      );
      return newLog;
    } catch (e) {
      throw CacheException(message: 'Failed to create habit log in local storage');
    }
  }

  @override
  Future<HabitLogModel> updateHabitLog(HabitLogModel habitLog) async {
    try {
      await habitLogsBox.put(
        habitLog.id,
        json.encode(habitLog.toJson()),
      );
      return habitLog;
    } catch (e) {
      throw CacheException(message: 'Failed to update habit log in local storage');
    }
  }

  @override
  Future<void> deleteHabitLog(String id) async {
    try {
      await habitLogsBox.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete habit log from local storage');
    }
  }

  @override
  Future<List<HabitCategoryModel>> getCategories() async {
    try {
      final categoriesJson = categoriesBox.values.toList();
      return categoriesJson
          .map((categoryJson) => HabitCategoryModel.fromJson(json.decode(categoryJson)))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get categories from local storage');
    }
  }

  @override
  Future<HabitCategoryModel> getCategoryById(String id) async {
    try {
      final categoryJson = categoriesBox.get(id);
      if (categoryJson == null) {
        throw CacheException(message: 'Category not found');
      }
      return HabitCategoryModel.fromJson(json.decode(categoryJson));
    } catch (e) {
      throw CacheException(message: 'Failed to get category from local storage');
    }
  }

  @override
  Future<HabitCategoryModel> createCategory(HabitCategoryModel category) async {
    try {
      final newCategory = category.copyWith(
        id: uuid.v4(),
        createdAt: DateTime.now(),
      );
      await categoriesBox.put(
        newCategory.id,
        json.encode(newCategory.toJson()),
      );
      return newCategory;
    } catch (e) {
      throw CacheException(message: 'Failed to create category in local storage');
    }
  }

  @override
  Future<HabitCategoryModel> updateCategory(HabitCategoryModel category) async {
    try {
      await categoriesBox.put(
        category.id,
        json.encode(category.toJson()),
      );
      return category;
    } catch (e) {
      throw CacheException(message: 'Failed to update category in local storage');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await categoriesBox.delete(id);

      // Update habits that use this category to remove the category reference
      final habits = await getHabits();
      for (final habit in habits) {
        if (habit.categoryId == id) {
          final updatedHabit = habit.copyWith(categoryId: null);
          await updateHabit(updatedHabit);
        }
      }
    } catch (e) {
      throw CacheException(message: 'Failed to delete category from local storage');
    }
  }

  @override
  Future<List<HabitModel>> getHabitsByCategory(String categoryId) async {
    try {
      final habits = await getHabits();
      return habits.where((habit) => habit.categoryId == categoryId).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get habits by category from local storage');
    }
  }
}
