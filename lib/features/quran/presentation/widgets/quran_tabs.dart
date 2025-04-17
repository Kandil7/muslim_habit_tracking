import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';

/// Tabs for the Quran page
class QuranTabs extends StatelessWidget {
  final TabController tabController;

  const QuranTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: [
          Tab(text: context.tr.translate('quran.surah')),
          Tab(text: context.tr.translate('quran.bookmarks')),
          Tab(text: context.tr.translate('quran.lastRead')),
        ],
      ),
    );
  }
}
