import 'package:equatable/equatable.dart';

/// Community challenge entity
class CommunityChallenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final int target;
  final String unit;
  final List<ChallengeParticipant> participants;
  final int currentLeaderId;
  final bool isActive;

  const CommunityChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.target,
    required this.unit,
    required this.participants,
    required this.currentLeaderId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        startDate,
        endDate,
        target,
        unit,
        participants,
        currentLeaderId,
        isActive,
  ];

  CommunityChallenge copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    int? target,
    String? unit,
    List<ChallengeParticipant>? participants,
    int? currentLeaderId,
    bool? isActive,
  }) {
    return CommunityChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      target: target ?? this.target,
      unit: unit ?? this.unit,
      participants: participants ?? this.participants,
      currentLeaderId: currentLeaderId ?? this.currentLeaderId,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Participant in a community challenge
class ChallengeParticipant extends Equatable {
  final String userId;
  final String userName;
  final int progress;
  final String avatarUrl;

  const ChallengeParticipant({
    required this.userId,
    required this.userName,
    required this.progress,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [userId, userName, progress, avatarUrl];

  ChallengeParticipant copyWith({
    String? userId,
    String? userName,
    int? progress,
    String? avatarUrl,
  }) {
    return ChallengeParticipant(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      progress: progress ?? this.progress,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}