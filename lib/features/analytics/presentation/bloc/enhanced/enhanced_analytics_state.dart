part of 'enhanced_analytics_bloc.dart';

/// Base state class for enhanced analytics
abstract class EnhancedAnalyticsState {}

/// Initial state
class EnhancedAnalyticsInitial extends EnhancedAnalyticsState {}

/// Loading state
class EnhancedAnalyticsLoading extends EnhancedAnalyticsState {}

/// Loaded state with overall statistics
class EnhancedAnalyticsLoaded extends EnhancedAnalyticsState {
  final OverallStats stats;
  final List<String> insights;

  EnhancedAnalyticsLoaded({required this.stats, required this.insights});
}

/// Error state
class EnhancedAnalyticsError extends EnhancedAnalyticsState {
  final String message;

  EnhancedAnalyticsError({required this.message});
}

/// Export success state
class EnhancedAnalyticsExportSuccess extends EnhancedAnalyticsState {
  final String filePath;

  EnhancedAnalyticsExportSuccess({required this.filePath});
}

/// Export error state
class EnhancedAnalyticsExportError extends EnhancedAnalyticsState {
  final String message;

  EnhancedAnalyticsExportError({required this.message});
}