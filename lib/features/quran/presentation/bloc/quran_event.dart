import 'package:equatable/equatable.dart';

import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/quran_reading_history.dart';

/// Base class for all Quran events
abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get all surahs
class GetAllSurahsEvent extends QuranEvent {
  const GetAllSurahsEvent();
}

/// Event to get a surah by ID
class GetSurahByIdEvent extends QuranEvent {
  final int surahId;

  const GetSurahByIdEvent({required this.surahId});

  @override
  List<Object?> get props => [surahId];
}

/// Event to get all bookmarks
class GetBookmarksEvent extends QuranEvent {
  const GetBookmarksEvent();
}

/// Event to add a bookmark
class AddBookmarkEvent extends QuranEvent {
  final QuranBookmark bookmark;

  const AddBookmarkEvent({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// Event to update a bookmark
class UpdateBookmarkEvent extends QuranEvent {
  final QuranBookmark bookmark;

  const UpdateBookmarkEvent({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// Event to remove a bookmark
class RemoveBookmarkEvent extends QuranEvent {
  final int id;

  const RemoveBookmarkEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to get reading history
class GetReadingHistoryEvent extends QuranEvent {
  const GetReadingHistoryEvent();
}

/// Event to add reading history
class AddReadingHistoryEvent extends QuranEvent {
  final QuranReadingHistory history;

  const AddReadingHistoryEvent({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Event to clear reading history
class ClearReadingHistoryEvent extends QuranEvent {
  const ClearReadingHistoryEvent();
}

/// Event to get last read position
class GetLastReadPositionEvent extends QuranEvent {
  const GetLastReadPositionEvent();
}

/// Event to update last read position
class UpdateLastReadPositionEvent extends QuranEvent {
  final QuranReadingHistory history;

  const UpdateLastReadPositionEvent({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Event to initialize the page controller
class InitQuranPageControllerEvent extends QuranEvent {
  final int initialPage;

  const InitQuranPageControllerEvent({required this.initialPage});

  @override
  List<Object?> get props => [initialPage];
}

/// Event to toggle the view state
class ToggleQuranViewStateEvent extends QuranEvent {
  const ToggleQuranViewStateEvent();
}

/// Event to reset the view state
class ResetQuranViewStateEvent extends QuranEvent {
  const ResetQuranViewStateEvent();
}

/// Event to save a marker
class SaveQuranMarkerEvent extends QuranEvent {
  final int position;

  const SaveQuranMarkerEvent({required this.position});

  @override
  List<Object?> get props => [position];
}

/// Event to get a marker
class GetQuranMarkerEvent extends QuranEvent {
  const GetQuranMarkerEvent();
}

/// Event to update the page
class UpdateQuranPageEvent extends QuranEvent {
  final int pageNumber;

  const UpdateQuranPageEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}

/// Event to jump to a specific page
class JumpToQuranPageEvent extends QuranEvent {
  final int pageNumber;

  const JumpToQuranPageEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}
