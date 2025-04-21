import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/navigation.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../views/sura_view.dart';

/// Page for displaying Quran reading history
class QuranReadingHistoryPage extends StatelessWidget {
  /// Constructor
  const QuranReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearHistoryDialog(context),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReadingHistoryLoaded) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(
                child: Text('No reading history yet'),
              );
            }
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('Page ${entry.pageNumber}'),
                  subtitle: Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(entry.timestamp),
                  ),
                  onTap: () {
                    Navigation.push(
                      context,
                      SuraView(initialPage: entry.pageNumber),
                    );
                  },
                );
              },
            );
          } else {
            // If we're not in a loading or loaded state, trigger loading
            context.read<QuranBloc>().add(const GetReadingHistoryEvent());
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all reading history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QuranBloc>().add(const ClearReadingHistoryEvent());
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
