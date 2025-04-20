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
class QuranReadingHistoryPage extends StatefulWidget {
  /// Constructor
  const QuranReadingHistoryPage({super.key});

  @override
  State<QuranReadingHistoryPage> createState() =>
      _QuranReadingHistoryPageState();
}

/// Enum for history grouping options
enum HistoryGroupOption {
  /// Group by date
  date,

  /// Group by time of day (morning, afternoon, evening, night)
  timeOfDay,
}

class _QuranReadingHistoryPageState extends State<QuranReadingHistoryPage> {
  HistoryGroupOption _groupOption = HistoryGroupOption.date;

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
                  return Row(
                    children: [
                      // Group by toggle
                      IconButton(
                        icon: Icon(
                          _groupOption == HistoryGroupOption.date
                              ? Icons.calendar_today
                              : Icons.access_time,
                        ),
                        onPressed: () {
                          _showGroupingOptions(context);
                        },
                        tooltip: 'Group by',
                      ),
                      // Clear history button
                      IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        onPressed: () {
                          _showClearHistoryDialog(context);
                        },
                        tooltip: 'Clear History',
                      ),
                    ],
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

  /// Show options for grouping history entries
  void _showGroupingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Group Reading History By',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Date'),
                leading: const Icon(Icons.calendar_today),
                trailing:
                    _groupOption == HistoryGroupOption.date
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _groupOption = HistoryGroupOption.date;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Time of Day'),
                leading: const Icon(Icons.access_time),
                trailing:
                    _groupOption == HistoryGroupOption.timeOfDay
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  setState(() {
                    _groupOption = HistoryGroupOption.timeOfDay;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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

    // Group history based on selected option
    final Map<String, List<QuranReadingHistory>> groupedHistory = {};

    for (final entry in history) {
      final groupKey = _getGroupKey(entry);
      if (!groupedHistory.containsKey(groupKey)) {
        groupedHistory[groupKey] = [];
      }
      groupedHistory[groupKey]!.add(entry);
    }

    // Sort the keys based on the grouping option
    final sortedKeys = _sortGroupKeys(groupedHistory.keys.toList());

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final groupKey = sortedKeys[index];
        final entries = groupedHistory[groupKey]!;

        // Sort entries within each group by timestamp (newest first)
        entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

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
                  _getGroupDisplayName(groupKey),
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

  /// Get the group key for a history entry based on the current grouping option
  String _getGroupKey(QuranReadingHistory entry) {
    switch (_groupOption) {
      case HistoryGroupOption.date:
        return DateFormat('yyyy-MM-dd').format(entry.timestamp);
      case HistoryGroupOption.timeOfDay:
        return _getTimeOfDayGroup(entry.timestamp);
    }
  }

  /// Get the time of day group (Morning, Afternoon, Evening, Night) for a timestamp
  String _getTimeOfDayGroup(DateTime timestamp) {
    final hour = timestamp.hour;

    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  /// Sort group keys based on the current grouping option
  List<String> _sortGroupKeys(List<String> keys) {
    if (_groupOption == HistoryGroupOption.date) {
      // Sort dates in descending order (newest first)
      keys.sort((a, b) => b.compareTo(a));
    } else {
      // Sort time of day in chronological order
      final timeOfDayOrder = {
        'morning': 0,
        'afternoon': 1,
        'evening': 2,
        'night': 3,
      };

      keys.sort(
        (a, b) => (timeOfDayOrder[a] ?? 0).compareTo(timeOfDayOrder[b] ?? 0),
      );
    }

    return keys;
  }

  /// Get a display name for a group key
  String _getGroupDisplayName(String groupKey) {
    if (_groupOption == HistoryGroupOption.date) {
      // Convert yyyy-MM-dd to a readable date format
      final date = DateTime.parse(groupKey);
      return DateFormat('MMMM d, yyyy').format(date);
    } else {
      // Capitalize the time of day
      return groupKey.substring(0, 1).toUpperCase() + groupKey.substring(1);
    }
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
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 36,
                ),
                SizedBox(height: 16),
                Text(
                  'Are you sure you want to clear your reading history?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'This action cannot be undone and will remove all your reading history records.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<QuranBloc>().add(
                    const ClearReadingHistoryEvent(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reading history cleared')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }
}
