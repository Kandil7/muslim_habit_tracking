import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/prayer_times/presentation/views/prayer_view.dart';
import 'package:muslim_habbit/features/quran/presentation/pages/quran_view.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/bloc/theme_bloc_exports.dart';
import '../../../../core/localization/app_localizations_extension.dart';
import '../../../habit_tracking/presentation/bloc/habit_bloc.dart';
import '../../../habit_tracking/presentation/bloc/habit_event.dart';
import '../../../habit_tracking/presentation/bloc/habit_state.dart';
import '../../../prayer_times/presentation/manager/prayer/prayer_cubit.dart';
import '../../../hadith/presentation/bloc/hadith_bloc.dart';
import '../../../hadith/presentation/bloc/hadith_event.dart';
import '../../../hadith/presentation/widgets/hadith_of_the_day_card.dart';
import '../../domain/models/dashboard_card_model.dart';
import '../bloc/home_dashboard_bloc.dart';
import '../bloc/home_dashboard_event.dart';
import '../bloc/home_dashboard_state.dart';
import '../widgets/animated_dashboard_card.dart';
import '../widgets/customizable_quick_actions.dart';
import '../widgets/dhikr_card.dart';
// import '../widgets/hadith_card.dart'; // Using the new HadithOfTheDayCard instead
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

