import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page to display Quran reading history
class QuranReadingHistoryPage extends StatelessWidget {
  /// Constructor
  const QuranReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranBloc>()..add(const GetReadingHistoryEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reading History'),
          actions: [
            BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                if (state is ReadingHistoryLoaded && state.history.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () {
                      _showClearHistoryDialog(context);
                    },
                    tooltip: 'Clear History',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReadingHistoryLoaded) {
              return _buildHistoryList(context, state.history);
            } else if (state is QuranError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No reading history found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<QuranReadingHistory> history,
  ) {
    if (history.isEmpty) {
      return EmptyState(
        title: 'No Reading History',
        message: 'Your Quran reading activity will appear here',
        icon: Icons.history,
        actionText: 'Go to Quran',
        onAction: () => Navigator.pop(context),
      );
    }

    // Group history by date
    final Map<String, List<QuranReadingHistory>> groupedHistory = {};
    final dateFormat = DateFormat('MMMM d, yyyy');

    for (final entry in history) {
      final dateString = dateFormat.format(entry.timestamp);
      if (!groupedHistory.containsKey(dateString)) {
        groupedHistory[dateString] = [];
      }
      groupedHistory[dateString]!.add(entry);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: groupedHistory.length,
      itemBuilder: (context, index) {
        final date = groupedHistory.keys.elementAt(index);
        final entries = groupedHistory[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  date,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            ...entries.map((entry) => _buildHistoryItem(context, entry)),
            const Divider(height: 32, indent: 16, endIndent: 16),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, QuranReadingHistory entry) {
    final timeFormat = DateFormat('h:mm a');
    final timeString = timeFormat.format(entry.timestamp);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to the Quran page
          Navigation.push(context, SuraView(initialPage: entry.pageNumber));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _getColorForSurah(entry.surahNumber),
                child: const Icon(Icons.menu_book, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.surahName != null
                          ? 'Surah ${entry.surahName}'
                          : 'Page ${entry.pageNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeString,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (entry.durationSeconds != null &&
                            entry.durationSeconds! > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withValues(alpha: 26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getDurationText(entry.durationSeconds),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForSurah(int? surahNumber) {
    if (surahNumber == null) return AppColors.primary;

    // Create a deterministic color based on surah number
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.success,
      AppColors.info,
    ];

    return colors[surahNumber % colors.length];
  }

  String _getDurationText(int? durationSeconds) {
    if (durationSeconds == null || durationSeconds == 0) {
      return '';
    }

    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;

    if (minutes > 0) {
      return '$minutes min${seconds > 0 ? ' $seconds sec' : ''}';
    } else {
      return '$seconds sec';
    }
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Reading History'),
            content: const Text(
              'Are you sure you want to clear your reading history? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<QuranBloc>().add(
                    const ClearReadingHistoryEvent(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reading history cleared')),
                  );
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }
}
