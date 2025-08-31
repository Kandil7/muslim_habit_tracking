import 'package:muslim_habbit/features/self_development_hub/domain/entities/reflection_entry.dart';
import 'package:muslim_habbit/features/self_development_hub/domain/repositories/reflection_repository.dart';

/// Use case to add a new reflection entry
class AddReflectionEntry {
  final ReflectionRepository repository;

  AddReflectionEntry(this.repository);

  /// Add a new reflection entry
  Future<ReflectionEntry> call(ReflectionEntry entry) async {
    return await repository.addReflectionEntry(entry);
  }
}