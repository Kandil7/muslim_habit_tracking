import 'package:flutter/material.dart';

import '../../utils/colors.dart';


class AppBarFlexibleSpace extends StatelessWidget {
  const AppBarFlexibleSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor2,
            // AppColors.primaryColor5,
            // AppColors.primaryColor6,
            AppColors.primaryColor3,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
