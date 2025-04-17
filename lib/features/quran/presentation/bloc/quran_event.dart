import 'package:equatable/equatable.dart';

import '../../domain/entities/bookmark.dart';
import '../../domain/entities/reading_history.dart';

/// Base class for all Quran events
abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all surahs
class LoadSurahs extends QuranEvent {
  const LoadSurahs();
}

/// Event to load a specific surah by ID
class LoadSurah extends QuranEvent {
  final int surahId;

  const LoadSurah({required this.surahId});

  @override
  List<Object?> get props => [surahId];
}

/// Event to load all bookmarks
class LoadBookmarks extends QuranEvent {
  const LoadBookmarks();
}

/// Event to add a bookmark
class AddBookmarkEvent extends QuranEvent {
  final QuranBookmark bookmark;

  const AddBookmarkEvent({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// Event to remove a bookmark
class RemoveBookmarkEvent extends QuranEvent {
  final String bookmarkId;

  const RemoveBookmarkEvent({required this.bookmarkId});

  @override
  List<Object?> get props => [bookmarkId];
}

/// Event to load reading history
class LoadReadingHistory extends QuranEvent {
  const LoadReadingHistory();
}

/// Event to add reading history
class AddReadingHistoryEvent extends QuranEvent {
  final QuranReadingHistory history;

  const AddReadingHistoryEvent({required this.history});

  @override
  List<Object?> get props => [history];
}

/// Event to clear reading history
class ClearReadingHistory extends QuranEvent {
  const ClearReadingHistory();
}

/// Event to load last read position
class LoadLastReadPosition extends QuranEvent {
  const LoadLastReadPosition();
}

/// Event to update last read position
class UpdateLastReadPosition extends QuranEvent {
  final QuranReadingHistory history;

  const UpdateLastReadPosition({required this.history});

  @override
  List<Object?> get props => [history];
}
