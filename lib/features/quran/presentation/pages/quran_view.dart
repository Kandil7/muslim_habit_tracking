import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../data/models/quran_item_model.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';
import 'widgets/quran_view_body.dart';

/// Main page for the Quran feature
class QuranView extends StatelessWidget {
  /// Constructor
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<QuranBloc>()..add(const GetLastReadPositionEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to search page
              },
              tooltip: 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                // Navigate to bookmarks page
              },
              tooltip: 'Bookmarks',
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                // Navigate to reading history page
              },
              tooltip: 'Reading History',
            ),
          ],
        ),
        body: const QuranViewBody(),
        floatingActionButton: BlocBuilder<QuranBloc, QuranState>(
          buildWhen: (previous, current) =>
              current is LastReadPositionLoaded ||
              current is LastReadPositionUpdated,
          builder: (context, state) {
            if ((state is LastReadPositionLoaded &&
                    state.lastPosition != null) ||
                state is LastReadPositionUpdated) {
              final lastPosition = state is LastReadPositionLoaded
                  ? state.lastPosition!
                  : (state as LastReadPositionUpdated).lastPosition;

              return FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuraView(
                        initialPage: lastPosition.pageNumber,
                      ),
                    ),
                  );
                },
                label: const Text('Continue Reading'),
                icon: const Icon(Icons.book),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
