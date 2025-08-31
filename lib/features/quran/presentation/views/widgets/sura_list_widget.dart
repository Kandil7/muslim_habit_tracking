// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:muslim_habbit/features/quran/presentation/views/sura_view.dart';
// import 'package:quran_library/quran.dart';

// class SuraListWidget extends StatelessWidget {
//   const SuraListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> surahs = QuranLibrary().getAllSurahs();

//     return ListView.builder(
//       itemCount: surahs.length,
//       itemBuilder:
//           (context, index) => GestureDetector(
//             onTap: () {
//               QuranLibrary().jumpToSurah(index + 1);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SuraView(initialPage: index + 1),
//                 ),
//               );
//             },
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 4.0,
//                 horizontal: 8.0,
//               ),
//               color:
//                   index.isEven
//                       ? const Color(0xfff6d09d).withValues(alpha:0.1)
//                       : Colors.transparent,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             QuranLibrary.Assets.suraNum,
//                             width: 50,
//                             height: 50,
//                             colorFilter: ColorFilter.mode(
//                               Colors.black,
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                           Text(
//                             '${index + 1}'.convertNumbersAccordingToLang(
//                               languageCode: 'en',
//                             ),
//                             style: QuranLibrary().naskhStyle.copyWith(
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 8,
//                     child: SvgPicture.asset(
//                       'packages/quran_library/assets/svg/surah_name/00${index + 1}.svg',
//                       width: 200,
//                       height: 40,
//                       colorFilter: ColorFilter.mode(
//                         Colors.black,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
// }
