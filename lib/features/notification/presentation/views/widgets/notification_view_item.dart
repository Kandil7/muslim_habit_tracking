import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/utils/colors.dart';
import '/core/utils/styles.dart';

import '../../../data/models/notification_item_model.dart';
import '../../manager/notification/notification_cubit.dart';

class NotificationViewItem extends StatelessWidget {
  const NotificationViewItem(
      {super.key, required this.notificationItemModel, required this.index});
  final NotificationItemModel notificationItemModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: AppColors.whiteColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: ListTile(
          title: Text(notificationItemModel.name, style: Styles.medium14),
          trailing: SizedBox(
              width: 30,
              child: Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: notificationItemModel.value,
                    activeColor: AppColors.whiteColor,
                    inactiveThumbColor: const Color(0xff1E1E1E),
                    activeTrackColor: AppColors.primaryColor3,
                    inactiveTrackColor: const Color(0xffD9D9D9),
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    onChanged: (value) {
                      context
                          .read<NotificationCubit>()
                          .changeNotificationValue(index, context);
                    },
                  ))),
        ),
      ),
    );
  }
}
