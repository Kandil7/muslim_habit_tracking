import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muslim_habbit/core/localization/bloc/language_cubit.dart';
import 'package:muslim_habbit/core/presentation/widgets/customSvg.dart';
import 'package:muslim_habbit/features/quran/presentation/views/widgets/sura_view_body.dart';
import 'package:quran_library/quran.dart';
import '/core/utils/constants.dart';
import '/core/utils/navigation.dart';
import '/features/quran/presentation/views/sura_view.dart';

import '../../../data/models/quran_item_model.dart';
import 'quran_item.dart';

class QuranViewBody extends StatelessWidget {
  const QuranViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: Constants.quranList.length,
      itemBuilder:
          (context, index) => GestureDetector(
            onTap:
                () => Navigation.push(
                  context,
                  SuraView(
                    initialPage:
                        QuranItemModel.fromJson(
                          Constants.quranList[index],
                        ).start,
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.only(top: index == 0 ? 12 : 0.0),
              child: QuranItem(
                index: index + 1,
                quranItemModel: QuranItemModel.fromJson(
                  Constants.quranList[index],
                ),
              ),
            ),
          ),
    );
  }
}
