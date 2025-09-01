import 'package:muslim_habbit/features/ibadah_hub/domain/entities/adhkar.dart';
import 'package:muslim_habbit/features/ibadah_hub/domain/repositories/adhkar_repository.dart';

/// Use case to update Adhkar count
class UpdateAdhkarCount {
  final AdhkarRepository repository;

  UpdateAdhkarCount(this.repository);

  /// Update the count for a specific Adhkar
  Future<Adhkar> call(String id, int count) async {
    return await repository.updateAdhkarCount(id, count);
  }
}