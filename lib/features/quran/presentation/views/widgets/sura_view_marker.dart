import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

class CustomSvg extends StatelessWidget {
  const CustomSvg({super.key, required this.svg});
  final String svg;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svg, width: 30, height: 30);
  }
}
