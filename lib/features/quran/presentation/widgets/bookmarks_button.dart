import 'package:flutter/material.dart';

import '../pages/quran_bookmarks_page.dart';

/// Button to view bookmarks
class BookmarksButton extends StatelessWidget {
  /// Constructor
  const BookmarksButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bookmarks),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuranBookmarksPage(),
          ),
        );
      },
      tooltip: 'Bookmarks',
    );
  }
}
