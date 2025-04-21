import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_library/quran_library.dart' as ql;

import '../../../../../core/utils/constants.dart';
import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';
import '../../bloc/quran_state.dart';
import '../../views/sura_view.dart';

/// Body of the QuranView page
class QuranViewBody extends StatelessWidget {
  /// Constructor
  const QuranViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading of surahs if not already loaded
    // Wrap in try-catch to handle potential closed BLoC
    try {
      context.read<QuranBloc>().add(const GetAllSurahsEvent());
    } catch (e) {
      debugPrint('Error loading surahs: $e');
    }

    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen:
          (previous, current) =>
              current is AllSurahsLoaded ||
              current is QuranLoading ||
              current is QuranError,
      builder: (context, state) {
        if (state is QuranLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is QuranError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading Quran data',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<QuranBloc>().add(
                        const GetAllSurahsEvent(),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: Constants.quranList.length,
          itemBuilder: (context, index) {
            final surah = ql.QuranLibrary().getSurahInfo(
              surahNumber: index + 1,
            );
            final int pageNumber = ql.QuranCtrl.instance.surahsStart[index + 1];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuraView(initialPage: pageNumber),
                      ),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Surah number in a circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            '${surah.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Surah details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  surah.englishName,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  surah.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontFamily: 'Amiri',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${surah.englishNameTranslation} • ${surah.ayahsNumber} verses',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Page $pageNumber',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        surah.revelationType == 'Meccan'
                                            ? Colors.orange.withAlpha(50)
                                            : Colors.green.withAlpha(50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    surah.revelationType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          surah.revelationType == 'Meccan'
                                              ? Colors.orange.shade800
                                              : Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
