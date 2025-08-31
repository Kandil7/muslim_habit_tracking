import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/settings/domain/entities/enhanced/user_preferences.dart';
import 'package:muslim_habbit/features/settings/domain/usecases/enhanced/get_user_preferences.dart';
import 'package:muslim_habbit/features/settings/domain/usecases/enhanced/reset_to_default_settings.dart';
import 'package:muslim_habbit/features/settings/domain/usecases/enhanced/update_user_preferences.dart';

part 'enhanced_settings_event.dart';
part 'enhanced_settings_state.dart';

/// BLoC for managing enhanced settings state
class EnhancedSettingsBloc
    extends Bloc<EnhancedSettingsEvent, EnhancedSettingsState> {
  final GetUserPreferences getUserPreferences;
  final UpdateUserPreferences updateUserPreferences;
  final ResetToDefaultSettings resetToDefaultSettings;

  EnhancedSettingsBloc({
    required this.getUserPreferences,
    required this.updateUserPreferences,
    required this.resetToDefaultSettings,
  }) : super(EnhancedSettingsInitial()) {
    on<LoadUserPreferences>(_onLoadUserPreferences);
    on<UpdateUserPreferences>(_onUpdateUserPreferences);
    on<ResetToDefaultSettings>(_onResetToDefaultSettings);
    on<ExportSettings>(_onExportSettings);
    on<ImportSettings>(_onImportSettings);
  }

  /// Handle loading user preferences
  Future<void> _onLoadUserPreferences(
    LoadUserPreferences event,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final preferencesEither = await getUserPreferences();

      await preferencesEither.fold(
        (failure) async {
          emit(EnhancedSettingsError(
              message: 'Failed to load preferences: ${failure.toString()}'));
        },
        (preferences) async {
          emit(EnhancedSettingsLoaded(preferences: preferences));
        },
      );
    } catch (e) {
      emit(EnhancedSettingsError(message: e.toString()));
    }
  }

  /// Handle updating user preferences
  Future<void> _onUpdateUserPreferences(
    UpdateUserPreferences event,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final preferencesEither = await updateUserPreferences(event.preferences);

      await preferencesEither.fold(
        (failure) async {
          emit(EnhancedSettingsError(
              message: 'Failed to update preferences: ${failure.toString()}'));
        },
        (preferences) async {
          emit(EnhancedSettingsLoaded(preferences: preferences));
        },
      );
    } catch (e) {
      emit(EnhancedSettingsError(message: e.toString()));
    }
  }

  /// Handle resetting to default settings
  Future<void> _onResetToDefaultSettings(
    ResetToDefaultSettings event,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final resetEither = await resetToDefaultSettings();

      await resetEither.fold(
        (failure) async {
          emit(EnhancedSettingsResetError(
              message: 'Failed to reset settings: ${failure.toString()}'));
        },
        (success) async {
          if (success) {
            // Reload preferences after reset
            final preferencesEither = await getUserPreferences();
            await preferencesEither.fold(
              (failure) async {
                emit(EnhancedSettingsResetError(
                    message: 'Failed to load preferences after reset: ${failure.toString()}'));
              },
              (preferences) async {
                emit(EnhancedSettingsResetSuccess());
              },
            );
          } else {
            emit(EnhancedSettingsResetError(
                message: 'Failed to reset settings'));
          }
        },
      );
    } catch (e) {
      emit(EnhancedSettingsResetError(message: e.toString()));
    }
  }

  /// Handle exporting settings
  Future<void> _onExportSettings(
    ExportSettings event,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    // Implementation would export settings to a file
    emit(EnhancedSettingsError(
        message: 'Export functionality not implemented yet'));
  }

  /// Handle importing settings
  Future<void> _onImportSettings(
    ImportSettings event,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    // Implementation would import settings from a file
    emit(EnhancedSettingsError(
        message: 'Import functionality not implemented yet'));
  }
}