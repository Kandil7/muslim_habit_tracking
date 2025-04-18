import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/presentation/widgets/customSvg.dart';
import '/core/utils/assets.dart';

class SuraViewMarker extends StatelessWidget {
  const SuraViewMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 64,
      child: SafeArea(child: CustomSvg(svg: Assets.imagesMarker)),
    );
  }
}
