import 'package:flutter/material.dart';
import '/core/utils/helper.dart';
import '/core/utils/styles.dart';
import 'package:quran/quran.dart';

import 'sura_view_arrow_back.dart';

class SuraViewArrowBackAndJuzSection extends StatelessWidget {
  const SuraViewArrowBackAndJuzSection({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SuraViewArrowBack(),
        Text(
          "الجزء ${Helper.convertToArabicNumbers(getJuzNumber(getPageData(index)[0]['surah'], getPageData(index)[0]['start']).toString())}",
          style: Styles.medium15,
        ),
      ],
    );
  }
}
