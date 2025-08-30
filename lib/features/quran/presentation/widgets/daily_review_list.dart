import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/features/quran/presentation/widgets/daily_review_item_widget.dart';

/// Widget showing the list of items for daily review
class DailyReviewList extends StatelessWidget {
  const DailyReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemorizationBloc, MemorizationState>(
      builder: (context, state) {
        if (state is DailyReviewScheduleLoaded) {
          final schedule = state.schedule;
          
          if (schedule.dailyItems.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'All caught up!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have completed all your reviews for today.',
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Card(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${schedule.dailyItemCount} items',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // List of items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: schedule.dailyItems.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = schedule.dailyItems[index];
                    return DailyReviewItemWidget(item: item);
                  },
                ),
              ],
            ),
          );
        } else if (state is MemorizationLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is MemorizationError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Error: ${state.message}')),
            ),
          );
        }
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}