import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/bloc/enhanced_dashboard_bloc.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/widgets/todays_overview_widget.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/widgets/task_progress_widget.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/widgets/upcoming_reminders_widget.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/widgets/motivational_snippet_widget.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/widgets/quick_access_widget.dart';

/// Enhanced Dashboard Page - Main entry point for the integrated life management companion
class EnhancedDashboardPage extends StatefulWidget {
  const EnhancedDashboardPage({super.key});

  @override
  State<EnhancedDashboardPage> createState() => _EnhancedDashboardPageState();
}

class _EnhancedDashboardPageState extends State<EnhancedDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load initial dashboard data
    context.read<EnhancedDashboardBloc>().add( LoadDashboardDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('dashboard.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<EnhancedDashboardBloc>().add( LoadDashboardDataEvent());
        },
        child: BlocBuilder<EnhancedDashboardBloc, EnhancedDashboardState>(
          builder: (context, state) {
            if (state is EnhancedDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EnhancedDashboardLoaded) {
              return _buildDashboardContent(context, state);
            } else if (state is EnhancedDashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EnhancedDashboardBloc>().add(
                               LoadDashboardDataEvent(),
                            );
                      },
                      child: Text(context.tr.translate('common.retry')),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, EnhancedDashboardLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Overview
            TodaysOverviewWidget(data: state.todaysOverview),
            const SizedBox(height: 20),
            
            // Task Progress
            TaskProgressWidget(progressData: state.taskProgress),
            const SizedBox(height: 20),
            
            // Upcoming Reminders
            UpcomingRemindersWidget(reminders: state.upcomingReminders),
            const SizedBox(height: 20),
            
            // Motivational Snippet
            MotivationalSnippetWidget(snippet: state.motivationalSnippet),
            const SizedBox(height: 20),
            
            // Quick Access
            QuickAccessWidget(quickActions: state.quickActions),
          ],
        ),
      ),
    );
  }
}