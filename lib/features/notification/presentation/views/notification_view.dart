import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumaa/core/utils/colors.dart';
import 'package:jumaa/core/utils/services/setup_locator_service.dart';
import 'package:jumaa/core/utils/services/shared_pref_service.dart';

import '../../../../core/utils/services/notification_service.dart';
import '../manager/notification/notification_cubit.dart';
import 'widgets/notification_view_body.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(
          getIt.get<SharedPrefService>(), getIt.get<NotificationService>()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: const NotificationViewBody(),
      ),
    );
  }
}
