import 'package:flutter/material.dart';

class CustomBackgroundItem extends StatelessWidget {
  const CustomBackgroundItem(
      {super.key, required this.backgroundColor, required this.child});
  final Color backgroundColor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}
