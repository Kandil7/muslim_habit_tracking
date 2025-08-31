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
  final GetUserPreferences getUserPreferencesUseCase;
  final UpdateUserPreferences updateUserPreferencesUseCase;
  final ResetToDefaultSettings resetToDefaultSettingsUseCase;

  EnhancedSettingsBloc({
    required GetUserPreferences getUserPreferences,
    required UpdateUserPreferences updateUserPreferences,
    required ResetToDefaultSettings resetToDefaultSettings,
  }) : getUserPreferencesUseCase = getUserPreferences,
       updateUserPreferencesUseCase = updateUserPreferences,
       resetToDefaultSettingsUseCase = resetToDefaultSettings,
       super(EnhancedSettingsInitial()) {
    on<LoadUserPreferences>(_onLoadUserPreferences);
    on<UpdateUserPreferences>(_onUpdateUserPreferences);
    on<ResetToDefaultSettings>(_onResetToDefaultSettings);
    on<ExportSettings>(_onExportSettings);
    on<ImportSettings>(_onImportSettings);
  }

  /// Handle loading user preferences
  Future<void> _onLoadUserPreferences(
    LoadUserPreferences loadEvent,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final preferencesEither = await (getUserPreferencesUseCase as dynamic)();

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
    UpdateUserPreferences updateEvent,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final preferencesEither = await (updateUserPreferencesUseCase as dynamic)(updateEvent.preferences);

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
    ResetToDefaultSettings resetEvent,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    emit(EnhancedSettingsLoading());
    try {
      final resetEither = await (resetToDefaultSettingsUseCase as dynamic)();

      await resetEither.fold(
        (failure) async {
          emit(EnhancedSettingsResetError(
              message: 'Failed to reset settings: ${failure.toString()}'));
        },
        (success) async {
          if (success) {
            // Reload preferences after reset
            final preferencesEither = await (getUserPreferencesUseCase as dynamic)();
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
    ExportSettings exportEvent,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    // Implementation would export settings to a file
    emit(EnhancedSettingsError(
        message: 'Export functionality not implemented yet'));
  }

  /// Handle importing settings
  Future<void> _onImportSettings(
    ImportSettings importEvent,
    Emitter<EnhancedSettingsState> emit,
  ) async {
    // Implementation would import settings from a file
    emit(EnhancedSettingsError(
        message: 'Import functionality not implemented yet'));
  }
}