import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/presentation/bloc/task_bloc.dart';

/// Page to display the list of tasks for the day
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add task page
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return _TaskList(tasks: state.tasks);
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTodaysTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Widget to display the list of tasks
class _TaskList extends StatelessWidget {
  final List<Task> tasks;

  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks for today'),
      );
    }

    // Group tasks by time block
    final morningTasks = tasks.where((task) => task.timeBlock == TimeBlock.morning).toList();
    final workTasks = tasks.where((task) => task.timeBlock == TimeBlock.work).toList();
    final eveningTasks = tasks.where((task) => task.timeBlock == TimeBlock.evening).toList();
    final nightTasks = tasks.where((task) => task.timeBlock == TimeBlock.night).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (morningTasks.isNotEmpty) ...[
              const _TimeBlockHeader(title: 'Morning'),
              ...morningTasks.map((task) => _TaskItem(task: task)).toList(),
              const SizedBox(height: 20),
            ],
            if (workTasks.isNotEmpty) ...[
              const _TimeBlockHeader(title: 'Work Hours'),
              ...workTasks.map((task) => _TaskItem(task: task)).toList(),
              const SizedBox(height: 20),
            ],
            if (eveningTasks.isNotEmpty) ...[
              const _TimeBlockHeader(title: 'Evening'),
              ...eveningTasks.map((task) => _TaskItem(task: task)).toList(),
              const SizedBox(height: 20),
            ],
            if (nightTasks.isNotEmpty) ...[
              const _TimeBlockHeader(title: 'Night'),
              ...nightTasks.map((task) => _TaskItem(task: task)).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget to display a time block header
class _TimeBlockHeader extends StatelessWidget {
  final String title;

  const _TimeBlockHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget to display a single task item
class _TaskItem extends StatelessWidget {
  final Task task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: _TaskStatusIndicator(status: task.status),
        title: Text(task.title),
        subtitle: Text(
          _getCategoryName(task.category),
          style: TextStyle(
            color: _getCategoryColor(task.category),
          ),
        ),
        trailing: _TaskPriorityIndicator(priority: task.priority),
        onTap: () {
          // TODO: Navigate to task detail page
        },
      ),
    );
  }
}

/// Widget to display task status indicator
class _TaskStatusIndicator extends StatelessWidget {
  final TaskStatus status;

  const _TaskStatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case TaskStatus.pending:
        color = Colors.grey;
        icon = Icons.radio_button_unchecked;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        icon = Icons.hourglass_bottom;
        break;
      case TaskStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case TaskStatus.skipped:
        color = Colors.orange;
        icon = Icons.skip_next;
        break;
      case TaskStatus.overdue:
        color = Colors.red;
        icon = Icons.warning;
        break;
    }

    return Icon(icon, color: color);
  }
}

/// Widget to display task priority indicator
class _TaskPriorityIndicator extends StatelessWidget {
  final int priority;

  const _TaskPriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    if (priority <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        priority,
        (index) => const Icon(Icons.flag, color: Colors.red, size: 16),
      ),
    );
  }
}

/// Get category name as string
String _getCategoryName(TaskCategory category) {
  switch (category) {
    case TaskCategory.ibadah:
      return 'Ibadah';
    case TaskCategory.programming:
      return 'Programming';
    case TaskCategory.selfDevelopment:
      return 'Self Development';
    case TaskCategory.other:
      return 'Other';
  }
}

/// Get category color
Color _getCategoryColor(TaskCategory category) {
  switch (category) {
    case TaskCategory.ibadah:
      return Colors.green;
    case TaskCategory.programming:
      return Colors.blue;
    case TaskCategory.selfDevelopment:
      return Colors.purple;
    case TaskCategory.other:
      return Colors.grey;
  }
}