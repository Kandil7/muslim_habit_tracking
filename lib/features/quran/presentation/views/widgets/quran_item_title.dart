import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muslim_habbit/core/constants/app_constants.dart';

class QuranItemTitle extends StatelessWidget {
  const QuranItemTitle({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppConstants.assetSurahNames(index),
      height: 80,
      width: 250,
      colorFilter: ColorFilter.mode(
        // golden color
        const Color.fromARGB(255, 196, 160, 15),
        BlendMode.srcIn,
      ),
    );
  }
}
