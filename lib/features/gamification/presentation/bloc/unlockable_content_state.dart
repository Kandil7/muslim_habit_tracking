import 'package:equatable/equatable.dart';

import '../../domain/entities/unlockable_content.dart';

/// States for the UnlockableContent BLoC
abstract class UnlockableContentState extends Equatable {
  const UnlockableContentState();

  @override
  List<Object> get props => [];
}

/// Initial state
class UnlockableContentInitial extends UnlockableContentState {}

/// Loading state
class UnlockableContentLoading extends UnlockableContentState {}

/// State when all content is loaded
class AllContentLoaded extends UnlockableContentState {
  final List<UnlockableContent> content;

  const AllContentLoaded({required this.content});

  @override
  List<Object> get props => [content];
}

/// State when content by type is loaded
class ContentByTypeLoaded extends UnlockableContentState {
  final List<UnlockableContent> content;
  final String contentType;

  const ContentByTypeLoaded({
    required this.content,
    required this.contentType,
  });

  @override
  List<Object> get props => [content, contentType];
}

/// State when unlocked content is loaded
class UnlockedContentLoaded extends UnlockableContentState {
  final List<UnlockableContent> content;

  const UnlockedContentLoaded({required this.content});

  @override
  List<Object> get props => [content];
}

/// State when content is unlocked
class ContentUnlocked extends UnlockableContentState {
  final UnlockableContent content;

  const ContentUnlocked({required this.content});

  @override
  List<Object> get props => [content];
}

/// State when checking if content can be unlocked
class CanUnlockContent extends UnlockableContentState {
  final String contentId;
  final bool canUnlock;

  const CanUnlockContent({
    required this.contentId,
    required this.canUnlock,
  });

  @override
  List<Object> get props => [contentId, canUnlock];
}

/// Error state
class UnlockableContentError extends UnlockableContentState {
  final String message;

  const UnlockableContentError({required this.message});

  @override
  List<Object> get props => [message];
}
