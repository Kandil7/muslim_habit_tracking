// import 'package:flutter/material.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
//
// import 'prayer_view_ads_item.dart';
// import 'prayer_view_header_no_ads.dart';
//
// class PrayerViewHeaderAds extends StatelessWidget {
//   const PrayerViewHeaderAds({super.key, required this.adsData});
//
//   final AppCubit adsData;
//
//   @override
//   Widget build(BuildContext context) {
//     return ImageSlideshow(
//       autoPlayInterval: 5000,
//       isLoop: true,
//       height: 350,
//       children: List.generate(adsData.adsData.length + 1, (index) {
//         if (index == 0) {
//           return const PrayerViewHeaderNoAds();
//         }
//
//         return PrayerViewAdsItem(imageUrl: adsData.adsData[index - 1].link);
//       }),
//     );
//   }
// }
