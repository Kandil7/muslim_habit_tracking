import 'package:flutter/material.dart';
import '/core/utils/assets.dart';
import '/core/utils/helper.dart';

class QuranItemLeading extends StatelessWidget {
  const QuranItemLeading({super.key, required this.local, required this.index});

  final bool local;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Assets.imagesStar)),
      ),
      child: Center(
        child: Text(
          local
              ? Helper.convertToArabicNumbers(index.toString())
              : index.toString(),
        ),
      ),
    );
  }
}
