import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' hide QuranState;

import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';
import '../../bloc/quran_state.dart';
import 'sura_save_and_go_mark_widget.dart';
import 'sura_view_marker.dart';

class SuraViewBody extends StatefulWidget {
  const SuraViewBody({super.key, required this.initialPage});
  final int initialPage;

  @override
  State<SuraViewBody> createState() => _SuraViewBodyState();
}

class _SuraViewBodyState extends State<SuraViewBody> {
  late final QuranBloc quranBloc;
  bool _initialized = false;

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
    // Convert from 1-based to 0-based index for the QuranLibraryScreen
    // The QuranLibraryScreen expects a 0-based index (0-603)
    final pageIndex = (widget.initialPage - 1).clamp(0, 603);

    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen:
          (previous, current) =>
              current is QuranMarkerLoaded ||
              current is QuranViewStateChanged ||
              current is QuranPageChanged,
      builder: (context, state) {
        final currentPage = quranBloc.currentPage ?? widget.initialPage;
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            QuranLibraryScreen(
              withPageView: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              isDark: Theme.of(context).brightness == Brightness.dark,
              useDefaultAppBar: false,
              onPageChanged: (index) {
                // Convert from 0-based to 1-based index
                quranBloc.add(UpdateQuranPageEvent(pageNumber: index + 1));
              },
              // Directly use the converted page index
              pageIndex: pageIndex,
              onTap: (_) {
                quranBloc.add(ToggleQuranViewStateEvent());
              },
            ),
            if (state is QuranMarkerLoaded &&
                state.markerPosition == currentPage)
              const SuraViewMarker(),
            if ((state is QuranViewStateChanged && state.isClickActive) ||
                quranBloc.isClick)
              SuraSaveAndGoMarkWidget(index: currentPage),
          ],
        );
      },
    );
  }
}
