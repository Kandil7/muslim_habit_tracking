import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget for selecting days of the week
class DaySelector extends StatelessWidget {
  final List<String> selectedDays;
  final Function(String, bool) onDaySelected;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final isSelected = selectedDays.contains(day);
        return _DayChip(
          day: day,
          isSelected: isSelected,
          onSelected: (selected) => onDaySelected(day, selected),
        );
      }).toList(),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool isSelected;
  final Function(bool) onSelected;

  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(day.substring(0, 3)),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: AppColors.lightGrey,
      selectedColor: AppColors.primary.withAlpha(150),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
