import 'package:flutter/material.dart';

/// Widget for displaying a marker in the Quran view
class SuraViewMarker extends StatelessWidget {
  /// Constructor
  const SuraViewMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: const Icon(
          Icons.bookmark,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
