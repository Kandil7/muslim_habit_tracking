import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muslim_habbit/core/theme/bloc/theme_bloc_exports.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/services/cache_manager.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../dua_dhikr/domain/entities/dua.dart';
import '../../../dua_dhikr/domain/entities/dhikr.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_event.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_state.dart';
import '../../../dua_dhikr/presentation/pages/dhikr_counter_page.dart';

import '../../../home/presentation/pages/home_dashboard_page.dart';
import '../../../prayer_times/presentation/views/prayer_view.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import 'add_habit_page.dart';
import 'habit_details_page.dart';
import 'settings_page.dart';

/// The main home page of the application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboardPage(),
    const HabitDashboardPage(),
    const PrayerView(),
    const DuaDhikrPage(),
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.homeOutlined),
            activeIcon: Icon(AppIcons.home),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.prayerOutlined),
            activeIcon: Icon(AppIcons.prayer),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.duaOutlined),
            activeIcon: Icon(AppIcons.dua),
            label: 'Dua',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.analyticsOutlined),
            activeIcon: Icon(AppIcons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.settingsOutlined),
            activeIcon: Icon(AppIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

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
                MaterialPageRoute(
                  builder: (context) => const AddHabitPage(),
                ),
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
                    onPressed: () => context.read<HabitBloc>().add(GetHabitsEvent()),
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
            MaterialPageRoute(
              builder: (context) => const AddHabitPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"? This action cannot be undone.'),
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
                          content: Text('Undo is not implemented in this demo'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
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
    final descriptionController = TextEditingController(text: habit.description);
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
      builder: (context) => StatefulBuilder(
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
                      children: habitColors.map((colorData) {
                        final isSelected = selectedColor == colorData['value'];
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
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: colorData['color'].withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
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

                    context.read<HabitBloc>().add(UpdateHabitEvent(habit: updatedHabit));
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
        final isCompletedToday = false; // This would come from habit logs in a real implementation

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: GestureDetector(
              onTap: () {
                _quickMarkHabitCompleted(context, habit);
              },
              child: CircleAvatar(
                backgroundColor: Color(int.parse('0xFF${habit.color.substring(1)}')),
                child: Icon(
                  isCompletedToday ? Icons.check : _getIconForHabitType(habit.type),
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              habit.name,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              habit.description,
              style: AppTextStyles.bodySmall,
            ),
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
              itemBuilder: (context) => [
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


/// Dua & Dhikr page
class DuaDhikrPage extends StatefulWidget {
  const DuaDhikrPage({super.key});

  @override
  State<DuaDhikrPage> createState() => _DuaDhikrPageState();
}

class _DuaDhikrPageState extends State<DuaDhikrPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua & Dhikr'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Duas'),
            Tab(text: 'Dhikr'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDuasTab(),
          _buildDhikrTab(),
        ],
      ),
    );
  }

  Widget _buildDuasTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DuaDhikrLoading) {
          return const LoadingIndicator(text: 'Loading duas...');
        } else if (state is DuasLoaded) {
          return _buildDuasList(state.duas);
        } else {
          // Trigger loading of duas by category
          context.read<DuaDhikrBloc>().add(const GetDuasByCategoryEvent(category: 'Morning'));
          return const LoadingIndicator(text: 'Loading duas...');
        }
      },
    );
  }

  Widget _buildDuasList(List<Dua> duas) {
    if (duas.isEmpty) {
      return const EmptyState(
        title: 'No Duas Available',
        message: 'Please check your connection and try again',
        icon: Icons.menu_book,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              dua.title,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              dua.category,
              style: AppTextStyles.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(
                dua.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: dua.isFavorite ? AppColors.secondary : null,
              ),
              onPressed: () {
                context.read<DuaDhikrBloc>().add(ToggleDuaFavoriteEvent(id: dua.id));
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text
                    Text(
                      dua.arabicText,
                      style: AppTextStyles.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Transliteration
                    Text(
                      dua.transliteration,
                      style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    Text(
                      dua.translation,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Reference
                    Text(
                      dua.reference,
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDhikrTab() {
    return BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
      builder: (context, state) {
        if (state is DuaDhikrLoading) {
          return const LoadingIndicator(text: 'Loading dhikrs...');
        } else if (state is DhikrsLoaded) {
          return _buildDhikrList(state.dhikrs);
        } else {
          // Trigger loading of dhikrs
          context.read<DuaDhikrBloc>().add(GetAllDhikrsEvent());
          return const LoadingIndicator(text: 'Loading dhikrs...');
        }
      },
    );
  }

  Widget _buildDhikrList(List<Dhikr> dhikrs) {
    if (dhikrs.isEmpty) {
      return const EmptyState(
        title: 'No Dhikrs Available',
        message: 'Please check your connection and try again',
        icon: Icons.repeat,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = dhikrs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              dhikr.title,
              style: AppTextStyles.headingSmall,
            ),
            subtitle: Text(
              'Recommended: ${dhikr.recommendedCount} times',
              style: AppTextStyles.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(
                dhikr.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: dhikr.isFavorite ? AppColors.secondary : null,
              ),
              onPressed: () {
                context.read<DuaDhikrBloc>().add(ToggleDhikrFavoriteEvent(id: dhikr.id));
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text
                    Text(
                      dhikr.arabicText,
                      style: AppTextStyles.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Transliteration
                    Text(
                      dhikr.transliteration,
                      style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    Text(
                      dhikr.translation,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Reference
                    Text(
                      dhikr.reference,
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    // Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Count'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DhikrCounterPage(dhikr: dhikr),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
