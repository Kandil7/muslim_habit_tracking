import 'package:equatable/equatable.dart';

/// Base class for all Hadith events
abstract class HadithEvent extends Equatable {
  /// Creates a new HadithEvent
  const HadithEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get all hadiths
class GetAllHadithsEvent extends HadithEvent {
  /// Creates a new GetAllHadithsEvent
  const GetAllHadithsEvent();
}

/// Event to get a hadith by its ID
class GetHadithByIdEvent extends HadithEvent {
  /// The ID of the hadith to retrieve
  final String id;

  /// Creates a new GetHadithByIdEvent
  const GetHadithByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to get the hadith of the day
class GetHadithOfTheDayEvent extends HadithEvent {
  /// Creates a new GetHadithOfTheDayEvent
  const GetHadithOfTheDayEvent();
}

/// Event to get hadiths by source
class GetHadithsBySourceEvent extends HadithEvent {
  /// The source to filter hadiths by
  final String source;

  /// Creates a new GetHadithsBySourceEvent
  const GetHadithsBySourceEvent({required this.source});

  @override
  List<Object?> get props => [source];
}

/// Event to get hadiths by tag
class GetHadithsByTagEvent extends HadithEvent {
  /// The tag to filter hadiths by
  final String tag;

  /// Creates a new GetHadithsByTagEvent
  const GetHadithsByTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}

/// Event to get bookmarked hadiths
class GetBookmarkedHadithsEvent extends HadithEvent {
  /// Creates a new GetBookmarkedHadithsEvent
  const GetBookmarkedHadithsEvent();
}

/// Event to toggle the bookmark status of a hadith
class ToggleHadithBookmarkEvent extends HadithEvent {
  /// The ID of the hadith to toggle bookmark status
  final String id;

  /// Creates a new ToggleHadithBookmarkEvent
  const ToggleHadithBookmarkEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh the hadith of the day
class RefreshHadithOfTheDayEvent extends HadithEvent {
  /// Creates a new RefreshHadithOfTheDayEvent
  const RefreshHadithOfTheDayEvent();
}
