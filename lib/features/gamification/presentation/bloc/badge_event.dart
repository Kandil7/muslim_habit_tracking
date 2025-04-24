import 'package:equatable/equatable.dart';

/// Events for the Badge BLoC
abstract class BadgeEvent extends Equatable {
  const BadgeEvent();

  @override
  List<Object> get props => [];
}

/// Event to load all badges
class LoadAllBadgesEvent extends BadgeEvent {}

/// Event to load badges by category
class LoadBadgesByCategoryEvent extends BadgeEvent {
  final String category;

  const LoadBadgesByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

/// Event to load earned badges
class LoadEarnedBadgesEvent extends BadgeEvent {}

/// Event to check badge requirements
class CheckBadgeRequirementsEvent extends BadgeEvent {
  final String badgeId;
  final Map<String, dynamic> userStats;

  const CheckBadgeRequirementsEvent({
    required this.badgeId,
    required this.userStats,
  });

  @override
  List<Object> get props => [badgeId, userStats];
}

/// Event to award a badge
class AwardBadgeEvent extends BadgeEvent {
  final String badgeId;

  const AwardBadgeEvent({required this.badgeId});

  @override
  List<Object> get props => [badgeId];
}

/// Event to check all badges against user stats
class CheckAllBadgesEvent extends BadgeEvent {
  final Map<String, dynamic> userStats;

  const CheckAllBadgesEvent({required this.userStats});

  @override
  List<Object> get props => [userStats];
}
