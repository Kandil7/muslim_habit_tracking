import 'package:equatable/equatable.dart';
import '../../domain/models/dashboard_card_model.dart';
import '../../domain/models/quick_action_model.dart';

/// Base class for home dashboard states
abstract class HomeDashboardState extends Equatable {
  const HomeDashboardState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeDashboardInitial extends HomeDashboardState {}

/// Loading state
class HomeDashboardLoading extends HomeDashboardState {}

/// Loaded state
class HomeDashboardLoaded extends HomeDashboardState {
  final String userName;
  final List<DashboardCardModel> dashboardCards;
  final List<QuickActionModel> quickActions;
  
  const HomeDashboardLoaded({
    required this.userName,
    required this.dashboardCards,
    required this.quickActions,
  });
  
  @override
  List<Object?> get props => [userName, dashboardCards, quickActions];
}

/// Error state
class HomeDashboardError extends HomeDashboardState {
  final String message;
  
  const HomeDashboardError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
