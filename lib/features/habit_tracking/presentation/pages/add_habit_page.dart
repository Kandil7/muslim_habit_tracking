import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/habit.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';

/// Page for adding a new habit
class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = AppConstants.prayerHabit;
  String _selectedIcon = 'prayer_mat';
  String _selectedColor = '#1F7A5D';
  int _goal = 1;
  String _goalUnit = 'times';
  final List<String> _selectedDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  int? _targetStreak;
  double? _targetCompletionRate;

  final List<Map<String, dynamic>> _habitTypes = [
    {
      'value': AppConstants.prayerHabit,
      'label': 'Prayer',
      'icon': Icons.mosque,
    },
    {
      'value': AppConstants.quranHabit,
      'label': 'Quran',
      'icon': Icons.menu_book,
    },
    {
      'value': AppConstants.fastingHabit,
      'label': 'Fasting',
      'icon': Icons.no_food,
    },
    {'value': AppConstants.dhikrHabit, 'label': 'Dhikr', 'icon': Icons.repeat},
    {
      'value': AppConstants.charityHabit,
      'label': 'Charity',
      'icon': Icons.volunteer_activism,
    },
    {
      'value': AppConstants.customHabit,
      'label': 'Custom',
      'icon': Icons.add_task,
    },
  ];

  final List<Map<String, dynamic>> _habitIcons = [
    {'value': 'prayer_mat', 'icon': Icons.mosque},
    {'value': 'quran', 'icon': Icons.menu_book},
    {'value': 'fasting', 'icon': Icons.no_food},
    {'value': 'dhikr', 'icon': Icons.repeat},
    {'value': 'charity', 'icon': Icons.volunteer_activism},
    {'value': 'custom', 'icon': Icons.add_task},
    {'value': 'tahajjud', 'icon': Icons.nightlight},
    {'value': 'duha', 'icon': Icons.wb_sunny},
    {'value': 'exercise', 'icon': Icons.fitness_center},
    {'value': 'reading', 'icon': Icons.book},
  ];

  final List<Map<String, dynamic>> _habitColors = [
    {'value': '#1F7A5D', 'color': AppColors.primary},
    {'value': '#D4AF37', 'color': AppColors.secondary},
    {'value': '#4CAF50', 'color': AppColors.success},
    {'value': '#2196F3', 'color': AppColors.info},
    {'value': '#FFC107', 'color': AppColors.warning},
    {'value': '#B00020', 'color': AppColors.error},
    {'value': '#9575CD', 'color': AppColors.ishaColor},
    {'value': '#FF8A65', 'color': AppColors.maghribColor},
    {'value': '#FFB74D', 'color': AppColors.asrColor},
    {'value': '#FFD54F', 'color': AppColors.dhuhrColor},
  ];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Habit')),
      body: BlocListener<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Habit created successfully!'),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Habit type
                Text('Habit Type', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                _buildHabitTypeSelector(),
                const SizedBox(height: 24),

                // Habit name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    hintText: 'e.g., Tahajjud Prayer',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a habit name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Habit description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'e.g., Wake up for Tahajjud prayer before Fajr',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Habit icon
                Text('Icon', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                _buildIconSelector(),
                const SizedBox(height: 24),

                // Habit color
                Text('Color', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                _buildColorSelector(),
                const SizedBox(height: 24),

                // Habit goal
                Text('Goal', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: _goal.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final number = int.tryParse(value);
                          if (number != null && number > 0) {
                            setState(() {
                              _goal = number;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _goalUnit,
                        decoration: const InputDecoration(labelText: 'Unit'),
                        items: const [
                          DropdownMenuItem(
                            value: 'times',
                            child: Text('Times'),
                          ),
                          DropdownMenuItem(
                            value: 'pages',
                            child: Text('Pages'),
                          ),
                          DropdownMenuItem(
                            value: 'minutes',
                            child: Text('Minutes'),
                          ),
                          DropdownMenuItem(
                            value: 'hours',
                            child: Text('Hours'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _goalUnit = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Days of week
                Text('Days of Week', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                _buildDaysOfWeekSelector(),
                const SizedBox(height: 24),

                // Gamification settings
                Text(
                  'Gamification Settings',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 8),

                // Target streak
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target Streak (Optional)',
                    hintText: 'e.g., 30 days',
                    helperText: 'Set a streak goal to earn badges',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _targetStreak = int.tryParse(value);
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Target completion rate
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target Completion Rate % (Optional)',
                    hintText: 'e.g., 80',
                    helperText: 'Set a completion rate goal (0-100)',
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null && parsed >= 0 && parsed <= 100) {
                      setState(() {
                        _targetCompletionRate = parsed;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Create Habit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _habitTypes.map((type) {
            final isSelected = _selectedType == type['value'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedType = type['value'];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type['icon'],
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type['label'],
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildIconSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          _habitIcons.map((iconData) {
            final isSelected = _selectedIcon == iconData['value'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['value'];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                ),
                child: Icon(
                  iconData['icon'],
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          _habitColors.map((colorData) {
            final isSelected = _selectedColor == colorData['value'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = colorData['value'];
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorData['color'],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: colorData['color'].withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                          : null,
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDaysOfWeekSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _daysOfWeek.map((day) {
            final isSelected = _selectedDays.contains(day);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_selectedDays.length > 1) {
                      _selectedDays.remove(day);
                    }
                  } else {
                    _selectedDays.add(day);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                ),
                child: Center(
                  child: Text(
                    day.substring(0, 1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        type: _selectedType,
        icon: _selectedIcon,
        color: _selectedColor,
        goal: _goal,
        goalUnit: _goalUnit,
        daysOfWeek: _selectedDays,
        isActive: true,
        createdAt: DateTime.now(),
        targetStreak: _targetStreak,
        targetCompletionRate: _targetCompletionRate,
      );

      context.read<HabitBloc>().add(CreateHabitEvent(habit: habit));
    }
  }
}
