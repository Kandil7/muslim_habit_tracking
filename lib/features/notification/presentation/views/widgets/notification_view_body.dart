import 'package:flutter/material.dart';
import 'package:jumaa/generated/l10n.dart';

import '../../../../../core/widgets/setting_and_notification_header.dart';
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
            SettingAndNotificationHeader(text: S.of(context).notices),
            NotificationViewListView(),
          ],
        ))
      ],
    );
  }
}
