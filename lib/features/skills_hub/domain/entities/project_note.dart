import 'package:equatable/equatable.dart';

/// Entity representing a project note
class ProjectNote extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String content;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectNote({
    required this.id,
    required this.projectId,
    required this.title,
    required this.content,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        content,
        version,
        createdAt,
        updatedAt,
      ];

  ProjectNote copyWith({
    String? id,
    String? projectId,
    String? title,
    String? content,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectNote(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      content: content ?? this.content,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}