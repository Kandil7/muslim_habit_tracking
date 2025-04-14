import 'package:flutter/material.dart';
import '/core/utils/colors.dart';
import '/core/utils/styles.dart';

import '../../utils/colors.dart';
import 'app_bar_flexible_space.dart';

AppBar customAppBar(String title) {
  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    flexibleSpace: const AppBarFlexibleSpace(),
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    title: Text(
      title,
      style: Styles.semiBold16.copyWith(
        color: AppColors.whiteColor,
      ),
    ),
  );
}
