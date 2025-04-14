import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jumaa/core/utils/colors.dart';
import 'package:jumaa/generated/l10n.dart';

import '../../features/home/presentation/manager/app/app_cubit.dart';
import '../../features/home/presentation/views/home_view.dart';

class JumaaMaterialApp extends StatelessWidget {
  const JumaaMaterialApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp(
          title: "Jummah",
          color: AppColors.primaryColor3,
          navigatorKey: navigatorKey,
          locale: Locale(context.read<AppCubit>().getInt() == 0 ? 'ar' : 'en'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: const HomeView(),
        );
      },
    );
  }
}
