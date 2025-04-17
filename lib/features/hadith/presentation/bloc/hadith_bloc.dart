import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_hadiths.dart';
import '../../domain/usecases/get_hadith_by_id.dart';
import '../../domain/usecases/get_hadith_of_the_day.dart';
import '../../domain/usecases/toggle_hadith_bookmark.dart';
import 'hadith_event.dart';
import 'hadith_state.dart';

/// BLoC for managing the Hadith feature state
class HadithBloc extends Bloc<HadithEvent, HadithState> {
  final GetAllHadiths getAllHadiths;
  final GetHadithById getHadithById;
  final GetHadithOfTheDay getHadithOfTheDay;
  final ToggleHadithBookmark toggleHadithBookmark;

  /// Creates a new HadithBloc
  HadithBloc({
    required this.getAllHadiths,
    required this.getHadithById,
    required this.getHadithOfTheDay,
    required this.toggleHadithBookmark,
  }) : super(HadithInitial()) {
    on<GetAllHadithsEvent>(_onGetAllHadiths);
    on<GetHadithByIdEvent>(_onGetHadithById);
    on<GetHadithOfTheDayEvent>(_onGetHadithOfTheDay);
    on<GetHadithsBySourceEvent>(_onGetHadithsBySource);
    on<GetHadithsByTagEvent>(_onGetHadithsByTag);
    on<GetBookmarkedHadithsEvent>(_onGetBookmarkedHadiths);
    on<ToggleHadithBookmarkEvent>(_onToggleHadithBookmark);
    on<RefreshHadithOfTheDayEvent>(_onRefreshHadithOfTheDay);
  }

  /// Handles the GetAllHadithsEvent
  Future<void> _onGetAllHadiths(
    GetAllHadithsEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getAllHadiths(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadiths) => emit(AllHadithsLoaded(hadiths: hadiths)),
    );
  }

  /// Handles the GetHadithByIdEvent
  Future<void> _onGetHadithById(
    GetHadithByIdEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getHadithById(HadithParams(id: event.id));
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadith) => emit(HadithLoaded(hadith: hadith)),
    );
  }

  /// Handles the GetHadithOfTheDayEvent
  Future<void> _onGetHadithOfTheDay(
    GetHadithOfTheDayEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getHadithOfTheDay(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadith) => emit(HadithOfTheDayLoaded(hadith: hadith)),
    );
  }

  /// Handles the GetHadithsBySourceEvent
  Future<void> _onGetHadithsBySource(
    GetHadithsBySourceEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getAllHadiths(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadiths) {
        final filteredHadiths = hadiths
            .where((hadith) => hadith.source == event.source)
            .toList();
        emit(HadithsBySourceLoaded(
          hadiths: filteredHadiths,
          source: event.source,
        ));
      },
    );
  }

  /// Handles the GetHadithsByTagEvent
  Future<void> _onGetHadithsByTag(
    GetHadithsByTagEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getAllHadiths(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadiths) {
        final filteredHadiths = hadiths
            .where((hadith) => hadith.tags.contains(event.tag))
            .toList();
        emit(HadithsByTagLoaded(
          hadiths: filteredHadiths,
          tag: event.tag,
        ));
      },
    );
  }

  /// Handles the GetBookmarkedHadithsEvent
  Future<void> _onGetBookmarkedHadiths(
    GetBookmarkedHadithsEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getAllHadiths(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadiths) {
        final bookmarkedHadiths = hadiths
            .where((hadith) => hadith.isBookmarked)
            .toList();
        emit(BookmarkedHadithsLoaded(hadiths: bookmarkedHadiths));
      },
    );
  }

  /// Handles the ToggleHadithBookmarkEvent
  Future<void> _onToggleHadithBookmark(
    ToggleHadithBookmarkEvent event,
    Emitter<HadithState> emit,
  ) async {
    final currentState = state;
    final result = await toggleHadithBookmark(BookmarkParams(id: event.id));
    
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (updatedHadith) {
        emit(HadithBookmarkToggled(hadith: updatedHadith));
        
        // Restore the previous state with updated hadith
        if (currentState is HadithOfTheDayLoaded && 
            currentState.hadith.id == updatedHadith.id) {
          emit(HadithOfTheDayLoaded(hadith: updatedHadith));
        } else if (currentState is HadithLoaded && 
                  currentState.hadith.id == updatedHadith.id) {
          emit(HadithLoaded(hadith: updatedHadith));
        } else if (currentState is AllHadithsLoaded) {
          final updatedHadiths = currentState.hadiths.map((hadith) {
            return hadith.id == updatedHadith.id ? updatedHadith : hadith;
          }).toList();
          emit(AllHadithsLoaded(hadiths: updatedHadiths));
        } else if (currentState is HadithsBySourceLoaded) {
          final updatedHadiths = currentState.hadiths.map((hadith) {
            return hadith.id == updatedHadith.id ? updatedHadith : hadith;
          }).toList();
          emit(HadithsBySourceLoaded(
            hadiths: updatedHadiths,
            source: currentState.source,
          ));
        } else if (currentState is HadithsByTagLoaded) {
          final updatedHadiths = currentState.hadiths.map((hadith) {
            return hadith.id == updatedHadith.id ? updatedHadith : hadith;
          }).toList();
          emit(HadithsByTagLoaded(
            hadiths: updatedHadiths,
            tag: currentState.tag,
          ));
        } else if (currentState is BookmarkedHadithsLoaded) {
          List<dynamic> updatedHadiths;
          if (updatedHadith.isBookmarked) {
            updatedHadiths = [...currentState.hadiths, updatedHadith];
          } else {
            updatedHadiths = currentState.hadiths
                .where((hadith) => hadith.id != updatedHadith.id)
                .toList();
          }
          emit(BookmarkedHadithsLoaded(hadiths: List.from(updatedHadiths)));
        }
      },
    );
  }

  /// Handles the RefreshHadithOfTheDayEvent
  Future<void> _onRefreshHadithOfTheDay(
    RefreshHadithOfTheDayEvent event,
    Emitter<HadithState> emit,
  ) async {
    emit(HadithLoading());
    final result = await getHadithOfTheDay(NoParams());
    result.fold(
      (failure) => emit(HadithError(message: failure.toString())),
      (hadith) => emit(HadithOfTheDayLoaded(hadith: hadith)),
    );
  }
}
