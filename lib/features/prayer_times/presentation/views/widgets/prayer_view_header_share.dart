// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '/core/utils/colors.dart';
//
// import '../../../../home/presentation/manager/app/app_cubit.dart';
//
// class PrayerViewHeaderShare extends StatelessWidget {
//   const PrayerViewHeaderShare({super.key, this.imageUrl});
//   final String? imageUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     final shareAds = context.read<AppCubit>();
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: IconButton(
//           onPressed: () async => await shareAds.shareAds(imageUrl: imageUrl),
//           icon: Icon(Icons.share, size: 33, color: AppColors.whiteColor)),
//     );
//   }
// }
