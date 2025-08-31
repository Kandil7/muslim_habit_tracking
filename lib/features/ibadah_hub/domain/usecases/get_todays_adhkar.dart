import 'package:muslim_habbit/features/ibadah_hub/domain/entities/adhkar.dart';
import 'package:muslim_habbit/features/ibadah_hub/domain/repositories/adhkar_repository.dart';

/// Use case to get today's Adhkar
class GetTodaysAdhkar {
  final AdhkarRepository repository;

  GetTodaysAdhkar(this.repository);

  /// Get all Adhkar for today
  Future<List<Adhkar>> call() async {
    return await repository.getTodaysAdhkar();
  }
}