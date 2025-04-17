import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/add_reading_history.dart';
import '../../domain/usecases/get_all_surahs.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/get_last_read_position.dart';
import '../../domain/usecases/get_reading_history.dart';
import '../../domain/usecases/get_surah_by_id.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/update_last_read_position.dart' as domain;
import 'quran_event.dart';
import 'quran_state.dart';

/// BLoC for Quran feature
class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetAllSurahs getAllSurahs;
  final GetSurahById getSurahById;
  final GetBookmarks getBookmarks;
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;
  final GetReadingHistory getReadingHistory;
  final AddReadingHistory addReadingHistory;
  final GetLastReadPosition getLastReadPosition;
  final domain.UpdateLastReadPosition updateLastReadPosition;

  QuranBloc({
    required this.getAllSurahs,
    required this.getSurahById,
    required this.getBookmarks,
    required this.addBookmark,
    required this.removeBookmark,
    required this.getReadingHistory,
    required this.addReadingHistory,
    required this.getLastReadPosition,
    required this.updateLastReadPosition,
  }) : super(const QuranInitial()) {
    on<LoadSurahs>(_onLoadSurahs);
    on<LoadSurah>(_onLoadSurah);
    on<LoadBookmarks>(_onLoadBookmarks);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<LoadReadingHistory>(_onLoadReadingHistory);
    on<AddReadingHistoryEvent>(_onAddReadingHistory);
    on<ClearReadingHistory>(_onClearReadingHistory);
    on<LoadLastReadPosition>(_onLoadLastReadPosition);
    on<UpdateLastReadPosition>(_onUpdateLastReadPosition);
  }

  /// Handle LoadSurahs event
  Future<void> _onLoadSurahs(LoadSurahs event, Emitter<QuranState> emit) async {
    emit(const QuranLoading());
    final result = await getAllSurahs(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (surahs) => emit(SurahsLoaded(surahs: surahs)),
    );
  }

  /// Handle LoadSurah event
  Future<void> _onLoadSurah(LoadSurah event, Emitter<QuranState> emit) async {
    emit(const QuranLoading());
    final result = await getSurahById(SurahParams(id: event.surahId));
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (surah) => emit(SurahLoaded(surah: surah)),
    );
  }

  /// Handle LoadBookmarks event
  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await getBookmarks(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (bookmarks) => emit(BookmarksLoaded(bookmarks: bookmarks)),
    );
  }

  /// Handle AddBookmarkEvent event
  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await addBookmark(BookmarkParams(bookmark: event.bookmark));
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (bookmark) => emit(BookmarkAdded(bookmark: bookmark)),
    );
  }

  /// Handle RemoveBookmarkEvent event
  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await removeBookmark(
      RemoveBookmarkParams(bookmarkId: event.bookmarkId),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (success) =>
          success
              ? emit(BookmarkRemoved(bookmarkId: event.bookmarkId))
              : emit(const QuranError(message: 'Failed to remove bookmark')),
    );
  }

  /// Handle LoadReadingHistory event
  Future<void> _onLoadReadingHistory(
    LoadReadingHistory event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await getReadingHistory(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (history) => emit(ReadingHistoryLoaded(history: history)),
    );
  }

  /// Handle AddReadingHistoryEvent event
  Future<void> _onAddReadingHistory(
    AddReadingHistoryEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await addReadingHistory(
      ReadingHistoryParams(history: event.history),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (history) => emit(ReadingHistoryAdded(history: history)),
    );
  }

  /// Handle ClearReadingHistory event
  Future<void> _onClearReadingHistory(
    ClearReadingHistory event,
    Emitter<QuranState> emit,
  ) async {
    // Not implemented yet
    emit(const QuranError(message: 'Clear reading history not implemented'));
  }

  /// Handle LoadLastReadPosition event
  Future<void> _onLoadLastReadPosition(
    LoadLastReadPosition event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await getLastReadPosition(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (position) => emit(LastReadPositionLoaded(position: position)),
    );
  }

  /// Handle UpdateLastReadPosition event
  Future<void> _onUpdateLastReadPosition(
    UpdateLastReadPosition event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await updateLastReadPosition(
      domain.LastReadPositionParams(history: event.history),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (success) =>
          success
              ? emit(LastReadPositionUpdated(history: event.history))
              : emit(
                const QuranError(
                  message: 'Failed to update last read position',
                ),
              ),
    );
  }
}
