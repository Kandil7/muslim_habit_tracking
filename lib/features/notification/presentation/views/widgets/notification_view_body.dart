import 'package:flutter/material.dart';
import 'package:muslim_habbit/core/localization/app_localizations_extension.dart';

import '../../../../../core/presentation/widgets/setting_and_notification_header.dart';
import 'notification_view_list_view.dart';

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
            child: Stack(
          clipBehavior: Clip.none,
          children: [
            SettingAndNotificationHeader(text: context.tr.translate('settings.notifications')),
            NotificationViewListView(),
          ],
        ))
      ],
    );
  }
}
