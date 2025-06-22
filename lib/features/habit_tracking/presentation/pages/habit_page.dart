import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muslim_habbit/core/theme/bloc/theme_bloc_exports.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../../core/theme/app_icons.dart';

import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import 'add_habit_page.dart';
import 'habit_details_page.dart';

/// The main home page of the application

/// Habit Dashboard page
class HabitDashboardPage extends StatelessWidget {
  const HabitDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunnahTrack'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.dark
                      ? AppIcons.themeDark
                      : AppIcons.themeLight,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
                tooltip: 'Toggle Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddHabitPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading) {
            return const LoadingIndicator(text: 'Loading habits...');
          } else if (state is HabitsLoaded) {
            return _buildHabitsList(context, state.habits);
          } else if (state is HabitError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Try Again',
                    onPressed:
                        () => context.read<HabitBloc>().add(GetHabitsEvent()),
                    buttonType: ButtonType.primary,
                  ),
                ],
              ),
            );
          } else {
            return const EmptyState(
              title: 'No Habits Found',
              message: 'Start tracking your habits by adding one!',
              icon: Icons.track_changes,
              actionText: 'Add Habit',
              onAction: null, // Will use FAB instead
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHabitPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: Text(
              'Are you sure you want to delete "${habit.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<HabitBloc>().add(DeleteHabitEvent(id: habit.id));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${habit.name}" has been deleted'),
                      backgroundColor: AppColors.error,
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: Colors.white,
                        onPressed: () {
                          // This is a simplified approach - in a real app, you'd need to store the full habit data
                          // and re-create it with the same ID
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Undo is not implemented in this demo',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }

  void _quickMarkHabitCompleted(BuildContext context, Habit habit) {
    // Create a habit log for today
    final habitLog = HabitLog(
      id: const Uuid().v4(),
      habitId: habit.id,
      date: DateTime.now(),
      value: habit.goal,
      notes: 'Completed via quick action',
      createdAt: DateTime.now(),
    );

    // Add the habit log
    context.read<HabitBloc>().add(CreateHabitLogEvent(habitLog: habitLog));

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.name} marked as completed'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _getIconForHabitType(String type) {
    switch (type) {
      case 'prayer':
        return Icons.mosque;
      case 'quran':
        return Icons.menu_book;
      case 'fasting':
        return Icons.no_food;
      case 'dhikr':
        return Icons.repeat;
      case 'charity':
        return Icons.volunteer_activism;
      default:
        return Icons.check_circle_outline;
    }
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final nameController = TextEditingController(text: habit.name);
    final descriptionController = TextEditingController(
      text: habit.description,
    );
    final formKey = GlobalKey<FormState>();
    String selectedColor = habit.color;

    final List<Map<String, dynamic>> habitColors = [
      {'value': '#1F7A5D', 'color': AppColors.primary},
      {'value': '#D4AF37', 'color': AppColors.secondary},
      {'value': '#4CAF50', 'color': AppColors.success},
      {'value': '#2196F3', 'color': AppColors.info},
      {'value': '#FFC107', 'color': AppColors.warning},
      {'value': '#B00020', 'color': AppColors.error},
      {'value': '#9575CD', 'color': AppColors.ishaColor},
      {'value': '#FF8A65', 'color': AppColors.maghribColor},
    ];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Edit Habit'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Habit Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a habit name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        const Text('Color'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              habitColors.map((colorData) {
                                final isSelected =
                                    selectedColor == colorData['value'];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = colorData['value'];
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: colorData['color'],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow:
                                          isSelected
                                              ? [
                                                BoxShadow(
                                                  color: colorData['color']
                                                      .withOpacity(0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child:
                                        isSelected
                                            ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                            : null,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final updatedHabit = habit.copyWith(
                          name: nameController.text,
                          description: descriptionController.text,
                          color: selectedColor,
                        );

                        context.read<HabitBloc>().add(
                          UpdateHabitEvent(habit: updatedHabit),
                        );
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Habit updated successfully'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildHabitsList(BuildContext context, List<Habit> habits) {
    if (habits.isEmpty) {
      return const EmptyState(
        title: 'No habits yet',
        message: 'Tap the + button to add your first habit',
        icon: Icons.track_changes,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        // Check if habit is completed today
        final now = DateTime.now();
        final isCompletedToday =
            habit.lastCompletedDate != null &&
            now.day == habit.lastCompletedDate!.day;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: GestureDetector(
              onTap: () {
                _quickMarkHabitCompleted(context, habit);
              },
              child: CircleAvatar(
                backgroundColor: Color(
                  int.parse('0xFF${habit.color.substring(1)}'),
                ),
                child: Icon(
                  isCompletedToday
                      ? Icons.check
                      : _getIconForHabitType(habit.type),
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(habit.name, style: AppTextStyles.headingSmall),
            subtitle: Text(habit.description, style: AppTextStyles.bodySmall),
            trailing: PopupMenuButton<String>(
              icon: const Icon(AppIcons.more),
              onSelected: (value) {
                if (value == 'view') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitDetailsPage(habit: habit),
                    ),
                  );
                } else if (value == 'edit') {
                  _showEditHabitDialog(context, habit);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, habit);
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem<String>(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(AppIcons.info),
                          SizedBox(width: 8),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(AppIcons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(AppIcons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailsPage(habit: habit),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
