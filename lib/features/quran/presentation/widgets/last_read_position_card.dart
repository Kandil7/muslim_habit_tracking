import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_state.dart';

/// Widget to display the last read position in the Quran
class LastReadPositionCard extends StatelessWidget {
  /// Function to call when the user taps to continue reading
  final Function(int pageNumber)? onContinueReading;

  /// Constructor
  const LastReadPositionCard({Key? key, this.onContinueReading})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state is LastReadPositionLoaded && state.lastPosition != null) {
          return _buildCard(context, state.lastPosition!);
        } else if (state is QuranLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCard(BuildContext context, QuranReadingHistory lastPosition) {
    final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');
    final dateString = dateFormat.format(lastPosition.timestamp);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bookmark, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Continue Reading',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lastPosition.surahName != null
                  ? 'Surah ${lastPosition.surahName}'
                  : 'Page ${lastPosition.pageNumber}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Last read on $dateString',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (onContinueReading != null) {
                      onContinueReading!(lastPosition.pageNumber);
                    }
                  },
                  child: const Text('CONTINUE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
