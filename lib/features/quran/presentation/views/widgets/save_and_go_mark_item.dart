import 'package:flutter/material.dart';
import '/core/utils/colors.dart';
import '/core/utils/styles.dart';

class SaveAndGoMarkItem extends StatelessWidget {
  const SaveAndGoMarkItem({super.key, required this.text, required this.onTap});
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 33,
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.blackColor.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            text,
            style: Styles.medium14.copyWith(color: Color(0xffF3F3F3)),
          ),
        ),
      ),
    );
  }
}
