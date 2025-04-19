import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';
import 'save_and_go_mark_item.dart';

class SuraSaveAndGoMarkWidget extends StatelessWidget {
  const SuraSaveAndGoMarkWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final quranBloc = context.read<QuranBloc>();

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
              onTap: () {
                quranBloc.add(SaveQuranMarkerEvent(position: index));
              },
            ),
            const SizedBox(width: 10),
            SaveAndGoMarkItem(
              text: "انتقل الي العلامة",
              onTap: () {
                quranBloc.add(const ResetQuranViewStateEvent());
                if (quranBloc.markerIndex != null &&
                    quranBloc.markerIndex! > 0) {
                  quranBloc.pageController.jumpToPage(
                    quranBloc.markerIndex! - 1,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
