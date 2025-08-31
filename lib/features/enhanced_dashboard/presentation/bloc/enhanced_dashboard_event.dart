part of 'enhanced_dashboard_bloc.dart';

/// Base event class for enhanced dashboard
abstract class EnhancedDashboardEvent {}

/// Event to load dashboard data
class LoadDashboardDataEvent extends EnhancedDashboardEvent {
  const LoadDashboardDataEvent();
}

/// Event to update user name
class UpdateUserNameEvent extends EnhancedDashboardEvent {
  final String name;

  const UpdateUserNameEvent(this.name);
}

/// Event to toggle card visibility
class ToggleCardVisibilityEvent extends EnhancedDashboardEvent {
  final String cardId;
  final bool isVisible;

  const ToggleCardVisibilityEvent(this.cardId, this.isVisible);
}

/// Event to reorder dashboard cards
class ReorderCardsEvent extends EnhancedDashboardEvent {
  final List<String> cardOrder;

  const ReorderCardsEvent(this.cardOrder);
}