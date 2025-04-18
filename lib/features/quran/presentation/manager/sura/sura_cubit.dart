import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/constants.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../../core/utils/services/shared_pref_service.dart';

part 'sura_state.dart';

class SuraCubit extends Cubit<SuraState> {
  SuraCubit(this._sharedPrefService) : super(SuraInitial()) {
    _getMarker();
  }

  final SharedPrefService _sharedPrefService;
  late PageController pageController;

  bool isClick = false;

  void initPageController(int initialPage) {
    pageController = PageController(initialPage: initialPage);
    _initSuraView();
    emit(CreatePageController());
  }

  void changeViewState() {
    isClick = !isClick;
    emit(ChangeViewState());
  }

  void defaultViewState() {
    isClick = false;
    emit(ChangeViewState());
  }

  int? index;

  Future<void> saveMarker(int value) async {
    await _sharedPrefService.setInt(key: Constants.marker, value: value);
    emit(SaveMarker());
    _getMarker();
  }

  void _getMarker() {
    index = _sharedPrefService.getInt(key: Constants.marker);
    isClick = false;
    emit(GetMarker());
  }

  int? page;

  void getPage(int index) {
    page = index;
    emit(GetPage());
  }

  void _initSuraView() {
    WakelockPlus.enable();

    pageController.addListener(() {
      if (isClick) {
        if (pageController.position.pixels != 0) {
          defaultViewState();
        }
      }
    });
  }

  @override
  Future<void> close() {
    pageController.dispose();
    WakelockPlus.disable();
    return super.close();
  }
}
