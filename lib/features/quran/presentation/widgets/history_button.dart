import 'package:flutter/material.dart';

import '../pages/quran_reading_history_page.dart';

/// Button to view reading history
class HistoryButton extends StatelessWidget {
  /// Constructor
  const HistoryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.history),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuranReadingHistoryPage(),
          ),
        );
      },
      tooltip: 'Reading History',
    );
  }
}
