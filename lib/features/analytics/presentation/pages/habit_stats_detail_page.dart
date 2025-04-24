import 'package:flutter/material.dart';
import '../../domain/entities/habit_stats.dart';
import 'analytics_detail_page.dart';

/// Page for detailed habit statistics
class HabitStatsDetailPage extends StatelessWidget {
  final HabitStats habitStats;

  const HabitStatsDetailPage({super.key, required this.habitStats});

  @override
  Widget build(BuildContext context) {
    // Use the new AnalyticsDetailPage instead
    return AnalyticsDetailPage(habitStats: habitStats);
  }
}
