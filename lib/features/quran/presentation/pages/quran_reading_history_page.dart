import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page for displaying Quran reading history
class QuranReadingHistoryPage extends StatefulWidget {
  /// Constructor
  const QuranReadingHistoryPage({super.key});

  @override
  State<QuranReadingHistoryPage> createState() =>
      _QuranReadingHistoryPageState();
}

class _QuranReadingHistoryPageState extends State<QuranReadingHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Trigger loading of reading history in initState instead of build
    _loadReadingHistory();
  }

  void _loadReadingHistory() {
    // Safely add the event with error handling
    try {
      context.read<QuranBloc>().add(const GetReadingHistoryEvent());
    } catch (e) {
      debugPrint('Error loading reading history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('quran.history')),
        actions: [
          // Filter button
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: context.tr.translate('quran.filterBy'),
            onSelected: (value) {
              // Implement filtering logic here
              // For now, we'll just show a snackbar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Filtering by $value')));
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'today', child: Text('Today')),
                  PopupMenuItem(value: 'week', child: Text('This Week')),
                  PopupMenuItem(value: 'month', child: Text('This Month')),
                  PopupMenuItem(
                    value: 'all',
                    child: Text(context.tr.translate('quran.all')),
                  ),
                ],
          ),
          // Clear history button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearHistoryDialog(context),
            tooltip: context.tr.translate('quran.clearHistory'),
          ),
        ],
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuranError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reading history',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        context.read<QuranBloc>().add(
                          const GetReadingHistoryEvent(),
                        );
                      } catch (e) {
                        debugPrint('Error reloading reading history: $e');
                      }
                    },
                    child: Text(context.tr.translate('common.retry')),
                  ),
                ],
              ),
            );
          } else if (state is ReadingHistoryLoaded) {
            final history = state.history;
            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.tr.translate('quran.noHistory'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr.translate('quran.noReadingHistory'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const SuraView(initialPage: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.book),
                      label: Text(context.tr.translate('quran.startReading')),
                    ),
                  ],
                ),
              );
            }

            // Group history entries by date
            final Map<String, List<dynamic>> groupedHistory = {};
            for (final entry in history) {
              final date = DateFormat.yMMMd().format(entry.timestamp);
              if (!groupedHistory.containsKey(date)) {
                groupedHistory[date] = [];
              }
              groupedHistory[date]!.add(entry);
            }

            // Convert to list of sections
            final sections =
                groupedHistory.entries.toList()..sort(
                  (a, b) => b.key.compareTo(a.key),
                ); // Sort by date, newest first

            return ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, sectionIndex) {
                final section = sections[sectionIndex];
                final date = section.key;
                final entries = section.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        date,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      itemBuilder: (context, entryIndex) {
                        final entry = entries[entryIndex];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigation.push(
                                context,
                                SuraView(initialPage: entry.pageNumber),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: AppColors.secondary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${context.tr.translate('quran.page')} ${entry.pageNumber}',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat(
                                            'h:mm a',
                                          ).format(entry.timestamp),
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // If we're not in a loading or loaded state, trigger loading
            try {
              context.read<QuranBloc>().add(const GetReadingHistoryEvent());
            } catch (e) {
              debugPrint('Error loading reading history: $e');
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.tr.translate('quran.clearHistory')),
            content: Text(
              context.tr.translate('quran.clearHistoryConfirmation'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.tr.translate('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  try {
                    context.read<QuranBloc>().add(
                      const ClearReadingHistoryEvent(),
                    );
                  } catch (e) {
                    debugPrint('Error clearing reading history: $e');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.tr.translate('quran.historyCleared'),
                      ),
                    ),
                  );
                },
                child: Text(context.tr.translate('quran.clearHistory')),
              ),
            ],
          ),
    );
  }
}
