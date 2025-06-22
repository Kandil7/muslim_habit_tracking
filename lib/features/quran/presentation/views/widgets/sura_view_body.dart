import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/theme/bloc/theme_bloc.dart';
import 'package:quran_library/quran_library.dart' hide QuranState;

import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';
import '../../bloc/quran_state.dart';
import 'sura_save_and_go_mark_widget.dart';
import 'sura_view_marker.dart';

class SuraViewBody extends StatefulWidget {
  static const minPage = 1;
  static const maxPage = 604;

  final int initialPage;

  const SuraViewBody({super.key, required this.initialPage});

  @override
  State<SuraViewBody> createState() => _SuraViewBodyState();
}

class _SuraViewBodyState extends State<SuraViewBody> {
  late final QuranBloc quranBloc;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Set initial page in QuranCtrl
    QuranCtrl.instance.state.currentPageNumber.value = widget.initialPage;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      quranBloc = context.read<QuranBloc>();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QuranBloc, QuranState, int>(
      selector:
          (state) =>
              state is QuranPageChanged
                  ? (state.pageNumber)
                  : (context.read<QuranBloc>().currentPage ??
                      widget.initialPage),
      builder: (context, currentPage) {
        final validPage = currentPage.clamp(
          SuraViewBody.minPage,
          SuraViewBody.maxPage,
        );

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [_buildQuranScreen(), _buildOverlays(validPage)],
        );
      },
    );
  }

  Widget _buildQuranScreen() {
    return QuranLibraryScreen(
      useDefaultAppBar: false,
      isDark: context.read<ThemeBloc>().state.themeMode == ThemeMode.dark,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showAyahBookmarkedIcon: true,
      isFontsLocal: false,
      onPageChanged:
          (pageNumber) =>
              quranBloc.add(UpdateQuranPageEvent(pageNumber: pageNumber)),
    );
  }

  Widget _buildOverlays(int currentPage) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen:
          (previous, current) =>
              current is QuranMarkerLoaded || current is QuranViewStateChanged,
      builder: (context, state) {
        return Stack(
          children: [
            if (state is QuranMarkerLoaded &&
                state.markerPosition == currentPage)
              const SuraViewMarker(),
            if (state is QuranViewStateChanged && state.isClickActive)
              SuraSaveAndGoMarkWidget(index: currentPage),
          ],
        );
      },
    );
  }
}
