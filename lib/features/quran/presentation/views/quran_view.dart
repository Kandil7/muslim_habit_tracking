import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';
import 'package:muslim_habbit/core/presentation/widgets/custom_app_bar.dart';

import 'widgets/quran_view_body.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context.tr.translate('quran.title')),
      body: QuranViewBody(),
    );
  }
}
