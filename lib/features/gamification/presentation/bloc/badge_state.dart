import 'package:equatable/equatable.dart';

import '../../domain/entities/badge.dart';

/// States for the Badge BLoC
abstract class BadgeState extends Equatable {
  const BadgeState();

  @override
  List<Object> get props => [];
}

/// Initial state
class BadgeInitial extends BadgeState {}

/// Loading state
class BadgeLoading extends BadgeState {}

/// State when badges are loaded
class BadgesLoaded extends BadgeState {
  final List<Badge> badges;

  const BadgesLoaded({required this.badges});

  @override
  List<Object> get props => [badges];
}

/// State when badges are loaded by category
class BadgesByCategoryLoaded extends BadgeState {
  final List<Badge> badges;
  final String category;

  const BadgesByCategoryLoaded({
    required this.badges,
    required this.category,
  });

  @override
  List<Object> get props => [badges, category];
}

/// State when earned badges are loaded
class EarnedBadgesLoaded extends BadgeState {
  final List<Badge> badges;

  const EarnedBadgesLoaded({required this.badges});

  @override
  List<Object> get props => [badges];
}

/// State when a badge is awarded
class BadgeAwarded extends BadgeState {
  final Badge badge;

  const BadgeAwarded({required this.badge});

  @override
  List<Object> get props => [badge];
}

/// State when badge requirements are checked
class BadgeRequirementsChecked extends BadgeState {
  final String badgeId;
  final bool isAwarded;

  const BadgeRequirementsChecked({
    required this.badgeId,
    required this.isAwarded,
  });

  @override
  List<Object> get props => [badgeId, isAwarded];
}

/// State when all badges are checked
class AllBadgesChecked extends BadgeState {
  final List<Badge> awardedBadges;

  const AllBadgesChecked({required this.awardedBadges});

  @override
  List<Object> get props => [awardedBadges];
}

/// Error state
class BadgeError extends BadgeState {
  final String message;

  const BadgeError({required this.message});

  @override
  List<Object> get props => [message];
}
