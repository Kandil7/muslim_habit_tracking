import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import '/core/utils/assets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ShareFilesService {
  Future<void> shareImagesFromAssets() async {
    final byteData = await rootBundle.load(Assets.imagesMosque);
    await _shareImages(byteData.buffer.asUint8List());
  }

  Future<void> shareImagesFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      await _shareImages(response.bodyBytes);
    } else {
      log('Failed to download image: ${response.statusCode}');
    }
  }

  Future<void> _shareImages(List<int> bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.png');

    await file.writeAsBytes(bytes);

    final result = await Share.shareXFiles(
      [(XFile(file.path))],
      text: "Jumaa Ads",
    );

    if (result.status == ShareResultStatus.success) {
      log('Thank you for sharing the picture!');
    }
  }
}
