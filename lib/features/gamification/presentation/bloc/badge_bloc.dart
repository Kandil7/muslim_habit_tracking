import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/award_badge.dart';
import '../../domain/usecases/check_badge_requirements.dart';
import '../../domain/usecases/get_all_badges.dart';
import '../../domain/usecases/get_badges_by_category.dart';
import '../../domain/usecases/get_earned_badges.dart';
import 'badge_event.dart';
import 'badge_state.dart';

/// BLoC for managing the Badge feature state
class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final GetAllBadges getAllBadges;
  final GetBadgesByCategory getBadgesByCategory;
  final GetEarnedBadges getEarnedBadges;
  final CheckBadgeRequirements checkBadgeRequirements;
  final AwardBadge awardBadge;

  /// Creates a new BadgeBloc
  BadgeBloc({
    required this.getAllBadges,
    required this.getBadgesByCategory,
    required this.getEarnedBadges,
    required this.checkBadgeRequirements,
    required this.awardBadge,
  }) : super(BadgeInitial()) {
    on<LoadAllBadgesEvent>(_onLoadAllBadges);
    on<LoadBadgesByCategoryEvent>(_onLoadBadgesByCategory);
    on<LoadEarnedBadgesEvent>(_onLoadEarnedBadges);
    on<CheckBadgeRequirementsEvent>(_onCheckBadgeRequirements);
    on<AwardBadgeEvent>(_onAwardBadge);
    on<CheckAllBadgesEvent>(_onCheckAllBadges);
  }

  /// Handle LoadAllBadgesEvent
  Future<void> _onLoadAllBadges(
    LoadAllBadgesEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    final result = await getAllBadges(NoParams());
    result.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (badges) => emit(BadgesLoaded(badges: badges)),
    );
  }

  /// Handle LoadBadgesByCategoryEvent
  Future<void> _onLoadBadgesByCategory(
    LoadBadgesByCategoryEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    final result = await getBadgesByCategory(
      GetBadgesByCategoryParams(category: event.category),
    );
    result.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (badges) => emit(BadgesByCategoryLoaded(
        badges: badges,
        category: event.category,
      )),
    );
  }

  /// Handle LoadEarnedBadgesEvent
  Future<void> _onLoadEarnedBadges(
    LoadEarnedBadgesEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    final result = await getEarnedBadges(NoParams());
    result.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (badges) => emit(EarnedBadgesLoaded(badges: badges)),
    );
  }

  /// Handle CheckBadgeRequirementsEvent
  Future<void> _onCheckBadgeRequirements(
    CheckBadgeRequirementsEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    final result = await checkBadgeRequirements(
      CheckBadgeRequirementsParams(
        badgeId: event.badgeId,
        userStats: event.userStats,
      ),
    );
    result.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (isAwarded) => emit(BadgeRequirementsChecked(
        badgeId: event.badgeId,
        isAwarded: isAwarded,
      )),
    );
  }

  /// Handle AwardBadgeEvent
  Future<void> _onAwardBadge(
    AwardBadgeEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    final result = await awardBadge(
      AwardBadgeParams(badgeId: event.badgeId),
    );
    result.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (badge) => emit(BadgeAwarded(badge: badge)),
    );
  }

  /// Handle CheckAllBadgesEvent
  Future<void> _onCheckAllBadges(
    CheckAllBadgesEvent event,
    Emitter<BadgeState> emit,
  ) async {
    emit(BadgeLoading());
    
    // Get all badges
    final badgesResult = await getAllBadges(NoParams());
    
    return badgesResult.fold(
      (failure) => emit(BadgeError(message: failure.message)),
      (badges) async {
        final awardedBadges = [];
        
        // Check each badge
        for (final badge in badges) {
          // Skip already earned badges
          if (badge.isEarned) continue;
          
          // Check requirements
          final requirementsResult = await checkBadgeRequirements(
            CheckBadgeRequirementsParams(
              badgeId: badge.id,
              userStats: event.userStats,
            ),
          );
          
          await requirementsResult.fold(
            (failure) => null, // Skip on failure
            (isAwarded) async {
              if (isAwarded) {
                // Award the badge
                final awardResult = await awardBadge(
                  AwardBadgeParams(badgeId: badge.id),
                );
                
                awardResult.fold(
                  (failure) => null, // Skip on failure
                  (awardedBadge) => awardedBadges.add(awardedBadge),
                );
              }
            },
          );
        }
        
        emit(AllBadgesChecked(awardedBadges: awardedBadges));
      },
    );
  }
}
