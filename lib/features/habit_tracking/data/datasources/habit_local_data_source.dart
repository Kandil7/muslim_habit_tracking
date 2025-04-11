import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
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
}

/// Implementation of HabitLocalDataSource using Hive
class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box habitsBox;
  final Box habitLogsBox;
  final Uuid uuid;
  
  HabitLocalDataSourceImpl({
    required this.habitsBox,
    required this.habitLogsBox,
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
}
