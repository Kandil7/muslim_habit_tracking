import 'package:equatable/equatable.dart';

/// Events for the UnlockableContent BLoC
abstract class UnlockableContentEvent extends Equatable {
  const UnlockableContentEvent();

  @override
  List<Object> get props => [];
}

/// Event to load all unlockable content
class LoadAllContentEvent extends UnlockableContentEvent {}

/// Event to load unlockable content by type
class LoadContentByTypeEvent extends UnlockableContentEvent {
  final String contentType;

  const LoadContentByTypeEvent({required this.contentType});

  @override
  List<Object> get props => [contentType];
}

/// Event to load unlocked content
class LoadUnlockedContentEvent extends UnlockableContentEvent {}

/// Event to unlock content
class UnlockContentEvent extends UnlockableContentEvent {
  final String contentId;

  const UnlockContentEvent({required this.contentId});

  @override
  List<Object> get props => [contentId];
}

/// Event to check if content can be unlocked
class CheckCanUnlockContentEvent extends UnlockableContentEvent {
  final String contentId;

  const CheckCanUnlockContentEvent({required this.contentId});

  @override
  List<Object> get props => [contentId];
}
