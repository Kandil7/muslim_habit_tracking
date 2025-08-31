part of 'enhanced_analytics_bloc.dart';

/// Base event class for enhanced analytics
abstract class EnhancedAnalyticsEvent {}

/// Event to load overall statistics
class LoadOverallStats extends EnhancedAnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadOverallStats({required this.startDate, required this.endDate});
}

/// Event to export analytics data
class ExportAnalyticsData extends EnhancedAnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String format;

  ExportAnalyticsData({
    required this.startDate,
    required this.endDate,
    required this.format,
  });
}

/// Event to get personalized insights
class LoadPersonalizedInsights extends EnhancedAnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadPersonalizedInsights({required this.startDate, required this.endDate});
}