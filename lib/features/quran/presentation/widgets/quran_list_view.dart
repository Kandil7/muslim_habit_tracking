import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/localization/bloc/language_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quran.dart';
import 'quran_list_item.dart';

/// ListView for displaying Quran surahs
class QuranListView extends StatelessWidget {
  final List<Quran> surahs;

  const QuranListView({
    super.key,
    required this.surahs,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LanguageCubit>().state.locale.languageCode == 'ar';
    
    if (surahs.isEmpty) {
      return Center(
        child: Text(
          context.tr.translate('quran.noResults'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return QuranListItem(
          surah: surah,
          index: index + 1,
          isArabic: isArabic,
        );
      },
    );
  }
}
