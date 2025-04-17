import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';
import '../../domain/utils/streak_calculator.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';

/// Page for viewing habit details and tracking progress
class HabitDetailsPage extends StatefulWidget {
  final Habit habit;

  const HabitDetailsPage({super.key, required this.habit});

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  late Habit _habit;
  List<HabitLog> _logs = [];
  bool _isLoading = true;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
    _valueController.text = _habit.goal.toString();
    _loadLogs();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadLogs() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 30));

    context.read<HabitBloc>().add(
      GetHabitLogsByDateRangeEvent(
        habitId: _habit.id,
        startDate: startDate,
        endDate: now,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_habit.name),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.notification),
            onPressed: () {
              _showReminderDialog();
            },
            tooltip: 'Set Reminder',
          ),
          IconButton(
            icon: const Icon(AppIcons.edit),
            onPressed: () {
              // TODO: Navigate to edit habit page
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Habit'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitLogsLoaded) {
            setState(() {
              _logs = state.habitLogs;
              _isLoading = false;
            });
          } else if (state is HabitLogCreated) {
            setState(() {
              _logs = [..._logs, state.habitLog];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Progress tracked successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is HabitUpdated) {
            setState(() {
              _habit = state.habit;
            });
          } else if (state is HabitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHabitHeader(),
                const SizedBox(height: 24),
                _buildProgressSection(),
                const SizedBox(height: 24),
                _buildTrackingSection(),
                const SizedBox(height: 24),
                _buildHistorySection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHabitHeader() {
    final Color habitColor = Color(int.parse('0xFF${_habit.color.substring(1)}'));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: habitColor,
                  radius: 24,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _habit.name,
                        style: AppTextStyles.headingMedium,
                      ),
                      Text(
                        _habit.type.toUpperCase(),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_habit.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _habit.description,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('Goal', '${_habit.goal} ${_habit.goalUnit}'),
                _buildInfoItem('Frequency', _habit.daysOfWeek.length == 7 ? 'Daily' : '${_habit.daysOfWeek.length} days/week'),
                _buildInfoItem('Created', DateTimeUtils.formatShortDate(_habit.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final today = DateTimeUtils.today;
    final bool completedToday = _logs.any((log) => DateTimeUtils.isSameDay(log.date, today)) ||
                               (_habit.lastCompletedDate != null && DateTimeUtils.isSameDay(_habit.lastCompletedDate!, today));

    // Use the streak from the habit entity if available, otherwise calculate it
    final int currentStreak = _habit.currentStreak > 0 ? _habit.currentStreak : StreakCalculator.calculateCurrentStreak(_logs, _habit.lastCompletedDate);
    final int longestStreak = _habit.longestStreak > 0 ? _habit.longestStreak : StreakCalculator.calculateLongestStreak(_logs);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTextStyles.headingSmall,
                ),
                if (currentStreak > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.secondary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$currentStreak day streak!',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressItem(
                  'Today',
                  completedToday ? 'Completed' : 'Not Yet',
                  completedToday ? Icons.check_circle : Icons.pending,
                  completedToday ? AppColors.success : AppColors.warning,
                ),
                _buildProgressItem(
                  'Current Streak',
                  '$currentStreak days',
                  Icons.local_fire_department,
                  AppColors.secondary,
                ),
                _buildProgressItem(
                  'Longest Streak',
                  '$longestStreak days',
                  Icons.emoji_events,
                  AppColors.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _logs.length / 30, // Progress for the month
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${_logs.length} days completed this month',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTrackingSection() {
    final today = DateTimeUtils.today;
    final bool completedToday = _logs.any((log) => DateTimeUtils.isSameDay(log.date, today));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Progress',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 16),
            if (completedToday)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completed Today',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Great job! Keep up the good work.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _valueController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Value',
                            hintText: 'e.g., ${_habit.goal}',
                            suffixText: _habit.goalUnit,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Add any notes about your progress',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _trackProgress,
                      child: const Text('Mark as Completed'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_logs.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No history yet',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your progress to see your history',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sort logs by date (newest first)
    _logs.sort((a, b) => b.date.compareTo(a.date));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.success,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    DateTimeUtils.formatDate(log.date),
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: log.notes.isNotEmpty
                      ? Text(log.notes)
                      : Text('${log.value} ${_habit.goalUnit}'),
                  trailing: Text(
                    DateTimeUtils.formatTime(log.createdAt),
                    style: AppTextStyles.bodySmall,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _trackProgress() {
    final value = int.tryParse(_valueController.text) ?? _habit.goal;
    final now = DateTime.now();

    final habitLog = HabitLog(
      id: const Uuid().v4(),
      habitId: _habit.id,
      date: now,
      value: value,
      notes: _notesController.text,
      createdAt: now,
    );

    // Create the habit log
    context.read<HabitBloc>().add(CreateHabitLogEvent(habitLog: habitLog));

    // Update streak information
    context.read<HabitBloc>().add(UpdateStreakEvent(
      habitId: _habit.id,
      logDate: now,
    ));

    // Clear the notes field
    _notesController.clear();
  }

  // This method is kept for backward compatibility but now uses StreakCalculator
  int _calculateCurrentStreak() {
    return StreakCalculator.calculateCurrentStreak(_logs, _habit.lastCompletedDate);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${_habit.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HabitBloc>().add(DeleteHabitEvent(id: _habit.id));
              Navigator.pop(context); // Return to habits list
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showReminderDialog() {
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Set Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set a daily reminder for "${_habit.name}"',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reminder Time',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ///TODO: Schedule the reminder
                  // Schedule the reminder

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminder set successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Set Reminder'),
              ),
            ],
          );
        },
      ),
    );
  }
}
