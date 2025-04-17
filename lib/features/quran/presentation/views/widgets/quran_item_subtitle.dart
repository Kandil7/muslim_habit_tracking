import 'package:flutter/material.dart';
import '/core/utils/helper.dart';
import '/core/utils/styles.dart';

import '../../../data/models/quran_item_model.dart';

class QuranItemSubTitle extends StatelessWidget {
  const QuranItemSubTitle({
    super.key,
    required this.local,
    required this.quranItemModel,
  });

  final bool local;
  final QuranItemModel quranItemModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      local
          ? "عدد الايات ${Helper.convertToArabicNumbers(quranItemModel.verses.toString())} - ${quranItemModel.arType}"
          : "Number of verses ${quranItemModel.verses.toString()} - ${quranItemModel.enType}",
      style: Styles.medium10.copyWith(color: Color(0xff757070)),
    );
  }
}
