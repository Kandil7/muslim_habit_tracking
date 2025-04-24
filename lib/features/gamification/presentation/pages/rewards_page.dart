import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/widgets.dart';
import '../../domain/entities/unlockable_content.dart';
import '../bloc/unlockable_content_bloc.dart';
import '../bloc/unlockable_content_event.dart';
import '../bloc/unlockable_content_state.dart';
import '../bloc/user_points_bloc.dart';
import '../bloc/user_points_event.dart';
import '../bloc/user_points_state.dart';
import '../widgets/points_display.dart';
import '../widgets/unlockable_content_card.dart';
import 'unlockable_content_details_page.dart';

/// Page to display unlockable rewards
class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load user points
    context.read<UserPointsBloc>().add(LoadUserPointsEvent());
    
    // Load all content
    context.read<UnlockableContentBloc>().add(LoadAllContentEvent());
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
        title: const Text('Rewards'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unlocked'),
            Tab(text: 'Quotes'),
            Tab(text: 'Duas'),
            Tab(text: 'Wallpapers'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                context.read<UnlockableContentBloc>().add(LoadAllContentEvent());
                break;
              case 1:
                context.read<UnlockableContentBloc>().add(LoadUnlockedContentEvent());
                break;
              case 2:
                context.read<UnlockableContentBloc>().add(
                  const LoadContentByTypeEvent(contentType: 'quote'),
                );
                break;
              case 3:
                context.read<UnlockableContentBloc>().add(
                  const LoadContentByTypeEvent(contentType: 'dua'),
                );
                break;
              case 4:
                context.read<UnlockableContentBloc>().add(
                  const LoadContentByTypeEvent(contentType: 'wallpaper'),
                );
                break;
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Points display
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<UserPointsBloc, UserPointsState>(
              builder: (context, state) {
                if (state is UserPointsLoaded || 
                    state is PointsAdded || 
                    state is PointsSpent) {
                  final userPoints = state is UserPointsLoaded 
                      ? state.userPoints 
                      : state is PointsAdded 
                          ? state.userPoints 
                          : (state as PointsSpent).userPoints;
                  
                  return PointsDisplay(
                    userPoints: userPoints,
                    isCompact: true,
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
          
          // Content list
          Expanded(
            child: BlocBuilder<UnlockableContentBloc, UnlockableContentState>(
              builder: (context, state) {
                if (state is UnlockableContentLoading) {
                  return const Center(child: LoadingIndicator());
                } else if (state is AllContentLoaded) {
                  return _buildContentGrid(state.content);
                } else if (state is ContentByTypeLoaded) {
                  return _buildContentGrid(
                    state.content,
                    emptyMessage: 'No ${state.contentType} content found',
                  );
                } else if (state is UnlockedContentLoaded) {
                  return _buildContentGrid(
                    state.content,
                    emptyMessage: 'No content unlocked yet',
                  );
                } else if (state is UnlockableContentError) {
                  return ErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<UnlockableContentBloc>().add(LoadAllContentEvent()),
                  );
                } else {
                  return const Center(child: Text('No content found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContentGrid(
    List<UnlockableContent> content, 
    {String emptyMessage = 'No content found'}
  ) {
    if (content.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      );
    }
    
    return BlocBuilder<UserPointsBloc, UserPointsState>(
      builder: (context, pointsState) {
        final userPoints = pointsState is UserPointsLoaded 
            ? pointsState.userPoints 
            : pointsState is PointsAdded 
                ? pointsState.userPoints 
                : pointsState is PointsSpent 
                    ? pointsState.userPoints 
                    : null;
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: content.length,
          itemBuilder: (context, index) {
            final item = content[index];
            final canUnlock = userPoints != null && 
                userPoints.totalPoints >= item.pointsRequired;
            
            return UnlockableContentCard(
              content: item,
              canUnlock: canUnlock,
              onTap: () {
                if (item.isUnlocked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnlockableContentDetailsPage(content: item),
                    ),
                  );
                }
              },
              onUnlock: () {
                // Unlock the content
                context.read<UnlockableContentBloc>().add(
                  UnlockContentEvent(contentId: item.id),
                );
                
                // Spend points
                context.read<UserPointsBloc>().add(
                  SpendPointsEvent(
                    points: item.pointsRequired,
                    reason: 'Unlocked content: ${item.name}',
                  ),
                );
                
                // Show snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Unlocked: ${item.name}'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
