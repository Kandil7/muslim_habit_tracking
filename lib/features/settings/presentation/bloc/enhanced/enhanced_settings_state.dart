part of 'enhanced_settings_bloc.dart';

/// Base state class for enhanced settings
abstract class EnhancedSettingsState {}

/// Initial state
class EnhancedSettingsInitial extends EnhancedSettingsState {}

/// Loading state
class EnhancedSettingsLoading extends EnhancedSettingsState {}

/// Loaded state with user preferences
class EnhancedSettingsLoaded extends EnhancedSettingsState {
  final UserPreferences preferences;

  EnhancedSettingsLoaded({required this.preferences});
}

/// Error state
class EnhancedSettingsError extends EnhancedSettingsState {
  final String message;

  EnhancedSettingsError({required this.message});
}

/// Export success state
class EnhancedSettingsExportSuccess extends EnhancedSettingsState {
  final String filePath;

  EnhancedSettingsExportSuccess({required this.filePath});
}

/// Export error state
class EnhancedSettingsExportError extends EnhancedSettingsState {
  final String message;

  EnhancedSettingsExportError({required this.message});
}

/// Import success state
class EnhancedSettingsImportSuccess extends EnhancedSettingsState {}

/// Import error state
class EnhancedSettingsImportError extends EnhancedSettingsState {
  final String message;

  EnhancedSettingsImportError({required this.message});
}

/// Reset success state
class EnhancedSettingsResetSuccess extends EnhancedSettingsState {}

/// Reset error state
class EnhancedSettingsResetError extends EnhancedSettingsState {
  final String message;

  EnhancedSettingsResetError({required this.message});
}