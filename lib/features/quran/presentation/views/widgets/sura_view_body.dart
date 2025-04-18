import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart';

import '../../manager/sura/sura_cubit.dart';
import 'sura_save_and_go_mark_widget.dart';
import 'sura_view_header.dart';
import 'sura_view_marker.dart';

class SuraViewBody extends StatelessWidget {
  const SuraViewBody({super.key, required this.initialPage});
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    final sura = context.read<SuraCubit>();

    return BlocBuilder<SuraCubit, SuraState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            QuranLibraryScreen(
              // useDefaultAppBar: false,
              backgroundColor: Color(0xffFEFFDD),

              onPageChanged: (index) {
                sura.getPage(index + 1);
              },
            ),
            if (sura.index == (sura.page ?? initialPage))
              const SuraViewMarker(),
            if (sura.isClick)
              SuraSaveAndGoMarkWidget(index: sura.page ?? initialPage),
          ],
        );
      },
    );
  }
}
