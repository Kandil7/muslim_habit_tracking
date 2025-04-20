import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quran_library/quran_library.dart' as ql;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Widget to display the last read position in the Quran
class LastReadPositionCard extends StatelessWidget {
  /// Function to call when the user taps to continue reading
  final Function(int pageNumber)? onContinueReading;

  /// Constructor
  const LastReadPositionCard({super.key, this.onContinueReading});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen:
          (previous, current) =>
              current is LastReadPositionLoaded || current is QuranLoading,
      builder: (context, state) {
        if (state is LastReadPositionLoaded && state.lastPosition != null) {
          return _buildCard(context, state.lastPosition!);
        } else if (state is QuranLoading) {
          return Card(
            margin: const EdgeInsets.all(16.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return _buildEmptyCard(context);
        }
      },
    );
  }

  Widget _buildCard(BuildContext context, QuranReadingHistory lastPosition) {
    final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');
    final dateString = dateFormat.format(lastPosition.timestamp);

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (onContinueReading != null) {
            onContinueReading!(lastPosition.pageNumber);
          }
        },
        borderRadius: BorderRadius.circular(12),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateString,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lastPosition.surahName != null
                              ? 'Surah ${lastPosition.surahName}'
                              : 'Page ${lastPosition.pageNumber}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (lastPosition.ayahNumber != null)
                          Text(
                            'Ayah ${lastPosition.ayahNumber}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        Text(
                          'Page ${lastPosition.pageNumber}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (onContinueReading != null) {
                        onContinueReading!(lastPosition.pageNumber);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bookmark_outline, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Last Read',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No reading history yet. Start reading the Quran to track your progress.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
