import 'package:flutter/material.dart';
import '/core/utils/navigation.dart';

class SuraViewArrowBack extends StatelessWidget {
  const SuraViewArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.pop(context),
      child: Icon(
        Icons.arrow_back_ios_new,
        color: Color(0xff9EA05B).withValues(alpha: .8),
      ),
    );
  }
}
