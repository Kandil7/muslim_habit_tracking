import 'package:flutter/material.dart';
import '/core/utils/colors.dart';
import '/core/utils/styles.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/utils/styles.dart';

import 'colors.dart';

void noInternetSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: AppColors.primaryColor6,
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    content: Center(
        child: Text(context.tr.translate('common.noInternet'),
            style:
                Styles.medium14.copyWith(color: AppColors.whiteColor))),
  ));
}