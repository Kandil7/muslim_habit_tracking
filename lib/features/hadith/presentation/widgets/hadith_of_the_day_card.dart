import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/animated_dashboard_card.dart';
import '../../domain/entities/hadith.dart';
import '../bloc/hadith_bloc.dart';
import '../bloc/hadith_event.dart';
import '../bloc/hadith_state.dart';
import '../pages/hadith_detail_page.dart';

/// Card widget for Hadith of the Day
class HadithOfTheDayCard extends StatefulWidget {
  final VoidCallback? onReorder;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;
  final bool isReorderable;

  /// Creates a new HadithOfTheDayCard
  const HadithOfTheDayCard({
    super.key,
    this.onReorder,
    this.onVisibilityToggle,
    this.isVisible = true,
    this.isReorderable = false,
  });

  @override
  State<HadithOfTheDayCard> createState() => _HadithOfTheDayCardState();
}

class _HadithOfTheDayCardState extends State<HadithOfTheDayCard> {
  @override
  void initState() {
    super.initState();
    // Load hadith of the day
    context.read<HadithBloc>().add(const GetHadithOfTheDayEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HadithBloc, HadithState>(
      builder: (context, state) {
        return AnimatedDashboardCard(
          title: 'Hadith of the Day',
          icon: Icons.format_quote,
          iconColor: AppColors.secondary,
          isReorderable: widget.isReorderable,
          onReorder: widget.onReorder,
          onVisibilityToggle: widget.onVisibilityToggle,
          isVisible: widget.isVisible,
          onTap: () {
            if (state is HadithOfTheDayLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HadithDetailPage(hadith: state.hadith),
                ),
              );
            } else {
              // Navigate to hadith collection page
              Navigator.pushNamed(context, '/hadith-collection');
            }
          },
          child: _buildCardContent(context, state),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, HadithState state) {
    if (state is HadithLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is HadithOfTheDayLoaded) {
      return _buildHadithContent(context, state.hadith);
    } else if (state is HadithError) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.message}'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  context.read<HadithBloc>().add(
                    const GetHadithOfTheDayEvent(),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Initial state or any other state
      context.read<HadithBloc>().add(const GetHadithOfTheDayEvent());
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildHadithContent(BuildContext context, Hadith hadith) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.format_quote,
                color: AppColors.secondary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                hadith.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hadith.source,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(hadith.narrator, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickAction(
              context,
              icon: Icons.bookmark_outline,
              label: 'Save',
              onTap: () {
                context.read<HadithBloc>().add(
                  ToggleHadithBookmarkEvent(id: hadith.id),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      hadith.isBookmarked
                          ? 'Hadith removed from bookmarks'
                          : 'Hadith saved to bookmarks',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            _buildQuickAction(
              context,
              icon: Icons.share,
              label: 'Share',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share feature coming soon!')),
                );
              },
            ),
            _buildQuickAction(
              context,
              icon: Icons.refresh,
              label: 'New Hadith',
              onTap: () {
                context.read<HadithBloc>().add(
                  const RefreshHadithOfTheDayEvent(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New hadith loaded!')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
