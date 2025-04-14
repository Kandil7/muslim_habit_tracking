import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';



class AppNameText extends StatelessWidget {
  const AppNameText({super.key, this.text, this.style});
  final String? text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(text ?? context.tr.translate('app.name'),
            style: style ?? Theme.of(context).textTheme.displayLarge),

      ],
    );
  }
}
