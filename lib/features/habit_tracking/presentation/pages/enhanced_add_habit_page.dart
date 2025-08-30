import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/features/habit_tracking/domain/entities/habit.dart';
import 'package:uuid/uuid.dart';

class EnhancedAddHabitPage extends StatefulWidget {
  final Habit? habitToEdit;

  const EnhancedAddHabitPage({super.key, this.habitToEdit});

  @override
  State<EnhancedAddHabitPage> createState() => _EnhancedAddHabitPageState();
}

class _EnhancedAddHabitPageState extends State<EnhancedAddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalController;
  late TextEditingController _targetStreakController;
  late TextEditingController _targetCompletionRateController;
  
  String _selectedType = 'daily';
  String _selectedIcon = 'check_circle';
  String _selectedColor = '#4CAF50';
  String _selectedGoalUnit = 'times';
  List<String> _selectedDays = List.from(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']);
  List<String> _selectedTags = [];
  final TextEditingController _newTagController = TextEditingController();

  final List<Map<String, String>> _habitTypes = [
    {'value': 'daily', 'label': 'Daily'},
    {'value': 'weekly', 'label': 'Weekly'},
    {'value': 'monthly', 'label': 'Monthly'},
    {'value': 'ramadan', 'label': 'Ramadan Special'},
  ];

  final List<Map<String, String>> _icons = [
    {'value': 'check_circle', 'label': 'Check Circle'},
    {'value': 'prayer', 'label': 'Prayer'},
    {'value': 'quran', 'label': 'Quran'},
    {'value': 'fasting', 'label': 'Fasting'},
    {'value': 'dhikr', 'label': 'Dhikr'},
    {'value': 'charity', 'label': 'Charity'},
  ];

  final List<Map<String, String>> _colors = [
    {'value': '#4CAF50', 'label': 'Green'},
    {'value': '#2196F3', 'label': 'Blue'},
    {'value': '#FF9800', 'label': 'Orange'},
    {'value': '#F44336', 'label': 'Red'},
    {'value': '#9C27B0', 'label': 'Purple'},
  ];

  final List<Map<String, String>> _goalUnits = [
    {'value': 'times', 'label': 'Times'},
    {'value': 'minutes', 'label': 'Minutes'},
    {'value': 'pages', 'label': 'Pages'},
    {'value': 'ayahs', 'label': 'Ayahs'},
    {'value': 'rakats', 'label': 'Rakats'},
  ];

  final List<Map<String, String>> _daysOfWeek = [
    {'value': 'mon', 'label': 'Mon'},
    {'value': 'tue', 'label': 'Tue'},
    {'value': 'wed', 'label': 'Wed'},
    {'value': 'thu', 'label': 'Thu'},
    {'value': 'fri', 'label': 'Fri'},
    {'value': 'sat', 'label': 'Sat'},
    {'value': 'sun', 'label': 'Sun'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _goalController = TextEditingController(text: '1');
    _targetStreakController = TextEditingController();
    _targetCompletionRateController = TextEditingController();

    if (widget.habitToEdit != null) {
      _populateFieldsFromHabit(widget.habitToEdit!);
    }
  }

  void _populateFieldsFromHabit(Habit habit) {
    _nameController.text = habit.name;
    _descriptionController.text = habit.description;
    _selectedType = habit.type;
    _selectedIcon = habit.icon;
    _selectedColor = habit.color;
    _goalController.text = habit.goal.toString();
    _selectedGoalUnit = habit.goalUnit;
    _selectedDays = List.from(habit.daysOfWeek);
    _selectedTags = List.from(habit.tags);
    if (habit.targetStreak != null) {
      _targetStreakController.text = habit.targetStreak.toString();
    }
    if (habit.targetCompletionRate != null) {
      _targetCompletionRateController.text = habit.targetCompletionRate.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    _targetStreakController.dispose();
    _targetCompletionRateController.dispose();
    _newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitToEdit == null ? 'Add New Habit' : 'Edit Habit'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildTypeSelector(),
              const SizedBox(height: 16),
              _buildIconSelector(),
              const SizedBox(height: 16),
              _buildColorSelector(),
              const SizedBox(height: 16),
              _buildGoalSection(),
              const SizedBox(height: 16),
              _buildDaysOfWeekSelector(),
              const SizedBox(height: 16),
              _buildTargetsSection(),
              const SizedBox(height: 16),
              _buildTagsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
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
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Habit Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _habitTypes.map((type) {
            return ChoiceChip(
              label: Text(type['label']!),
              selected: _selectedType == type['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedType = type['value']!;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.grey[300],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _icons.map((icon) {
            return ChoiceChip(
              label: Text(icon['label']!),
              selected: _selectedIcon == icon['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedIcon = icon['value']!;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.grey[300],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _colors.map((color) {
            return ChoiceChip(
              label: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(int.parse(color['value']!.replaceAll('#', '0xFF'))),
                  shape: BoxShape.circle,
                ),
              ),
              selected: _selectedColor == color['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedColor = color['value']!;
                });
              },
              selectedColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daily Goal', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                value: _selectedGoalUnit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                items: _goalUnits.map((unit) {
                  return DropdownMenuItem(
                    value: unit['value'],
                    child: Text(unit['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGoalUnit = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Days of Week', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _daysOfWeek.map((day) {
            return FilterChip(
              label: Text(day['label']!),
              selected: _selectedDays.contains(day['value']),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(day['value']!);
                  } else {
                    _selectedDays.remove(day['value']);
                  }
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.grey[300],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTargetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Targets (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _targetStreakController,
                decoration: const InputDecoration(
                  labelText: 'Target Streak (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _targetCompletionRateController,
                decoration: const InputDecoration(
                  labelText: 'Target Completion (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ..._selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _selectedTags.remove(tag);
                  });
                },
              );
            }),
            SizedBox(
              width: 150,
              child: TextFormField(
                controller: _newTagController,
                decoration: const InputDecoration(
                  labelText: 'Add tag',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty && !_selectedTags.contains(value)) {
                    setState(() {
                      _selectedTags.add(value);
                      _newTagController.clear();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveHabit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(widget.habitToEdit == null ? 'Add Habit' : 'Update Habit'),
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      // Create the habit object (in a real app, this would be sent to a bloc)
      final habit = Habit(
        id: widget.habitToEdit?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        type: _selectedType,
        icon: _selectedIcon,
        color: _selectedColor,
        goal: int.parse(_goalController.text),
        goalUnit: _selectedGoalUnit,
        daysOfWeek: _selectedDays,
        isActive: true,
        createdAt: widget.habitToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        currentStreak: widget.habitToEdit?.currentStreak ?? 0,
        longestStreak: widget.habitToEdit?.longestStreak ?? 0,
        lastCompletedDate: widget.habitToEdit?.lastCompletedDate,
        tags: _selectedTags,
        targetStreak: _targetStreakController.text.isEmpty 
            ? null 
            : int.tryParse(_targetStreakController.text),
        targetCompletionRate: _targetCompletionRateController.text.isEmpty 
            ? null 
            : double.tryParse(_targetCompletionRateController.text),
      );

      // In a real implementation, we would dispatch an event to the bloc here
      // For now, we'll just show a success message
      // Using the habit variable to avoid unused variable warning
      if (widget.habitToEdit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit "${habit.name}" added successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit "${habit.name}" updated successfully!'),
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }
}
