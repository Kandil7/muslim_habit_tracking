import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/quran_reading_history.dart';

/// Base class for all Quran states
abstract class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

/// Initial state for the Quran feature
class QuranInitial extends QuranState {}

/// State when Quran data is being loaded
class QuranLoading extends QuranState {}

/// State when an error occurs
class QuranError extends QuranState {
  final String message;

  const QuranError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when all surahs have been loaded
class AllSurahsLoaded extends QuranState {
  final List<dynamic> surahs;

  const AllSurahsLoaded({required this.surahs});

  @override
  List<Object?> get props => [surahs];
}

/// State when a specific surah has been loaded
class SurahLoaded extends QuranState {
  final dynamic surah;

  const SurahLoaded({required this.surah});

  @override
  List<Object?> get props => [surah];
}

/// State when bookmarks have been loaded
class BookmarksLoaded extends QuranState {
  final List<QuranBookmark> bookmarks;

  const BookmarksLoaded({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}

/// State when a bookmark has been added
class BookmarkAdded extends QuranState {
  final QuranBookmark bookmark;

  const BookmarkAdded({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// State when a bookmark has been updated
class BookmarkUpdated extends QuranState {
  final QuranBookmark bookmark;

  const BookmarkUpdated({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// State when a bookmark has been removed
class BookmarkRemoved extends QuranState {}

/// State when reading history has been loaded
class ReadingHistoryLoaded extends QuranState {
  final List<QuranReadingHistory> history;

  const ReadingHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

/// State when reading history has been cleared
class ReadingHistoryCleared extends QuranState {}

/// State when last read position has been loaded
class LastReadPositionLoaded extends QuranState {
  final QuranReadingHistory? lastPosition;

  const LastReadPositionLoaded({required this.lastPosition});

  @override
  List<Object?> get props => [lastPosition];
}

/// State when last read position has been updated
class LastReadPositionUpdated extends QuranState {
  final QuranReadingHistory lastPosition;

  const LastReadPositionUpdated({required this.lastPosition});

  @override
  List<Object?> get props => [lastPosition];
}

// States for Quran reading functionality (merged from SuraCubit)

/// State when the page controller has been created
class QuranPageControllerCreated extends QuranState {
  final PageController pageController;

  const QuranPageControllerCreated({required this.pageController});

  @override
  List<Object?> get props => [pageController];
}

/// State when the view state has changed (e.g., showing/hiding UI elements)
class QuranViewStateChanged extends QuranState {
  final bool isClickActive;

  const QuranViewStateChanged({required this.isClickActive});

  @override
  List<Object?> get props => [isClickActive];
}

/// State when a marker has been saved
class QuranMarkerSaved extends QuranState {
  final int markerPosition;

  const QuranMarkerSaved({required this.markerPosition});

  @override
  List<Object?> get props => [markerPosition];
}

/// State when a marker has been loaded
class QuranMarkerLoaded extends QuranState {
  final int? markerPosition;

  const QuranMarkerLoaded({required this.markerPosition});

  @override
  List<Object?> get props => [markerPosition];
}

/// State when the current page has changed
class QuranPageChanged extends QuranState {
  final int pageNumber;

  const QuranPageChanged({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}