class _HomeDashboardPageState extends State<HomeDashboardPage>
    with SingleTickerProviderStateMixin {
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

    // Load hadith of the day
    context.read<HadithBloc>().add(const GetHadithOfTheDayEvent());
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
        title: Text(context.tr.translate('home.appTitle')),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  _isEditMode
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
            tooltip:
                _isEditMode
                    ? context.tr.translate('home.saveChanges')
                    : context.tr.translate('home.editDashboard'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: context.tr.translate('common.settings'),
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
                tooltip: context.tr.translate('home.toggleTheme'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr.translate('home.notificationsSoon')),
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
                    child: Text(context.tr.translate('home.retry')),
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
    final visibleCards =
        state.dashboardCards.where((card) => card.isVisible).toList()
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
              ...visibleCards.map(
                (card) => _buildCardWidget(context, card, state),
              ),

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

  Widget _buildCardWidget(
    BuildContext context,
    DashboardCardModel card,
    HomeDashboardLoaded state,
  ) {
    switch (card.id) {
      case 'prayer':
        return Column(
          children: [
            _buildPrayerTimesSection(context, state),
            const SizedBox(height: 24),
          ],
        );
      case 'habits':
        return Column(
          children: [
            _buildHabitsSection(context, state),
            const SizedBox(height: 24),
          ],
        );
      case 'quran':
        return Column(
          children: [const QuranCard(), const SizedBox(height: 24)],
        );
      case 'dhikr':
        return Column(
          children: [const DhikrCard(), const SizedBox(height: 24)],
        );
      case 'calendar':
        return Column(
          children: [
            IslamicCalendarCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle:
                  () => _toggleCardVisibility(context, 'calendar'),
              isVisible:
                  state.dashboardCards
                      .firstWhere((c) => c.id == 'calendar')
                      .isVisible,
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
              isVisible:
                  state.dashboardCards
                      .firstWhere((c) => c.id == 'qibla')
                      .isVisible,
            ),
            const SizedBox(height: 24),
          ],
        );
      case 'hadith':
        return Column(
          children: [
            HadithOfTheDayCard(
              isReorderable: _isEditMode,
              onReorder: () => _showReorderDialog(context, state),
              onVisibilityToggle:
                  () => _toggleCardVisibility(context, 'hadith'),
              isVisible:
                  state.dashboardCards
                      .firstWhere((c) => c.id == 'hadith')
                      .isVisible,
            ),
            const SizedBox(height: 24),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showReorderDialog(BuildContext context, HomeDashboardLoaded state) {
    // Get the HomeDashboardBloc instance from the current context
    final homeDashboardBloc = context.read<HomeDashboardBloc>();

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider<HomeDashboardBloc>.value(
            value: homeDashboardBloc,
            child: AlertDialog(
              title: Text(context.tr.translate('home.reorderCards')),
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
                    final List<String> newOrder =
                        state.dashboardCards.map((card) => card.id).toList();

                    // Reorder
                    final String item = newOrder.removeAt(oldIndex);
                    newOrder.insert(newIndex, item);

                    // Update order
                    homeDashboardBloc.add(
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
                  child: Text(context.tr.translate('home.close')),
                ),
              ],
            ),
          ),
    );
  }

  void _toggleCardVisibility(BuildContext context, String cardId) {
    if (context.mounted) {
      final state = context.read<HomeDashboardBloc>().state;
      if (state is HomeDashboardLoaded) {
        final card = state.dashboardCards.firstWhere((c) => c.id == cardId);
        context.read<HomeDashboardBloc>().add(
          ToggleCardVisibilityEvent(cardId: cardId, isVisible: !card.isVisible),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerView()),
        );
        break;
      case 'read_quran':
        // Switch to read Quran tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranView()),
        );
        break;
      case 'dhikr_counter':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.translate('home.dhikrSoon'))),
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
      greeting = context.tr.translate('home.goodMorning');
    } else if (hour < 17) {
      greeting = context.tr.translate('home.goodAfternoon');
    } else {
      greeting = context.tr.translate('home.goodEvening');
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
            Text(greeting, style: AppTextStyles.headingMedium),
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
          context.tr.translate('home.dashboardSubtitle'),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showNameEditDialog(BuildContext context, String currentName) {
    _nameController.text = currentName;

    // Get the HomeDashboardBloc instance from the current context
    final homeDashboardBloc = context.read<HomeDashboardBloc>();

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider<HomeDashboardBloc>.value(
            value: homeDashboardBloc,
            child: Builder(
              builder:
                  (context) => AlertDialog(
                    title: Text(context.tr.translate('home.editName')),
                    content: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.tr.translate('home.yourName'),
                        hintText: context.tr.translate('home.enterName'),
                      ),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(context.tr.translate('home.cancel')),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final newName = _nameController.text.trim();
                          context.read<HomeDashboardBloc>().add(
                            UpdateUserNameEvent(userName: newName),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(context.tr.translate('home.save')),
                      ),
                    ],
                  ),
            ),
          ),
    );
  }

  Widget _buildPrayerTimesSection(
    BuildContext context,
    HomeDashboardLoaded dashboardState,
  ) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        if (state is PrayerInitial) {
          context.read<PrayerCubit>().getPrayerTimes();
          return LoadingIndicator(
            text: context.tr.translate('home.loadingPrayer'),
          );
        } else if (state is GetPrayerSuccess) {
          return PrayerTimesCard(
            prayerList: context.read<PrayerCubit>().prayerList,
            nextPrayer: context.read<PrayerCubit>().nextPrayer,
          );
        } else if (state is GetPrayerError) {
          return AnimatedDashboardCard(
            title: 'Prayer Times',
            icon: AppIcons.prayer,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(context, dashboardState),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'prayer'),
            isVisible:
                dashboardState.dashboardCards
                    .firstWhere(
                      (c) => c.id == 'prayer',
                      orElse:
                          () => DashboardCardModel(
                            id: 'prayer',
                            title: 'Prayer Times',
                            icon: AppIcons.prayer,
                            order: 0,
                            isVisible: true,
                          ),
                    )
                    .isVisible,
            child: Column(
              children: [
                Text(context.tr.translate('home.prayerError')),
                TextButton(
                  onPressed: () {
                    context.read<PrayerCubit>().getPrayerTimes(
                      forceRefresh: true,
                    );
                  },
                  child: Text(context.tr.translate('home.tryAgain')),
                ),
              ],
            ),
          );
        } else {
          return LoadingIndicator(
            text: context.tr.translate('home.loadingPrayer'),
          );
        }
      },
    );
  }

  Widget _buildHabitsSection(
    BuildContext context,
    HomeDashboardLoaded dashboardState,
  ) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitLoading) {
          return LoadingIndicator(
            text: context.tr.translate('home.loadingHabits'),
          );
        } else if (state is HabitsLoaded) {
          return HabitsSummaryCard(habits: state.habits);
        } else if (state is HabitError) {
          return AnimatedDashboardCard(
            title: 'Habits',
            icon: AppIcons.home,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(context, dashboardState),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'habits'),
            isVisible:
                dashboardState.dashboardCards
                    .firstWhere(
                      (c) => c.id == 'habits',
                      orElse:
                          () => DashboardCardModel(
                            id: 'habits',
                            title: 'Habits',
                            icon: AppIcons.home,
                            order: 1,
                            isVisible: true,
                          ),
                    )
                    .isVisible,
            child: Column(
              children: [
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () {
                    context.read<HabitBloc>().add(GetHabitsEvent());
                  },
                  child: Text(context.tr.translate('home.tryAgain')),
                ),
              ],
            ),
          );
        } else {
          return AnimatedDashboardCard(
            title: 'Habits',
            icon: AppIcons.home,
            isReorderable: _isEditMode,
            onReorder: () => _showReorderDialog(context, dashboardState),
            onVisibilityToggle: () => _toggleCardVisibility(context, 'habits'),
            isVisible:
                dashboardState.dashboardCards
                    .firstWhere(
                      (c) => c.id == 'habits',
                      orElse:
                          () => DashboardCardModel(
                            id: 'habits',
                            title: 'Habits',
                            icon: AppIcons.home,
                            order: 1,
                            isVisible: true,
                          ),
                    )
                    .isVisible,
            child: Text(context.tr.translate('home.noHabits')),
          );
        }
      },
    );
  }
}
