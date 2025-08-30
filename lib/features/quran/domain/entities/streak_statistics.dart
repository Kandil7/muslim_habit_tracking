import 'package:equatable/equatable.dart';

/// Entity representing streak statistics
class StreakStatistics extends Equatable {
  /// Current review streak (consecutive days of reviews)
  final int currentStreak;

  /// Longest review streak achieved
  final int longestStreak;

  /// Streak history (date -> streak length)
  final Map<DateTime, int> streakHistory;

  /// Constructor
  const StreakStatistics({
    required this.currentStreak,
    required this.longestStreak,
    required this.streakHistory,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        streakHistory,
      ];

  /// Creates a copy of this streak statistics with specified fields replaced
  StreakStatistics copyWith({
    int? currentStreak,
    int? longestStreak,
    Map<DateTime, int>? streakHistory,
  }) {
    return StreakStatistics(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      streakHistory: streakHistory ?? this.streakHistory,
    );
  }
}