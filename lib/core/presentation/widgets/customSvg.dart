import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvg extends StatelessWidget {
  const CustomSvg({super.key, required this.svg});
  final String svg;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svg, width: 30, height: 30, color: Colors.black);
  }
}
