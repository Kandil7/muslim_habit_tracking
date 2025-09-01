import 'package:equatable/equatable.dart';

/// Overall statistics entity representing comprehensive analytics
class OverallStats extends Equatable {
  final DateTime generatedAt;
  final HabitAnalytics habitAnalytics;
  final IbadahAnalytics ibadahAnalytics;
  final SkillsAnalytics skillsAnalytics;
  final SelfDevelopmentAnalytics selfDevelopmentAnalytics;
  final DateTime dateRangeStart;
  final DateTime dateRangeEnd;

  const OverallStats({
    required this.generatedAt,
    required this.habitAnalytics,
    required this.ibadahAnalytics,
    required this.skillsAnalytics,
    required this.selfDevelopmentAnalytics,
    required this.dateRangeStart,
    required this.dateRangeEnd,
  });

  @override
  List<Object?> get props => [
        generatedAt,
        habitAnalytics,
        ibadahAnalytics,
        skillsAnalytics,
        selfDevelopmentAnalytics,
        dateRangeStart,
        dateRangeEnd,
      ];

  OverallStats copyWith({
    DateTime? generatedAt,
    HabitAnalytics? habitAnalytics,
    IbadahAnalytics? ibadahAnalytics,
    SkillsAnalytics? skillsAnalytics,
    SelfDevelopmentAnalytics? selfDevelopmentAnalytics,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
  }) {
    return OverallStats(
      generatedAt: generatedAt ?? this.generatedAt,
      habitAnalytics: habitAnalytics ?? this.habitAnalytics,
      ibadahAnalytics: ibadahAnalytics ?? this.ibadahAnalytics,
      skillsAnalytics: skillsAnalytics ?? this.skillsAnalytics,
      selfDevelopmentAnalytics:
          selfDevelopmentAnalytics ?? this.selfDevelopmentAnalytics,
      dateRangeStart: dateRangeStart ?? this.dateRangeStart,
      dateRangeEnd: dateRangeEnd ?? this.dateRangeEnd,
    );
  }
}

/// Analytics for habit tracking
class HabitAnalytics extends Equatable {
  final int totalHabits;
  final int activeHabits;
  final int completedToday;
  final double overallCompletionRate;
  final int averageStreak;
  final int longestStreak;
  final Map<String, int> habitsByArea; // Area -> Count

  const HabitAnalytics({
    required this.totalHabits,
    required this.activeHabits,
    required this.completedToday,
    required this.overallCompletionRate,
    required this.averageStreak,
    required this.longestStreak,
    required this.habitsByArea,
  });

  @override
  List<Object?> get props => [
        totalHabits,
        activeHabits,
        completedToday,
        overallCompletionRate,
        averageStreak,
        longestStreak,
        habitsByArea,
      ];
}

/// Analytics for Ibadah activities
class IbadahAnalytics extends Equatable {
  final int prayersCompleted;
  final int totalPrayers;
  final double prayerCompletionRate;
  final int adhkarCompleted;
  final int totalAdhkar;
  final double adhkarCompletionRate;
  final int quranPagesRead;
  final Duration quranTimeSpent;
  final int dhikrSessions;
  final Duration dhikrTimeSpent;
  final int lecturesCompleted;

  const IbadahAnalytics({
    required this.prayersCompleted,
    required this.totalPrayers,
    required this.prayerCompletionRate,
    required this.adhkarCompleted,
    required this.totalAdhkar,
    required this.adhkarCompletionRate,
    required this.quranPagesRead,
    required this.quranTimeSpent,
    required this.dhikrSessions,
    required this.dhikrTimeSpent,
    required this.lecturesCompleted,
  });

  @override
  List<Object?> get props => [
        prayersCompleted,
        totalPrayers,
        prayerCompletionRate,
        adhkarCompleted,
        totalAdhkar,
        adhkarCompletionRate,
        quranPagesRead,
        quranTimeSpent,
        dhikrSessions,
        dhikrTimeSpent,
        lecturesCompleted,
      ];
}

/// Analytics for skills development
class SkillsAnalytics extends Equatable {
  final int totalActivities;
  final Duration totalTimeSpent;
  final Map<String, int> activitiesByType; // Type -> Count
  final int resourcesSaved;
  final int challengesCompleted;
  final int totalChallenges;
  final double challengeCompletionRate;
  final int projectNotes;

  const SkillsAnalytics({
    required this.totalActivities,
    required this.totalTimeSpent,
    required this.activitiesByType,
    required this.resourcesSaved,
    required this.challengesCompleted,
    required this.totalChallenges,
    required this.challengeCompletionRate,
    required this.projectNotes,
  });

  @override
  List<Object?> get props => [
        totalActivities,
        totalTimeSpent,
        activitiesByType,
        resourcesSaved,
        challengesCompleted,
        totalChallenges,
        challengeCompletionRate,
        projectNotes,
      ];
}

/// Analytics for self-development activities
class SelfDevelopmentAnalytics extends Equatable {
  final int goalsSet;
  final int goalsCompleted;
  final double goalCompletionRate;
  final int reflectionEntries;
  final int mindfulnessSessions;
  final Duration mindfulnessTimeSpent;
  final Map<String, int> habitsByArea; // Area -> Count

  const SelfDevelopmentAnalytics({
    required this.goalsSet,
    required this.goalsCompleted,
    required this.goalCompletionRate,
    required this.reflectionEntries,
    required this.mindfulnessSessions,
    required this.mindfulnessTimeSpent,
    required this.habitsByArea,
  });

  @override
  List<Object?> get props => [
        goalsSet,
        goalsCompleted,
        goalCompletionRate,
        reflectionEntries,
        mindfulnessSessions,
        mindfulnessTimeSpent,
        habitsByArea,
      ];
}