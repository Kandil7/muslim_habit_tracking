// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'prayer_view_header_ads.dart';
// import 'prayer_view_header_no_ads.dart';
//
// class PrayerViewHeader extends StatelessWidget {
//   const PrayerViewHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final adsData = context.read<AppCubit>();
//     return BlocBuilder<AppCubit, AppState>(
//       builder: (context, state) {
//         if (adsData.adsData.isNotEmpty) {
//           return PrayerViewHeaderAds(adsData: adsData);
//         }
//         return const PrayerViewHeaderNoAds();
//       },
//     );
//   }
// }
