import 'package:equatable/equatable.dart';

/// Entity representing a Dhikr counter session
class DhikrCounter extends Equatable {
  final String id;
  final String dhikrText;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;
  final Duration timeSpent;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DhikrCounter({
    required this.id,
    required this.dhikrText,
    required this.targetCount,
    required this.currentCount,
    required this.isCompleted,
    required this.timeSpent,
    required this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        dhikrText,
        targetCount,
        currentCount,
        isCompleted,
        timeSpent,
        startTime,
        endTime,
        createdAt,
        updatedAt,
      ];

  DhikrCounter copyWith({
    String? id,
    String? dhikrText,
    int? targetCount,
    int? currentCount,
    bool? isCompleted,
    Duration? timeSpent,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DhikrCounter(
      id: id ?? this.id,
      dhikrText: dhikrText ?? this.dhikrText,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      timeSpent: timeSpent ?? this.timeSpent,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}