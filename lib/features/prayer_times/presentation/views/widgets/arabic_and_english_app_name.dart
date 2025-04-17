import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';

import '../../../data/models/app_name_model.dart';
import 'app_name_text.dart';

class ArabicAndEnglihAppName extends StatelessWidget {
  const ArabicAndEnglihAppName({super.key, required this.appNameModel});
  final AppNameModel appNameModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: appNameModel.right,
          left: appNameModel.left,
          top: appNameModel.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          if (appNameModel.isArabic) const AppNameText(),
          AppNameText(text: context.tr.translate('app.name'),),
          if (!appNameModel.isArabic) const AppNameText(),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
