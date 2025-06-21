import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/quran_state.dart';
import 'package:muslim_habbit/features/quran/presentation/views/sura_view.dart';
import 'package:quran_library/quran_library.dart' as ql;

class ContinueReadingButton extends StatelessWidget {
  const ContinueReadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen:
          (previous, current) =>
              current is LastReadPositionLoaded ||
              current is LastReadPositionUpdated,
      builder: (context, state) {
        if ((state is LastReadPositionLoaded && state.lastPosition != null) ||
            state is LastReadPositionUpdated) {
          final lastPosition =
              state is LastReadPositionLoaded
                  ? state.lastPosition!
                  : (state as LastReadPositionUpdated).lastPosition;

          return FloatingActionButton.extended(
            onPressed: () {
              ql.QuranLibrary().jumpToPage(lastPosition.pageNumber);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          SuraView(initialPage: lastPosition.pageNumber),
                ),
              );
            },
            label: const Text('Continue Reading'),
            icon: const Icon(Icons.book),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
