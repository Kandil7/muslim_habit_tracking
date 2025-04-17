import 'package:equatable/equatable.dart';
import '../../domain/models/quick_action_model.dart';

/// Base class for home dashboard events
abstract class HomeDashboardEvent extends Equatable {
  const HomeDashboardEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load the home dashboard
class LoadHomeDashboardEvent extends HomeDashboardEvent {
  const LoadHomeDashboardEvent();
}

/// Event to update the user's name
class UpdateUserNameEvent extends HomeDashboardEvent {
  final String userName;
  
  const UpdateUserNameEvent({required this.userName});
  
  @override
  List<Object?> get props => [userName];
}

/// Event to reorder dashboard cards
class ReorderDashboardCardsEvent extends HomeDashboardEvent {
  final List<String> newOrder;
  
  const ReorderDashboardCardsEvent({required this.newOrder});
  
  @override
  List<Object?> get props => [newOrder];
}

/// Event to toggle card visibility
class ToggleCardVisibilityEvent extends HomeDashboardEvent {
  final String cardId;
  final bool isVisible;
  
  const ToggleCardVisibilityEvent({
    required this.cardId,
    required this.isVisible,
  });
  
  @override
  List<Object?> get props => [cardId, isVisible];
}

/// Event to update quick actions
class UpdateQuickActionsEvent extends HomeDashboardEvent {
  final List<QuickActionModel> quickActions;
  
  const UpdateQuickActionsEvent({required this.quickActions});
  
  @override
  List<Object?> get props => [quickActions];
}
