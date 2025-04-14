import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/notification/notification_cubit.dart';
import 'notification_view_item.dart';

class NotificationViewListView extends StatelessWidget {
  const NotificationViewListView({super.key});

  @override
  Widget build(BuildContext context) {
    final notification = context.read<NotificationCubit>();
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) async {
        if (state is ChangeNotificationSuccess) {
          await context.read<NotificationCubit>().makeNotification();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            spacing: 6,
            children: notification
                .notificationList(context)
                .asMap()
                .entries
                .map((e) => NotificationViewItem(
                    index: e.key, notificationItemModel: e.value))
                .toList(),
          ),
        );
      },
    );
  }
}
