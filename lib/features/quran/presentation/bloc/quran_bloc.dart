import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as quran;
import 'package:quran_library/quran_library.dart' show QuranCtrl;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/services/shared_pref_service.dart';
import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/add_reading_history.dart';
import '../../domain/usecases/clear_reading_history.dart';
import '../../domain/usecases/get_all_bookmarks.dart';
import '../../domain/usecases/get_last_read_position.dart';
import '../../domain/usecases/get_reading_history.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/update_bookmark.dart';
import '../../domain/usecases/update_last_read_position.dart';
import 'quran_event.dart';
import 'quran_state.dart';

/// BLoC for the Quran feature
class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final quran.QuranLibrary quranLibrary;
  final GetAllBookmarks getAllBookmarks;
  final AddBookmark addBookmark;
  final UpdateBookmark updateBookmark;
  final RemoveBookmark removeBookmark;
  final GetReadingHistory getReadingHistory;
  final AddReadingHistory addReadingHistory;
  final ClearReadingHistory clearReadingHistory;
  final GetLastReadPosition getLastReadPosition;
  final UpdateLastReadPosition updateLastReadPosition;
  final SharedPrefService sharedPrefService;

  // Properties from SuraCubit
  PageController? _pageController;
  PageController get pageController => _pageController ?? PageController();
  bool isClick = false;
  int? markerIndex;
  int? currentPage;

  QuranBloc({
    required this.quranLibrary,
    required this.getAllBookmarks,
    required this.addBookmark,
    required this.updateBookmark,
    required this.removeBookmark,
    required this.getReadingHistory,
    required this.addReadingHistory,
    required this.clearReadingHistory,
    required this.getLastReadPosition,
    required this.updateLastReadPosition,
    required this.sharedPrefService,
  }) : super(QuranInitial()) {
    on<GetAllSurahsEvent>(_onGetAllSurahs);
    on<GetSurahByIdEvent>(_onGetSurahById);
    on<GetBookmarksEvent>(_onGetBookmarks);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<UpdateBookmarkEvent>(_onUpdateBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<GetReadingHistoryEvent>(_onGetReadingHistory);
    on<AddReadingHistoryEvent>(_onAddReadingHistory);
    on<ClearReadingHistoryEvent>(_onClearReadingHistory);
    on<GetLastReadPositionEvent>(_onGetLastReadPosition);
    on<UpdateLastReadPositionEvent>(_onUpdateLastReadPosition);

    // Register handlers for SuraCubit events
    on<InitQuranPageControllerEvent>(_onInitPageController);
    on<ToggleQuranViewStateEvent>(_onToggleViewState);
    on<ResetQuranViewStateEvent>(_onResetViewState);
    on<SaveQuranMarkerEvent>(_onSaveMarker);
    on<GetQuranMarkerEvent>(_onGetMarker);
    on<UpdateQuranPageEvent>(_onUpdatePage);
    on<JumpToQuranPageEvent>(_onJumpToPage);

    // Initialize marker
    add(const GetQuranMarkerEvent());
  }

  /// Handle GetAllSurahsEvent
  Future<void> _onGetAllSurahs(
    GetAllSurahsEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    try {
      final surahs = quranLibrary.getAllSurahs();
      emit(AllSurahsLoaded(surahs: surahs));
    } catch (e) {
      emit(QuranError(message: e.toString()));
    }
  }

  /// Handle GetSurahByIdEvent
  Future<void> _onGetSurahById(
    GetSurahByIdEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    try {
      final surah = quran.QuranLibrary().getSurahInfo(
        surahNumber: event.surahId,
      );
      emit(SurahLoaded(surah: surah));
    } catch (e) {
      emit(QuranError(message: e.toString()));
    }
  }

  /// Handle GetBookmarksEvent
  Future<void> _onGetBookmarks(
    GetBookmarksEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await getAllBookmarks(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (bookmarks) => emit(BookmarksLoaded(bookmarks: bookmarks)),
    );
  }

  /// Handle AddBookmarkEvent
  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await addBookmark(
      AddBookmarkParams(bookmark: event.bookmark),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (bookmark) => emit(BookmarkAdded(bookmark: bookmark)),
    );
  }

  /// Handle UpdateBookmarkEvent
  Future<void> _onUpdateBookmark(
    UpdateBookmarkEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await updateBookmark(
      UpdateBookmarkParams(bookmark: event.bookmark),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (bookmark) => emit(BookmarkUpdated(bookmark: bookmark)),
    );
  }

  /// Handle RemoveBookmarkEvent
  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await removeBookmark(RemoveBookmarkParams(id: event.id));
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (_) => emit(BookmarkRemoved()),
    );
  }

  /// Handle GetReadingHistoryEvent
  Future<void> _onGetReadingHistory(
    GetReadingHistoryEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await getReadingHistory(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (history) => emit(ReadingHistoryLoaded(history: history)),
    );
  }

  /// Handle AddReadingHistoryEvent
  Future<void> _onAddReadingHistory(
    AddReadingHistoryEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await addReadingHistory(
      AddReadingHistoryParams(history: event.history),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (history) => emit(LastReadPositionUpdated(lastPosition: history)),
    );
  }

  /// Handle ClearReadingHistoryEvent
  Future<void> _onClearReadingHistory(
    ClearReadingHistoryEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await clearReadingHistory(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (_) => emit(ReadingHistoryCleared()),
    );
  }

  /// Handle GetLastReadPositionEvent
  Future<void> _onGetLastReadPosition(
    GetLastReadPositionEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    final result = await getLastReadPosition(NoParams());
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (lastPosition) =>
          emit(LastReadPositionLoaded(lastPosition: lastPosition)),
    );
  }

  /// Handle UpdateLastReadPositionEvent
  Future<void> _onUpdateLastReadPosition(
    UpdateLastReadPositionEvent event,
    Emitter<QuranState> emit,
  ) async {
    // Don't emit loading state for this operation as it's a background update
    final result = await updateLastReadPosition(
      UpdateLastReadPositionParams(history: event.history),
    );
    result.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (history) => emit(LastReadPositionUpdated(lastPosition: history)),
    );
  }

  // Handlers for SuraCubit functionality

  /// Initialize the page controller
  void _onInitPageController(
    InitQuranPageControllerEvent event,
    Emitter<QuranState> emit,
  ) {
    try {
      // Initialize with the correct page (0-based index)
      _pageController = PageController(initialPage: event.initialPage);
      _initQuranView();

      // Set the current page (1-based index)
      // Only update if not already set
      currentPage ??= event.initialPage + 1;

      // Set the page in QuranCtrl directly
      try {
        QuranCtrl.instance.state.currentPageNumber.value = currentPage!;
      } catch (e) {
        debugPrint('Error setting page in QuranCtrl: $e');
      }

      // Emit the controller created event
      emit(QuranPageControllerCreated(pageController: _pageController!));

      // Also emit a page changed event to ensure UI is updated
      emit(QuranPageChanged(pageNumber: currentPage!));
    } catch (e) {
      debugPrint('Error initializing page controller: $e');
      // Still emit a page changed event to ensure UI is updated
      if (currentPage != null) {
        emit(QuranPageChanged(pageNumber: currentPage!));
      }
    }
  }

  /// Toggle the view state (e.g., showing/hiding UI elements)
  void _onToggleViewState(
    ToggleQuranViewStateEvent event,
    Emitter<QuranState> emit,
  ) {
    isClick = !isClick;
    emit(QuranViewStateChanged(isClickActive: isClick));
  }

  /// Reset the view state to default
  void _onResetViewState(
    ResetQuranViewStateEvent event,
    Emitter<QuranState> emit,
  ) {
    isClick = false;
    emit(QuranViewStateChanged(isClickActive: isClick));
  }

  /// Save a marker at a specific position
  Future<void> _onSaveMarker(
    SaveQuranMarkerEvent event,
    Emitter<QuranState> emit,
  ) async {
    await sharedPrefService.setInt(
      key: Constants.marker,
      value: event.position,
    );
    emit(QuranMarkerSaved(markerPosition: event.position));

    // Only add the event if the bloc is not closed
    try {
      add(const GetQuranMarkerEvent());
    } catch (e) {
      debugPrint('Error adding GetQuranMarkerEvent: $e');
      // We can still update the marker index directly
      markerIndex = event.position;
    }
  }

  /// Get the saved marker
  void _onGetMarker(GetQuranMarkerEvent event, Emitter<QuranState> emit) {
    markerIndex = sharedPrefService.getInt(key: Constants.marker);
    isClick = false;
    emit(QuranMarkerLoaded(markerPosition: markerIndex));
  }

  /// Update the current page
  void _onUpdatePage(UpdateQuranPageEvent event, Emitter<QuranState> emit) {
    // Only emit state if the page has actually changed
    if (currentPage != event.pageNumber) {
      currentPage = event.pageNumber;
      emit(QuranPageChanged(pageNumber: event.pageNumber));
    }
  }

  /// Jump to a specific page
  void _onJumpToPage(JumpToQuranPageEvent event, Emitter<QuranState> emit) {
    // Ensure the page number is within valid range (1-604)
    final validPageNumber = event.pageNumber.clamp(1, 604);

    // Convert from 1-based to 0-based index for the page controller
    final pageIndex = validPageNumber - 1;

    // Jump to the page
    if (_pageController != null && _pageController!.hasClients) {
      try {
        // Use jumpToPage for immediate transition
        _pageController!.jumpToPage(pageIndex);
        debugPrint('Jumped to page $validPageNumber');
      } catch (e) {
        debugPrint('Error jumping to page: $e');
      }
    }

    // Always set the page in QuranCtrl directly, even if the page controller is not ready
    try {
      QuranCtrl.instance.state.currentPageNumber.value = validPageNumber;
    } catch (e) {
      debugPrint('Error setting page in QuranCtrl: $e');
    }

    // Update the current page
    currentPage = validPageNumber;
    emit(QuranPageChanged(pageNumber: validPageNumber));
  }

  /// Initialize the Quran view
  void _initQuranView() {
    // Enable wakelock in a safe way that won't block the main thread
    Future.microtask(() {
      try {
        // Enable wakelock safely
        WakelockPlus.enable().catchError((e) {
          debugPrint('Error enabling wakelock: $e');
        });
      } catch (e) {
        debugPrint('Error enabling wakelock: $e');
      }
    });

    try {
      // Add listener to page controller with null checks
      if (_pageController != null) {
        _pageController!.addListener(() {
          if (_pageController != null &&
              _pageController!.hasClients &&
              isClick &&
              _pageController!.position.pixels != 0) {
            try {
              add(const ResetQuranViewStateEvent());
            } catch (e) {
              debugPrint('Error resetting view state: $e');
              // Update state directly if event fails
              isClick = false;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error adding page controller listener: $e');
    }
  }

  @override
  Future<void> close() async {
    // Dispose page controller safely
    try {
      if (_pageController != null) {
        _pageController!.dispose();
        // _pageController = null;
      }
    } catch (e) {
      debugPrint('Error disposing page controller: $e');
    }

    // Disable wakelock safely without blocking
    try {
      // Use a separate Future to avoid blocking the close method
      unawaited(
        WakelockPlus.disable().catchError((e) {
          debugPrint('Error disabling wakelock: $e');
        }),
      );
    } catch (e) {
      debugPrint('Error disabling wakelock: $e');
    }

    //   // Return the parent close method
    return super.close();
  }
}
