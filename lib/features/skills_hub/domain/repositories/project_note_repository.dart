import 'package:muslim_habbit/features/skills_hub/domain/entities/project_note.dart';

/// Repository interface for project note management
abstract class ProjectNoteRepository {
  /// Add a new project note
  Future<ProjectNote> addProjectNote(ProjectNote note);

  /// Get project notes for a project
  Future<List<ProjectNote>> getNotesForProject(String projectId);

  /// Get project note by ID
  Future<ProjectNote?> getNoteById(String id);

  /// Update project note
  Future<ProjectNote> updateProjectNote(ProjectNote note);

  /// Delete project note
  Future<void> deleteProjectNote(String id);

  /// Get all project notes
  Future<List<ProjectNote>> getAllProjectNotes();

  /// Search project notes by query
  Future<List<ProjectNote>> searchProjectNotes(String query);
}