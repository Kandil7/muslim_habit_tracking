import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;
import '/core/utils/constants.dart';
import '/core/utils/navigation.dart';
import '/features/quran/presentation/views/sura_view.dart';

import '../../../data/models/quran_item_model.dart';
import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';
import '../../widgets/last_read_position_card.dart';
import 'quran_item.dart';

class QuranViewBody extends StatelessWidget {
  const QuranViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              di.sl<QuranBloc>()..add(const GetLastReadPositionEvent()),
      child: Builder(
        builder: (context) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Last read position card
              LastReadPositionCard(
                onContinueReading: (pageNumber) {
                  Navigation.push(context, SuraView(initialPage: pageNumber));
                },
              ),

              // Surah list
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Constants.quranList.length,
                itemBuilder:
                    (context, index) => GestureDetector(
                      onTap: () {
                        // Get the start page from the QuranItemModel
                        final startPage =
                            QuranItemModel.fromJson(
                              Constants.quranList[index],
                            ).start;

                        // Navigate to the SuraView with the correct page
                        Navigation.push(
                          context,
                          SuraView(initialPage: startPage),
                        );
                      },
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
              ),
            ],
          );
        },
      ),
    );
  }
}
