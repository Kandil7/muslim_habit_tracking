part of 'enhanced_settings_bloc.dart';

/// Base event class for enhanced settings
abstract class EnhancedSettingsEvent {}

/// Event to load user preferences
class LoadUserPreferences extends EnhancedSettingsEvent {}

/// Event to update user preferences
class UpdateUserPreferences extends EnhancedSettingsEvent {
  final UserPreferences preferences;

  UpdateUserPreferences({required this.preferences});
}

/// Event to reset settings to default
class ResetToDefaultSettings extends EnhancedSettingsEvent {}

/// Event to export settings
class ExportSettings extends EnhancedSettingsEvent {}

/// Event to import settings
class ImportSettings extends EnhancedSettingsEvent {
  final String settingsData;

  ImportSettings({required this.settingsData});
}