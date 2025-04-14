import 'package:flutter/material.dart';
import '/core/utils/colors.dart';

abstract class Styles {
  static TextStyle semiBold14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: AppColors.whiteColor,
  );

  static TextStyle bold24 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.whiteColor,
  );

  static TextStyle mediumObasity14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: AppColors.blackColor.withValues(alpha: .4),
  );

  static TextStyle medium18 = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );
  static TextStyle semiBold24 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: AppColors.whiteColor,
  );
  static TextStyle extraBold28 = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    fontFamily: "Cairo",
    color: AppColors.primaryColor3,
  );

  static TextStyle medium14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle medium15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: Color(0xff9EA05B).withValues(alpha: .8),
  );

  static TextStyle semiBold15 = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: AppColors.primaryColor2,
  );

  static TextStyle medium10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle medium8 = TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.w500,
      fontFamily: "Cairo",
      color: AppColors.primaryColor7.withValues(alpha: .5));

  static TextStyle medium12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle semiBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle bold18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle bold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.whiteColor,
  );

  static TextStyle bold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );

  static TextStyle regular15 = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: "Cairo",
      color: AppColors.blackColor,
      height: 2,
      wordSpacing: 2);

  static TextStyle regular20 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: "Cairo",
      color: AppColors.blackColor,
      height: 2,
      wordSpacing: 2);

  static TextStyle bold12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.whiteColor,
  );

  static TextStyle bold10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    fontFamily: "Cairo",
    color: AppColors.blackColor,
  );
}
