import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/bloc/theme_bloc_exports.dart';
import '../../../habit_tracking/presentation/bloc/habit_bloc.dart';
import '../../../habit_tracking/presentation/bloc/habit_event.dart';
import '../../../habit_tracking/presentation/bloc/habit_state.dart';
import '../../../prayer_times/presentation/manager/prayer/prayer_cubit.dart';
import '../../../prayer_times/presentation/manager/prayer/prayer_state.dart';
import '../../domain/models/dashboard_card_model.dart';
import '../../domain/models/quick_action_model.dart';
import '../bloc/home_dashboard_bloc.dart';
import '../bloc/home_dashboard_event.dart';
import '../bloc/home_dashboard_state.dart';
import '../widgets/animated_dashboard_card.dart';
import '../widgets/customizable_quick_actions.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/hadith_card.dart';
import '../widgets/habits_summary_card.dart';
import '../widgets/islamic_calendar_card.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/qibla_direction_card.dart';
import '../widgets/quran_card.dart';

/// The main home dashboard page
class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isEditMode = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Load dashboard data
    context.read<HomeDashboardBloc>().add(const LoadHomeDashboardEvent());

    // Load habits
    context.read<HabitBloc>().add(GetHabitsEvent());

    // Load prayer times
    context.read<PrayerCubit>().getPrayerTimes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunnahTrack'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _isEditMode
                  ? const Icon(Icons.check, key: ValueKey('check'))
                  : const Icon(Icons.edit, key: ValueKey('edit')),
            ),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
                if (_isEditMode) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            tooltip: _isEditMode ? 'Save changes' : 'Edit dashboard',
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
                tooltip: 'Toggle Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeDashboardBloc, HomeDashboardState>(
        builder: (context, state) {
          if (state is HomeDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeDashboardLoaded) {
            return _buildDashboard(context, state);
          } else if (state is HomeDashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeDashboardBloc>().add(
                            const LoadHomeDashboardEvent(),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, HomeDashboardLoaded state) {
    // Filter visible cards and sort by order
    final visibleCards = state.dashboardCards
        .where((card) => card.isVisible)
        .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
        context.read<PrayerCubit>().getPrayerTimes(forceRefresh: true);
        context.read<HabitBloc>().add(GetHabitsEvent());
        context.read<HomeDashboardBloc>().add(const LoadHomeDashboardEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting section
              _buildGreetingSection(context, state.userName),
              const SizedBox(height: 24),

              // Dashboard cards
              ...visibleCards.map((card) => _buildCardWidget(context, card, state)),

              // Quick actions section
              const SizedBox(height: 24),
              CustomizableQuickActions(
                quickActions: state.quickActions,
                onActionTap: _handleQuickAction,
                isEditable: _isEditMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWidget(BuildContext context, DashboardCardModel card, HomeDashboardLoaded state) {
    switch (card.id) {
      case 'prayer':
        return Column(
          children: [
            _buildPrayerTimesSection(context),
            const SizedBox(height: 24),
          ],
        );
      case 'habits':
        return Column(
          children: [
            _buildHabitsSection(context),
            const SizedBox(height: 24),
          ],
        );
      case 'quran':
        return Column(
          children: [
            QuranCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle: () => _toggleCardVisibility(context, 'quran'),
              isVisible: true,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 'dhikr':
        return Column(
          children: [
            DhikrCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle: () => _toggleCardVisibility(context, 'dhikr'),
              isVisible: true,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 'calendar':
        return Column(
          children: [
            IslamicCalendarCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle: () => _toggleCardVisibility(context, 'calendar'),
              isVisible: true,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 'qibla':
        return Column(
          children: [
            QiblaDirectionCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle: () => _toggleCardVisibility(context, 'qibla'),
              isVisible: true,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 'hadith':
        return Column(
          children: [
            HadithCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle: () => _toggleCardVisibility(context, 'hadith'),
              isVisible: true,
            ),
            const SizedBox(height: 24),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showReorderDialog(BuildContext context, HomeDashboardLoaded state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder Dashboard Cards'),
        content: SizedBox(
          width: double.maxFinite,
          child: ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: state.dashboardCards.length,
            itemBuilder: (context, index) {
              final card = state.dashboardCards[index];
              return ListTile(
                key: Key(card.id),
                leading: Icon(card.icon),
                title: Text(card.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: card.isVisible,
                      onChanged: (value) {
                        Navigator.pop(context);
                        _toggleCardVisibility(context, card.id);
                      },
                    ),
                    const Icon(Icons.drag_handle),
                  ],
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              // Create new order
              final List<String> newOrder = state.dashboardCards
                  .map((card) => card.id)
                  .toList();

              // Reorder
              final String item = newOrder.removeAt(oldIndex);
              newOrder.insert(newIndex, item);

              // Update order
              context.read<HomeDashboardBloc>().add(
                    ReorderDashboardCardsEvent(newOrder: newOrder),
                  );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleCardVisibility(BuildContext context, String cardId) {
    if (context.mounted) {
      final state = context.read<HomeDashboardBloc>().state;
      if (state is HomeDashboardLoaded) {
        final card = state.dashboardCards.firstWhere((c) => c.id == cardId);
        context.read<HomeDashboardBloc>().add(
              ToggleCardVisibilityEvent(
                cardId: cardId,
                isVisible: !card.isVisible,
              ),
            );
      }
    }
  }

  void _handleQuickAction(String actionId) {
    switch (actionId) {
      case 'add_habit':
        Navigator.pushNamed(context, '/add-habit');
        break;
      case 'prayer_times':
        // Switch to prayer tab
        break;
      case 'read_quran':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quran feature coming soon!'),
          ),
        );
        break;
      case 'dhikr_counter':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dhikr counter feature coming soon!'),
          ),
        );
        break;
      default:
        break;
    }
  }

  Widget _buildGreetingSection(BuildContext context, String userName) {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    // Add user name if available
    if (userName.isNotEmpty) {
      greeting = '$greeting, $userName';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greeting,
              style: AppTextStyles.headingMedium,
            ),
            if (_isEditMode)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showNameEditDialog(context, userName),
                tooltip: 'Edit name',
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your Islamic dashboard for today',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showNameEditDialog(BuildContext context, String currentName) {
    _nameController.text = currentName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Your Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your Name',
            hintText: 'Enter your name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = _nameController.text.trim();
              context.read<HomeDashboardBloc>().add(
                    UpdateUserNameEvent(userName: newName),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesSection(BuildContext context) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        if (state is PrayerInitial) {
          context.read<PrayerCubit>().getPrayerTimes();
          return const LoadingIndicator(text: 'Loading prayer times...');
        } else if (state is GetPrayerSuccess) {
          return PrayerTimesCard(
            prayerList: context.read<PrayerCubit>().prayerList,
            nextPrayer: context.read<PrayerCubit>().nextPrayer,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(
              context,
              context.read<HomeDashboardBloc>().state as HomeDashboardLoaded,
            ),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'prayer'),
            isVisible: true,
          );
        } else if (state is GetPrayerError) {
          return AnimatedDashboardCard(
            title: 'Prayer Times',
            icon: AppIcons.prayer,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(
              context,
              context.read<HomeDashboardBloc>().state as HomeDashboardLoaded,
            ),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'prayer'),
            isVisible: true,
            child: Column(
              children: [
                const Text('Failed to load prayer times'),
                TextButton(
                  onPressed: () {
                    context.read<PrayerCubit>().getPrayerTimes(forceRefresh: true);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return const LoadingIndicator(text: 'Loading prayer times...');
        }
      },
    );
  }

  Widget _buildHabitsSection(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitLoading) {
          return const LoadingIndicator(text: 'Loading habits...');
        } else if (state is HabitsLoaded) {
          return HabitsSummaryCard(
            habits: state.habits,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(
              context,
              context.read<HomeDashboardBloc>().state as HomeDashboardLoaded,
            ),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'habits'),
            isVisible: true,
          );
        } else if (state is HabitError) {
          return AnimatedDashboardCard(
            title: 'Habits',
            icon: AppIcons.habit,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(
              context,
              context.read<HomeDashboardBloc>().state as HomeDashboardLoaded,
            ),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'habits'),
            isVisible: true,
            child: Column(
              children: [
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () {
                    context.read<HabitBloc>().add(GetHabitsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return AnimatedDashboardCard(
            title: 'Habits',
            icon: AppIcons.habit,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(
              context,
              context.read<HomeDashboardBloc>().state as HomeDashboardLoaded,
            ),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'habits'),
            isVisible: true,
            child: const Text('No habits found'),
          );
        }
      },
    );
  }
}
