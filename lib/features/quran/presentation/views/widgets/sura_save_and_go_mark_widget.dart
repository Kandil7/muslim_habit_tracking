import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/sura/sura_cubit.dart';
import 'save_and_go_mark_item.dart';

class SuraSaveAndGoMarkWidget extends StatelessWidget {
  const SuraSaveAndGoMarkWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final sura = context.read<SuraCubit>();

    return Container(
      height: 65,
      margin: EdgeInsets.symmetric(vertical: Platform.isIOS ? 16 : 0.0),
      child: Center(
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SaveAndGoMarkItem(
                text: "حفظ علامة",
                onTap: () async {
                  await sura.saveMarker(index);
                }),
            const SizedBox(width: 10),
            SaveAndGoMarkItem(
                text: "انتقل الي العلامة",
                onTap: () {
                  sura.defaultViewState();
                  if (sura.index != null && sura.index! > 0) {
                    sura.pageController.jumpToPage(sura.index! - 1);
                  }
                })
          ],
        ),
      ),
    );
  }
}
