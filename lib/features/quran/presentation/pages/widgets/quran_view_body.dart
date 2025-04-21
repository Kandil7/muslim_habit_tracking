import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants.dart';
import '../../../data/models/quran_item_model.dart';
import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_state.dart';
import '../../views/sura_view.dart';

/// Body of the QuranView page
class QuranViewBody extends StatelessWidget {
  /// Constructor
  const QuranViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen: (previous, current) =>
          current is AllSurahsLoaded || current is QuranLoading,
      builder: (context, state) {
        if (state is QuranLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: Constants.quranList.length,
          itemBuilder: (context, index) {
            final surah = QuranItemModel.fromJson(Constants.quranList[index]);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${surah.number}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Row(
                  children: [
                    Text(surah.englishName),
                    const SizedBox(width: 8),
                    Text(
                      surah.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${surah.englishNameTranslation} • ${surah.numberOfAyahs} verses',
                ),
                trailing: Text(
                  surah.revelationType,
                  style: TextStyle(
                    color: surah.revelationType == 'Meccan'
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuraView(
                      initialPage: surah.start,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
