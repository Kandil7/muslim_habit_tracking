import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/theme/app_theme.dart';
import 'package:muslim_habbit/core/utils/helper.dart';

import '../../domain/entities/quran.dart';
import '../pages/surah_detail_page.dart';

/// ListItem for displaying a Quran surah
class QuranListItem extends StatelessWidget {
  final Quran surah;
  final int index;
  final bool isArabic;

  const QuranListItem({
    super.key,
    required this.surah,
    required this.index,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailPage(
              surahId: surah.id,
              initialPage: surah.startPage,
            ),
          ),
        );
      },
      leading: _buildLeading(context),
      title: Text(
        isArabic
            ? "سورة ${surah.arabicName}"
            : "Surah ${surah.englishName}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        isArabic
            ? "عدد الايات ${Helper.convertToArabicNumbers(surah.numberOfAyahs.toString())} - ${surah.revelationType}"
            : "Number of verses ${surah.numberOfAyahs.toString()} - ${surah.revelationType}",
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: surah.isBookmarked
          ? Icon(
              Icons.bookmark,
              color: AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          isArabic
              ? Helper.convertToArabicNumbers(index.toString())
              : index.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
