// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// import 'prayer_cached_image_progress_indicator.dart';
// import 'prayer_view_header_share.dart';
//
// class PrayerViewAdsItem extends StatelessWidget {
//   const PrayerViewAdsItem({super.key, required this.imageUrl});
//
//   final String imageUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.bottomEnd,
//       children: [
//         ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: CachedNetworkImage(
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//               progressIndicatorBuilder: (context, url, progress) =>
//                   const PrayerCachedImageProgressIndicator(),
//               imageUrl: imageUrl,
//             )),
//         PrayerViewHeaderShare(imageUrl: imageUrl),
//       ],
//     );
//   }
// }
