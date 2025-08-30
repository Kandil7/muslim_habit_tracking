import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/presentation/widgets/widgets.dart';
import 'package:muslim_habbit/features/gamification/domain/entities/community_challenge.dart';

class CommunityChallengesPage extends StatefulWidget {
  const CommunityChallengesPage({super.key});

  @override
  State<CommunityChallengesPage> createState() => _CommunityChallengesPageState();
}

class _CommunityChallengesPageState extends State<CommunityChallengesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Mock challenges data for demonstration
  late List<CommunityChallenge> _activeChallenges;
  late List<CommunityChallenge> _completedChallenges;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _activeChallenges = [
          CommunityChallenge(
            id: '1',
            title: 'Ramadan Quran Challenge',
            description: 'Read 10 pages of Quran daily for 30 days',
            category: 'Quran',
            startDate: DateTime.now().subtract(const Duration(days: 5)),
            endDate: DateTime.now().add(const Duration(days: 25)),
            target: 300,
            unit: 'pages',
            participants: [
              ChallengeParticipant(
                userId: '1',
                userName: 'Ahmed',
                progress: 50,
                avatarUrl: '',
              ),
              ChallengeParticipant(
                userId: '2',
                userName: 'Fatima',
                progress: 45,
                avatarUrl: '',
              ),
              ChallengeParticipant(
                userId: '3',
                userName: 'Yusuf',
                progress: 60,
                avatarUrl: '',
              ),
            ],
            currentLeaderId: 3,
            isActive: true,
          ),
          CommunityChallenge(
            id: '2',
            title: 'Prayer Consistency',
            description: 'Perform all 5 prayers on time for 30 days',
            category: 'Prayer',
            startDate: DateTime.now().subtract(const Duration(days: 10)),
            endDate: DateTime.now().add(const Duration(days: 20)),
            target: 150,
            unit: 'prayers',
            participants: [
              ChallengeParticipant(
                userId: '1',
                userName: 'Ahmed',
                progress: 50,
                avatarUrl: '',
              ),
              ChallengeParticipant(
                userId: '2',
                userName: 'Fatima',
                progress: 45,
                avatarUrl: '',
              ),
            ],
            currentLeaderId: 1,
            isActive: true,
          ),
        ];

        _completedChallenges = [
          CommunityChallenge(
            id: '3',
            title: 'Fasting Challenge',
            description: 'Fast 10 days in Shawwal',
            category: 'Fasting',
            startDate: DateTime.now().subtract(const Duration(days: 40)),
            endDate: DateTime.now().subtract(const Duration(days: 10)),
            target: 10,
            unit: 'days',
            participants: [
              ChallengeParticipant(
                userId: '1',
                userName: 'Ahmed',
                progress: 10,
                avatarUrl: '',
              ),
              ChallengeParticipant(
                userId: '2',
                userName: 'Fatima',
                progress: 8,
                avatarUrl: '',
              ),
            ],
            currentLeaderId: 1,
            isActive: false,
          ),
        ];

        _isLoading = false;
      });
    });
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
        title: const Text('Community Challenges'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildChallengeList(_activeChallenges),
                _buildChallengeList(_completedChallenges),
              ],
            ),
    );
  }

  Widget _buildChallengeList(List<CommunityChallenge> challenges) {
    if (challenges.isEmpty) {
      return const EmptyState(
        title: 'No Challenges',
        message: 'There are no challenges available at the moment. Check back later!',
        icon: Icons.emoji_events,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return _buildChallengeCard(challenges[index]);
      },
    );
  }

  Widget _buildChallengeCard(CommunityChallenge challenge) {
    final isCompleted = challenge.endDate.isBefore(DateTime.now());
    final progress = _calculateProgress(challenge);
    final daysLeft = _calculateDaysLeft(challenge);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  challenge.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.category, size: 16),
                const SizedBox(width: 4),
                Text(challenge.category),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text('$daysLeft days left'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(progress),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
                Text('${challenge.participants.length} Participants'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...challenge.participants.take(3).map((participant) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: participant.avatarUrl.isNotEmpty
                          ? NetworkImage(participant.avatarUrl)
                          : null,
                      child: participant.avatarUrl.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : null,
                    ),
                  );
                }),
                if (challenge.participants.length > 3)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 16,
                      child: Text(
                        '+${challenge.participants.length - 3}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Join or view challenge details
                  _showChallengeDetails(challenge);
                },
                child: Text(
                  isCompleted
                      ? 'View Results'
                      : challenge.participants
                              .any((p) => p.userId == 'current_user_id')
                          ? 'View Progress'
                          : 'Join Challenge',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress(CommunityChallenge challenge) {
    if (challenge.participants.isEmpty) return 0.0;
    
    // Find current user's progress
    final currentUser = challenge.participants
        .firstWhere((p) => p.userId == 'current_user_id', orElse: () => challenge.participants.first);
    
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

  void _showChallengeDetails(CommunityChallenge challenge) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(challenge.description),
              const SizedBox(height: 16),
              Text('Target: ${challenge.target} ${challenge.unit}'),
              const SizedBox(height: 16),
              Text('Participants:'),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: challenge.participants.length,
                  itemBuilder: (context, index) {
                    final participant = challenge.participants[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: participant.avatarUrl.isNotEmpty
                                ? NetworkImage(participant.avatarUrl)
                                : null,
                            child: participant.avatarUrl.isEmpty
                                ? const Icon(Icons.person, size: 16)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            participant.userName,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${participant.progress}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Show a snackbar instead of using a non-existent bloc
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Challenge joined successfully!'),
                      ),
                    );
                  },
                  child: const Text('Join Challenge'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}