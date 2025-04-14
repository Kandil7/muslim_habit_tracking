import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import '/core/utils/colors.dart';
import '/core/utils/navigation.dart';
import '/core/utils/styles.dart';

class SettingAndNotificationHeader extends StatelessWidget {
  const SettingAndNotificationHeader({super.key, this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      width: double.infinity,
      padding: text != null
          ? const EdgeInsetsDirectional.only(start: 24, end: 16)
          : const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          AppColors.primaryColor2,
          AppColors.primaryColor3,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        children: [
          Spacer(flex: text != null ? 2 : 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(text ?? context.tr.translate('settings.title'),
                      style: Styles.bold20)),
              if (text != null)
                Transform.rotate(
                  angle: 3.14,
                  child: InkWell(
                    onTap: () => Navigation.pop(context),
                    child: Icon(
                      Platform.isAndroid
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios_new,
                      size: Platform.isIOS ? 28 : 26,
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
            ],
          ),
          Spacer(flex: text != null ? 3 : 1),
        ],
      ),
    );
  }
}
