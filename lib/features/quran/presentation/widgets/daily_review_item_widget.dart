import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

/// Widget showing a single item in the daily review list
class DailyReviewItemWidget extends StatelessWidget {
  final MemorizationItem item;

  const DailyReviewItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: _getStatusIcon(item.status),
      title: Text(item.surahName),
      subtitle: Text('Pages ${item.startPage}-${item.endPage}'),
      trailing: _getTrailingWidget(context),
      onTap: () {
        // TODO: Navigate to review details page
      },
    );
  }

  /// Get status icon based on item status
  Widget _getStatusIcon(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        );
      case MemorizationStatus.inProgress:
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        );
      case MemorizationStatus.memorized:
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        );
      case MemorizationStatus.archived:
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  /// Get trailing widget based on item status
  Widget _getTrailingWidget(BuildContext context) {
    switch (item.status) {
      case MemorizationStatus.newStatus:
      case MemorizationStatus.inProgress:
        return ElevatedButton(
          onPressed: () {
            // Mark item as reviewed
            context.read<MemorizationBloc>().add(MarkItemAsReviewedEvent(item.id));
          },
          child: const Text('Review'),
        );
      case MemorizationStatus.memorized:
        return ElevatedButton(
          onPressed: () {
            // Mark item as reviewed
            context.read<MemorizationBloc>().add(MarkItemAsReviewedEvent(item.id));
          },
          child: const Text('Review'),
        );
      case MemorizationStatus.archived:
        return const Icon(Icons.archive, color: Colors.grey);
    }
  }
}