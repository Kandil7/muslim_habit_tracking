import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/day_selector.dart';

/// Page for editing an existing habit
class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({super.key, required this.habit});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalController;
  late String _goalUnit;
  late String _habitType;
  late List<String> _selectedDays;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing habit data
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController = TextEditingController(text: widget.habit.description);
    _goalController = TextEditingController(text: widget.habit.goal.toString());
    _goalUnit = widget.habit.goalUnit;
    _habitType = widget.habit.type;
    _selectedDays = List.from(widget.habit.daysOfWeek);
    _selectedColor = Color(int.parse('0xFF${widget.habit.color.substring(1)}'));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveHabit,
          ),
        ],
      ),
      body: BlocListener<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Habit updated successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is HabitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    hintText: 'e.g., Read Quran',
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
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'e.g., Read at least one page daily',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Goal',
                          hintText: 'e.g., 1',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goal';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _goalUnit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'pages', child: Text('Pages')),
                          DropdownMenuItem(value: 'minutes', child: Text('Minutes')),
                          DropdownMenuItem(value: 'times', child: Text('Times')),
                          DropdownMenuItem(value: 'rakats', child: Text('Rakats')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _goalUnit = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _habitType,
                  decoration: const InputDecoration(
                    labelText: 'Habit Type',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'prayer', child: Text('Prayer')),
                    DropdownMenuItem(value: 'quran', child: Text('Quran')),
                    DropdownMenuItem(value: 'dhikr', child: Text('Dhikr')),
                    DropdownMenuItem(value: 'fasting', child: Text('Fasting')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _habitType = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Frequency',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 8),
                DaySelector(
                  selectedDays: _selectedDays,
                  onDaySelected: (day, isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Color',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 8),
                _buildColorSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final isSelected = _selectedColor.value == color.value;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withAlpha(100),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one day'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      // Create updated habit
      final updatedHabit = widget.habit.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        goal: int.parse(_goalController.text),
        goalUnit: _goalUnit,
        type: _habitType,
        daysOfWeek: _selectedDays,
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      );

      // Update the habit
      context.read<HabitBloc>().add(UpdateHabitEvent(habit: updatedHabit));
    }
  }
}
