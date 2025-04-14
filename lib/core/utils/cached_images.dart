import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/core/utils/assets.dart';


abstract class CachedImages {
  static final List<String> _pngImages = [
    Assets.imagesAzkarMuslimBackground,
    Assets.imagesBackgroundDrawer,
    Assets.imagesBackgroundItem,
    Assets.imagesBroadcast,
    Assets.imagesComingEarlyJumma,
    Assets.imagesHome,
    Assets.imagesLogo,
    Assets.imagesMoon,
    Assets.imagesMosque,
    Assets.imagesMuslimRemembrances,
    Assets.imagesNightPrayer,
    Assets.imagesQuranKareem,
    Assets.imagesQuranRadio,
    Assets.imagesSettings,
    Assets.imagesSoundWave,
    Assets.imagesStar,
    Assets.imagesSun,
    Assets.imagesSunnahJummah,
    Assets.imagesSunrise,
    Assets.imagesTime
  ];
  static final List<String> _svgImages = [
    Assets.imagesFacebook,
    Assets.imagesWhatsapp,
    Assets.imagesLanguage,
    Assets.imagesLocation,
    Assets.imagesMarker,
    Assets.imagesMenu,
    Assets.imagesMessage,
    Assets.imagesNotices,
    Assets.imagesTelegram,
    Assets.imagesTerms,
    Assets.imagesTwitter,
  ];

  static Future<void> _loadSvgImages() async {
    for (var image in _svgImages) {
      final loader = SvgAssetLoader(image);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  static Future<void> _loadPngImages(BuildContext context) async {
    for (var image in _pngImages) {
      await precacheImage(AssetImage(image), context);
    }
  }

  static Future<void> loadImages(BuildContext context) async {
    await Future.wait([
      CachedImages._loadSvgImages(),
      CachedImages._loadPngImages(context),
    ]);
    log("Images loaded successfully!");
  }
}
