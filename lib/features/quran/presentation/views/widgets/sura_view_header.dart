import 'package:flutter/material.dart';
import '/core/utils/helper.dart';
import '/core/utils/styles.dart';
import 'package:quran/quran.dart';

import 'sura_view_arrow_back_and_juz_section.dart';

class SuraViewHeader extends StatelessWidget {
  const SuraViewHeader({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SuraViewArrowBackAndJuzSection(index: index),
        Spacer(flex: 2),
        Text(Helper.gethizbText(index), style: Styles.medium15),
        Spacer(flex: 3),
        Text(
          getSurahNameArabic(getPageData(index)[0]['surah']),
          style: Styles.medium15,
        ),
      ],
    );
  }
}
