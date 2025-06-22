import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import 'dashboard_card.dart';

class DhikrCard extends StatefulWidget {
  const DhikrCard({super.key});

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  bool _hasInitialLoad = false;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Dhikr of the Day',
      icon: AppIcons.dua,
      iconColor: AppColors.tertiary,
      onTap: () => _navigateToDhikrs(context),
      child: BlocConsumer<DuaDhikrBloc, DuaDhikrState>(
        listener: (context, state) {
          if (state is OperationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load dhikrs: ${state.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          // Trigger initial load if not already done
          if (!_hasInitialLoad && state is! DhikrsLoaded) {
            _hasInitialLoad = true;
            context.read<DuaDhikrBloc>().add(const LoadAllDhikrs());
          }

          if (state is DataLoading) {
            return _buildLoadingState();
          } else if (state is DhikrsLoaded && state.dhikrs.isNotEmpty) {
            return _buildDhikrContent(state.dhikrs);
          } else if (state is OperationFailed) {
            return _buildErrorState(state.message);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 100,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDhikrContent(List<Dhikr> dhikrs) {
    // Get a random dhikr each day
    final dhikr = _getDailyDhikr(dhikrs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dhikr.arabicText,
                style: AppTextStyles.arabicText.copyWith(
                  fontSize: 20,
                  color: AppColors.tertiary,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              Text(
                dhikr.transliteration,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  // color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '"${dhikr.translation}"',
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              if (dhikr.reference.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Reference: ${dhikr.reference}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.repeat, size: 20),
              label: const Text('Start Counting'),
              onPressed: () => _navigateToDhikrCounter(context, dhikr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 32),
            const SizedBox(height: 8),
            Text('Failed to load', style: AppTextStyles.bodyMedium),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, color: AppColors.secondary, size: 32),
            const SizedBox(height: 8),
            Text('No dhikrs available', style: AppTextStyles.bodyMedium),
            TextButton(
              onPressed:
                  () => context.read<DuaDhikrBloc>().add(const LoadAllDhikrs()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Dhikr _getDailyDhikr(List<Dhikr> dhikrs) {
    // Get a consistent daily dhikr based on the current date
    final now = DateTime.now();
    final dailyIndex = now.day % dhikrs.length;
    return dhikrs[dailyIndex];
  }

  void _navigateToDhikrs(BuildContext context) {
    // Navigate to Dua & Dhikr page and switch to dhikr tab
    Navigator.pushNamed(context, '/dua-dhikr');
    // Additional logic to switch to dhikr tab can be added if needed
  }

  void _navigateToDhikrCounter(BuildContext context, Dhikr dhikr) {
    Navigator.pushNamed(context, '/dhikr-counter', arguments: dhikr);
  }
}
