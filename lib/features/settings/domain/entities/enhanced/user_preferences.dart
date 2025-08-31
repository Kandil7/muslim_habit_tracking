import 'package:equatable/equatable.dart';

/// Enhanced user preferences entity
class UserPreferences extends Equatable {
  final String language;
  final ThemePreference theme;
  final bool notificationsEnabled;
  final NotificationPreferences notificationPreferences;
  final PrivacySettings privacySettings;
  final AccessibilitySettings accessibilitySettings;
  final DailyPlannerSettings dailyPlannerSettings;
  final IbadahSettings ibadahSettings;
  final SkillsSettings skillsSettings;
  final SelfDevelopmentSettings selfDevelopmentSettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserPreferences({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.notificationPreferences,
    required this.privacySettings,
    required this.accessibilitySettings,
    required this.dailyPlannerSettings,
    required this.ibadahSettings,
    required this.skillsSettings,
    required this.selfDevelopmentSettings,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        language,
        theme,
        notificationsEnabled,
        notificationPreferences,
        privacySettings,
        accessibilitySettings,
        dailyPlannerSettings,
        ibadahSettings,
        skillsSettings,
        selfDevelopmentSettings,
        createdAt,
        updatedAt,
      ];

  UserPreferences copyWith({
    String? language,
    ThemePreference? theme,
    bool? notificationsEnabled,
    NotificationPreferences? notificationPreferences,
    PrivacySettings? privacySettings,
    AccessibilitySettings? accessibilitySettings,
    DailyPlannerSettings? dailyPlannerSettings,
    IbadahSettings? ibadahSettings,
    SkillsSettings? skillsSettings,
    SelfDevelopmentSettings? selfDevelopmentSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      privacySettings: privacySettings ?? this.privacySettings,
      accessibilitySettings:
          accessibilitySettings ?? this.accessibilitySettings,
      dailyPlannerSettings:
          dailyPlannerSettings ?? this.dailyPlannerSettings,
      ibadahSettings: ibadahSettings ?? this.ibadahSettings,
      skillsSettings: skillsSettings ?? this.skillsSettings,
      selfDevelopmentSettings:
          selfDevelopmentSettings ?? this.selfDevelopmentSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Theme preference settings
class ThemePreference extends Equatable {
  final String mode; // light, dark, system
  final String? customColorScheme;
  final double textScaleFactor;
  final bool highContrastMode;

  const ThemePreference({
    required this.mode,
    this.customColorScheme,
    required this.textScaleFactor,
    required this.highContrastMode,
  });

  @override
  List<Object?> get props => [
        mode,
        customColorScheme,
        textScaleFactor,
        highContrastMode,
      ];
}

/// Notification preferences
class NotificationPreferences extends Equatable {
  final bool prayerReminders;
  final bool habitReminders;
  final bool taskReminders;
  final bool adhkarReminders;
  final bool mindfulnessReminders;
  final bool goalReminders;
  final String reminderSound;
  final int reminderVolume;
  final List<String> doNotDisturbHours; // HH:MM format

  const NotificationPreferences({
    required this.prayerReminders,
    required this.habitReminders,
    required this.taskReminders,
    required this.adhkarReminders,
    required this.mindfulnessReminders,
    required this.goalReminders,
    required this.reminderSound,
    required this.reminderVolume,
    required this.doNotDisturbHours,
  });

  @override
  List<Object?> get props => [
        prayerReminders,
        habitReminders,
        taskReminders,
        adhkarReminders,
        mindfulnessReminders,
        goalReminders,
        reminderSound,
        reminderVolume,
        doNotDisturbHours,
      ];
}

/// Privacy settings
class PrivacySettings extends Equatable {
  final bool analyticsCollection;
  final bool crashReporting;
  final bool locationSharing;
  final bool backupEncryption;
  final List<String> excludedDataFromBackup;

  const PrivacySettings({
    required this.analyticsCollection,
    required this.crashReporting,
    required this.locationSharing,
    required this.backupEncryption,
    required this.excludedDataFromBackup,
  });

  @override
  List<Object?> get props => [
        analyticsCollection,
        crashReporting,
        locationSharing,
        backupEncryption,
        excludedDataFromBackup,
      ];
}

/// Accessibility settings
class AccessibilitySettings extends Equatable {
  final bool reduceMotion;
  final bool boldText;
  final bool increaseContrast;
  final bool largerText;
  final double fontSizeScale;
  final bool voiceControl;
  final bool screenReaderSupport;

  const AccessibilitySettings({
    required this.reduceMotion,
    required this.boldText,
    required this.increaseContrast,
    required this.largerText,
    required this.fontSizeScale,
    required this.voiceControl,
    required this.screenReaderSupport,
  });

  @override
  List<Object?> get props => [
        reduceMotion,
        boldText,
        increaseContrast,
        largerText,
        fontSizeScale,
        voiceControl,
        screenReaderSupport,
      ];
}

/// Daily planner settings
class DailyPlannerSettings extends Equatable {
  final bool enableTimeBlocking;
  final Map<String, bool> timeBlocksVisibility; // morning, work, evening, night
  final bool showCompletedTasks;
  final bool enableTaskDependencies;
  final bool enableRecurringTasks;
  final int defaultTaskDuration; // in minutes
  final bool enableSmartSuggestions;

  const DailyPlannerSettings({
    required this.enableTimeBlocking,
    required this.timeBlocksVisibility,
    required this.showCompletedTasks,
    required this.enableTaskDependencies,
    required this.enableRecurringTasks,
    required this.defaultTaskDuration,
    required this.enableSmartSuggestions,
  });

  @override
  List<Object?> get props => [
        enableTimeBlocking,
        timeBlocksVisibility,
        showCompletedTasks,
        enableTaskDependencies,
        enableRecurringTasks,
        defaultTaskDuration,
        enableSmartSuggestions,
      ];
}

/// Ibadah settings
class IbadahSettings extends Equatable {
  final bool enableKhushuReminders;
  final int prePrayerReminderMinutes;
  final bool enableAdhkarTracking;
  final bool enableQuranReflections;
  final bool enableLectureNotes;
  final List<String> favoriteAdhkar;
  final bool enableDhikrHapticFeedback;

  const IbadahSettings({
    required this.enableKhushuReminders,
    required this.prePrayerReminderMinutes,
    required this.enableAdhkarTracking,
    required this.enableQuranReflections,
    required this.enableLectureNotes,
    required this.favoriteAdhkar,
    required this.enableDhikrHapticFeedback,
  });

  @override
  List<Object?> get props => [
        enableKhushuReminders,
        prePrayerReminderMinutes,
        enableAdhkarTracking,
        enableQuranReflections,
        enableLectureNotes,
        favoriteAdhkar,
        enableDhikrHapticFeedback,
      ];
}

/// Skills settings
class SkillsSettings extends Equatable {
  final bool enableTimeTracking;
  final bool enableResourceTagging;
  final bool enableChallengeDifficultyTracking;
  final bool enableProjectVersioning;
  final List<String> favoriteResources;
  final bool enableCodeSnippetHighlighting;

  const SkillsSettings({
    required this.enableTimeTracking,
    required this.enableResourceTagging,
    required this.enableChallengeDifficultyTracking,
    required this.enableProjectVersioning,
    required this.favoriteResources,
    required this.enableCodeSnippetHighlighting,
  });

  @override
  List<Object?> get props => [
        enableTimeTracking,
        enableResourceTagging,
        enableChallengeDifficultyTracking,
        enableProjectVersioning,
        favoriteResources,
        enableCodeSnippetHighlighting,
      ];
}

/// Self-development settings
class SelfDevelopmentSettings extends Equatable {
  final bool enableGoalTracking;
  final bool enableReflectionReminders;
  final bool enableMindfulnessSessions;
  final bool enableMoodTracking;
  final List<String> favoriteHabits;
  final bool enableHabitStacking;

  const SelfDevelopmentSettings({
    required this.enableGoalTracking,
    required this.enableReflectionReminders,
    required this.enableMindfulnessSessions,
    required this.enableMoodTracking,
    required this.favoriteHabits,
    required this.enableHabitStacking,
  });

  @override
  List<Object?> get props => [
        enableGoalTracking,
        enableReflectionReminders,
        enableMindfulnessSessions,
        enableMoodTracking,
        favoriteHabits,
        enableHabitStacking,
      ];
}