import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_bloc.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_event.dart';
import '../../../dua_dhikr/presentation/bloc/dua_dhikr_state.dart';
import 'dashboard_card.dart';

/// Card widget for Dhikr
class DhikrCard extends StatelessWidget {
  const DhikrCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Dhikr of the Day',
      icon: AppIcons.dua,
      iconColor: AppColors.tertiary,
      onTap: () {
        // Navigate to Dua & Dhikr page or switch to dua tab
        // This would be handled by the parent HomePage
      },
      child: BlocBuilder<DuaDhikrBloc, DuaDhikrState>(
        builder: (context, state) {
          if (state is DuaDhikrLoading) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is DhikrsLoaded && state.dhikrs.isNotEmpty) {
            // Show the first dhikr
            final dhikr = state.dhikrs.first;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dhikr.arabicText,
                        style: AppTextStyles.arabicText.copyWith(
                          fontSize: 20,
                          color: AppColors.tertiary,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dhikr.transliteration,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dhikr.translation,
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Start Counting'),
                      onPressed: () {
                        // Navigate to dhikr counter page
                        Navigator.pushNamed(
                          context,
                          '/dhikr-counter',
                          arguments: dhikr,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Trigger loading of dhikrs
            context.read<DuaDhikrBloc>().add(GetAllDhikrsEvent());
            return const SizedBox(
              height: 100,
              child: Center(
                child: Text('No dhikrs available'),
              ),
            );
          }
        },
      ),
    );
  }
}
