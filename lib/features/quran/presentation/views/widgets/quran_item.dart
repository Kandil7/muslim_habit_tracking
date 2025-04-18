import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/localization/bloc/language_bloc_exports.dart';

import '../../../data/models/quran_item_model.dart';
import 'quran_item_leading.dart';
import 'quran_item_subtitle.dart';
import 'quran_item_title.dart';

class QuranItem extends StatelessWidget {
  const QuranItem({
    super.key,
    required this.quranItemModel,
    required this.index,
  });
  final QuranItemModel quranItemModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final local = context.read<LanguageCubit>().state.locale == 'ar';
    return ListTile(
      horizontalTitleGap: 20,
      leading: QuranItemLeading(local: local, index: index),
      title: QuranItemTitle(local: local, quranItemModel: quranItemModel),
      subtitle: QuranItemSubTitle(local: local, quranItemModel: quranItemModel),
    );
  }
}
