import 'package:flutter/material.dart';
import '/core/utils/styles.dart';

import '../../../data/models/quran_item_model.dart';

class QuranItemTitle extends StatelessWidget {
  const QuranItemTitle({
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
          ? "سورة ${quranItemModel.arName}"
          : "Surah ${quranItemModel.enName}",
      style: Styles.medium14,
    );
  }
}
