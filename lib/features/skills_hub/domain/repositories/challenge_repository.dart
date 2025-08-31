import 'package:muslim_habbit/features/skills_hub/domain/entities/challenge.dart';

/// Repository interface for challenge management
abstract class ChallengeRepository {
  /// Add a new challenge
  Future<Challenge> addChallenge(Challenge challenge);

  /// Get all challenges
  Future<List<Challenge>> getAllChallenges();

  /// Get challenge by ID
  Future<Challenge?> getChallengeById(String id);

  /// Update challenge
  Future<Challenge> updateChallenge(Challenge challenge);

  /// Delete challenge
  Future<void> deleteChallenge(String id);

  /// Get challenges by platform
  Future<List<Challenge>> getChallengesByPlatform(String platform);

  /// Get challenges by difficulty
  Future<List<Challenge>> getChallengesByDifficulty(ChallengeDifficulty difficulty);

  /// Get completed challenges
  Future<List<Challenge>> getCompletedChallenges();

  /// Get challenge statistics
  Future<ChallengeStatistics> getChallengeStatistics();
}

/// Class to hold challenge statistics
class ChallengeStatistics {
  final int totalChallenges;
  final int completedChallenges;
  final Map<ChallengeDifficulty, int> challengesByDifficulty;
  final Map<String, int> challengesByPlatform;
  final double successRate;
  final Duration averageTimeTaken;

  ChallengeStatistics({
    required this.totalChallenges,
    required this.completedChallenges,
    required this.challengesByDifficulty,
    required this.challengesByPlatform,
    required this.successRate,
    required this.averageTimeTaken,
  });
}