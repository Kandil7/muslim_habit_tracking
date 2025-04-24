import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../domain/entities/badge.dart' as custom;
import '../bloc/badge_bloc.dart';
import '../bloc/badge_event.dart';
import '../bloc/badge_state.dart';
import '../widgets/badge_grid.dart';
import 'badge_details_page.dart';

/// Page to display badges
class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // Load all badges
    context.read<BadgeBloc>().add(LoadAllBadgesEvent());
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
        title: const Text('Badges'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Earned'),
            Tab(text: 'Prayer'),
            Tab(text: 'Quran'),
            Tab(text: 'Fasting'),
            Tab(text: 'Dhikr'),
            Tab(text: 'Charity'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                context.read<BadgeBloc>().add(LoadAllBadgesEvent());
                break;
              case 1:
                context.read<BadgeBloc>().add(LoadEarnedBadgesEvent());
                break;
              case 2:
                context.read<BadgeBloc>().add(
                  const LoadBadgesByCategoryEvent(category: 'prayer'),
                );
                break;
              case 3:
                context.read<BadgeBloc>().add(
                  const LoadBadgesByCategoryEvent(category: 'quran'),
                );
                break;
              case 4:
                context.read<BadgeBloc>().add(
                  const LoadBadgesByCategoryEvent(category: 'fasting'),
                );
                break;
              case 5:
                context.read<BadgeBloc>().add(
                  const LoadBadgesByCategoryEvent(category: 'dhikr'),
                );
                break;
              case 6:
                context.read<BadgeBloc>().add(
                  const LoadBadgesByCategoryEvent(category: 'charity'),
                );
                break;
            }
          },
        ),
      ),
      body: BlocBuilder<BadgeBloc, BadgeState>(
        builder: (context, state) {
          if (state is BadgeLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is BadgesLoaded) {
            return _buildBadgeGrid(state.badges);
          } else if (state is BadgesByCategoryLoaded) {
            return _buildBadgeGrid(
              state.badges,
              emptyMessage: 'No ${state.category} badges found',
            );
          } else if (state is EarnedBadgesLoaded) {
            return _buildBadgeGrid(
              state.badges,
              emptyMessage: 'No badges earned yet',
            );
          } else if (state is BadgeError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed:
                      () => context.read<BadgeBloc>().add(LoadAllBadgesEvent()),
                  child: const Text('Retry'),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No badges found'));
          }
        },
      ),
    );
  }

  Widget _buildBadgeGrid(
    List<custom.Badge> badges, {
    String emptyMessage = 'No badges found',
  }) {
    return BadgeGrid(
      badges: badges,
      emptyMessage: emptyMessage,
      onBadgeTap: (badge) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BadgeDetailsPage(badge: badge),
          ),
        );
      },
    );
  }
}
