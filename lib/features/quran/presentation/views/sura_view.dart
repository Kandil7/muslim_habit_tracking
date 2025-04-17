import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/core/di/injection_container.dart' as di;

import '../../../../core/utils/services/shared_pref_service.dart';
import '../manager/sura/sura_cubit.dart';
import 'widgets/sura_view_body.dart';

class SuraView extends StatelessWidget {
  const SuraView({super.key, required this.initialPage});
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SuraCubit(di.sl.get<SharedPrefService>())
                ..initPageController(initialPage - 1),
      child: Scaffold(
        backgroundColor: Color(0xffFEFFDD),
        body: SuraViewBody(initialPage: initialPage),
      ),
    );
  }
}
