import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_unlockable_content.dart';
import '../../domain/usecases/unlock_content.dart';
import 'unlockable_content_event.dart';
import 'unlockable_content_state.dart';

/// BLoC for managing the UnlockableContent feature state
class UnlockableContentBloc extends Bloc<UnlockableContentEvent, UnlockableContentState> {
  final GetUnlockableContent getUnlockableContent;
  final UnlockContent unlockContent;

  /// Creates a new UnlockableContentBloc
  UnlockableContentBloc({
    required this.getUnlockableContent,
    required this.unlockContent,
  }) : super(UnlockableContentInitial()) {
    on<LoadAllContentEvent>(_onLoadAllContent);
    on<LoadContentByTypeEvent>(_onLoadContentByType);
    on<LoadUnlockedContentEvent>(_onLoadUnlockedContent);
    on<UnlockContentEvent>(_onUnlockContent);
    on<CheckCanUnlockContentEvent>(_onCheckCanUnlockContent);
  }

  /// Handle LoadAllContentEvent
  Future<void> _onLoadAllContent(
    LoadAllContentEvent event,
    Emitter<UnlockableContentState> emit,
  ) async {
    emit(UnlockableContentLoading());
    final result = await getUnlockableContent(NoParams());
    result.fold(
      (failure) => emit(UnlockableContentError(message: failure.message)),
      (content) => emit(AllContentLoaded(content: content)),
    );
  }

  /// Handle LoadContentByTypeEvent
  Future<void> _onLoadContentByType(
    LoadContentByTypeEvent event,
    Emitter<UnlockableContentState> emit,
  ) async {
    emit(UnlockableContentLoading());
    final result = await getUnlockableContent(NoParams());
    result.fold(
      (failure) => emit(UnlockableContentError(message: failure.message)),
      (allContent) {
        final filteredContent = allContent
            .where((content) => content.contentType == event.contentType)
            .toList();
        emit(ContentByTypeLoaded(
          content: filteredContent,
          contentType: event.contentType,
        ));
      },
    );
  }

  /// Handle LoadUnlockedContentEvent
  Future<void> _onLoadUnlockedContent(
    LoadUnlockedContentEvent event,
    Emitter<UnlockableContentState> emit,
  ) async {
    emit(UnlockableContentLoading());
    final result = await getUnlockableContent(NoParams());
    result.fold(
      (failure) => emit(UnlockableContentError(message: failure.message)),
      (allContent) {
        final unlockedContent = allContent
            .where((content) => content.isUnlocked)
            .toList();
        emit(UnlockedContentLoaded(content: unlockedContent));
      },
    );
  }

  /// Handle UnlockContentEvent
  Future<void> _onUnlockContent(
    UnlockContentEvent event,
    Emitter<UnlockableContentState> emit,
  ) async {
    emit(UnlockableContentLoading());
    final result = await unlockContent(
      UnlockContentParams(contentId: event.contentId),
    );
    result.fold(
      (failure) => emit(UnlockableContentError(message: failure.message)),
      (content) => emit(ContentUnlocked(content: content)),
    );
  }

  /// Handle CheckCanUnlockContentEvent
  Future<void> _onCheckCanUnlockContent(
    CheckCanUnlockContentEvent event,
    Emitter<UnlockableContentState> emit,
  ) async {
    emit(UnlockableContentLoading());
    // Get all content
    final result = await getUnlockableContent(NoParams());
    result.fold(
      (failure) => emit(UnlockableContentError(message: failure.message)),
      (allContent) {
        // Find the content by ID
        final content = allContent.firstWhere(
          (content) => content.id == event.contentId,
          orElse: () => throw Exception('Content not found'),
        );
        
        // Check if already unlocked
        if (content.isUnlocked) {
          emit(const CanUnlockContent(
            contentId: '',
            canUnlock: true,
          ));
          return;
        }
        
        // TODO: Check if user has enough points
        // For now, just return true
        emit(CanUnlockContent(
          contentId: event.contentId,
          canUnlock: true,
        ));
      },
    );
  }
}
