import 'package:equatable/equatable.dart';
import '../../domain/entities/hadith.dart';

/// Base class for all Hadith states
abstract class HadithState extends Equatable {
  /// Creates a new HadithState
  const HadithState();

  @override
  List<Object?> get props => [];
}

/// Initial state for the Hadith feature
class HadithInitial extends HadithState {}

/// State when hadiths are being loaded
class HadithLoading extends HadithState {}

/// State when all hadiths have been loaded successfully
class AllHadithsLoaded extends HadithState {
  /// The list of loaded hadiths
  final List<Hadith> hadiths;

  /// Creates a new AllHadithsLoaded state
  const AllHadithsLoaded({required this.hadiths});

  @override
  List<Object?> get props => [hadiths];
}

/// State when a single hadith has been loaded successfully
class HadithLoaded extends HadithState {
  /// The loaded hadith
  final Hadith hadith;

  /// Creates a new HadithLoaded state
  const HadithLoaded({required this.hadith});

  @override
  List<Object?> get props => [hadith];
}

/// State when the hadith of the day has been loaded successfully
class HadithOfTheDayLoaded extends HadithState {
  /// The hadith of the day
  final Hadith hadith;

  /// Creates a new HadithOfTheDayLoaded state
  const HadithOfTheDayLoaded({required this.hadith});

  @override
  List<Object?> get props => [hadith];
}

/// State when hadiths filtered by source have been loaded successfully
class HadithsBySourceLoaded extends HadithState {
  /// The list of hadiths filtered by source
  final List<Hadith> hadiths;
  
  /// The source used for filtering
  final String source;

  /// Creates a new HadithsBySourceLoaded state
  const HadithsBySourceLoaded({
    required this.hadiths,
    required this.source,
  });

  @override
  List<Object?> get props => [hadiths, source];
}

/// State when hadiths filtered by tag have been loaded successfully
class HadithsByTagLoaded extends HadithState {
  /// The list of hadiths filtered by tag
  final List<Hadith> hadiths;
  
  /// The tag used for filtering
  final String tag;

  /// Creates a new HadithsByTagLoaded state
  const HadithsByTagLoaded({
    required this.hadiths,
    required this.tag,
  });

  @override
  List<Object?> get props => [hadiths, tag];
}

/// State when bookmarked hadiths have been loaded successfully
class BookmarkedHadithsLoaded extends HadithState {
  /// The list of bookmarked hadiths
  final List<Hadith> hadiths;

  /// Creates a new BookmarkedHadithsLoaded state
  const BookmarkedHadithsLoaded({required this.hadiths});

  @override
  List<Object?> get props => [hadiths];
}

/// State when a hadith bookmark has been toggled successfully
class HadithBookmarkToggled extends HadithState {
  /// The hadith with updated bookmark status
  final Hadith hadith;

  /// Creates a new HadithBookmarkToggled state
  const HadithBookmarkToggled({required this.hadith});

  @override
  List<Object?> get props => [hadith];
}

/// State when an error occurs in the Hadith feature
class HadithError extends HadithState {
  /// The error message
  final String message;

  /// Creates a new HadithError state
  const HadithError({required this.message});

  @override
  List<Object?> get props => [message];
}
