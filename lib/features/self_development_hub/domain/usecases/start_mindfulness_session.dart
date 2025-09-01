import 'package:muslim_habbit/features/self_development_hub/domain/entities/mindfulness_session.dart';
import 'package:muslim_habbit/features/self_development_hub/domain/repositories/mindfulness_repository.dart';

/// Use case to start a new mindfulness session
class StartMindfulnessSession {
  final MindfulnessRepository repository;

  StartMindfulnessSession(this.repository);

  /// Start a new mindfulness session
  Future<MindfulnessSession> call(MindfulnessSession session) async {
    return await repository.startSession(session);
  }
}