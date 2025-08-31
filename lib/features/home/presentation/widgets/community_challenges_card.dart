import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/gamification/domain/entities/community_challenge.dart';
import 'package:muslim_habbit/features/home/presentation/widgets/animated_dashboard_card.dart';

class CommunityChallengesCard extends StatelessWidget {
  final List<CommunityChallenge> challenges;
  final bool isReorderable;
  final VoidCallback onReorder;
  final VoidCallback onVisibilityToggle;
  final bool isVisible;

  const CommunityChallengesCard({
    super.key,
    required this.challenges,
    required this.isReorderable,
    required this.onReorder,
    required this.onVisibilityToggle,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDashboardCard(
      title: 'Community Challenges',
      icon: Icons.emoji_events,
      isReorderable: isReorderable,
      onReorder: onReorder,
      onVisibilityToggle: onVisibilityToggle,
      isVisible: isVisible,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (challenges.isEmpty) {
      return const Center(
        child: Text('No active challenges. Check back later!'),
      );
    }

    final activeChallenges = challenges.where((c) => c.isActive).toList();
    
    if (activeChallenges.isEmpty) {
      return const Center(
        child: Text('No active challenges at the moment.'),
      );
    }

    // Show only the top challenge
    final topChallenge = activeChallenges.first;
    final progress = _calculateProgress(topChallenge);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topChallenge.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          topChallenge.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
            Text('${_calculateDaysLeft(topChallenge)} days left'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to challenges page
              Navigator.pushNamed(context, '/challenges');
            },
            child: const Text('View All Challenges'),
          ),
        ),
      ],
    );
  }

  double _calculateProgress(CommunityChallenge challenge) {
    if (challenge.participants.isEmpty) return 0.0;
    
    // Find current user's progress (placeholder)
    final currentUser = challenge.participants.first;
    return currentUser.progress / challenge.target;
  }

  int _calculateDaysLeft(CommunityChallenge challenge) {
    final now = DateTime.now();
    if (challenge.endDate.isBefore(now)) return 0;
    
    return challenge.endDate.difference(now).inDays;
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return Colors.green;
    } else if (progress >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}