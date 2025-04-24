import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// This is a utility script to generate app icons
// Run this script with: flutter run -t lib/tools/generate_app_icon.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Draw the icon (1024x1024 is the recommended size for app icons)
  const size = 1024.0;
  
  // Draw background
  final bgPaint = Paint()
    ..color = const Color(0xFF4CAF50) // Green color matching AppColors.primary
    ..style = PaintingStyle.fill;
  canvas.drawRect(Rect.fromLTWH(0, 0, size, size), bgPaint);
  
  // Draw white circle
  final circlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  canvas.drawCircle(Offset(size / 2, size / 2), size * 0.4, circlePaint);
  
  // Draw track_changes icon
  final iconPaint = Paint()
    ..color = const Color(0xFF4CAF50)
    ..style = PaintingStyle.fill;
  
  // Since we can't directly draw Material icons, we'll draw concentric circles
  // to simulate the track_changes icon
  for (double radius = size * 0.35; radius > size * 0.1; radius -= size * 0.08) {
    canvas.drawCircle(Offset(size / 2, size / 2), radius, iconPaint);
    canvas.drawCircle(
      Offset(size / 2, size / 2), 
      radius - size * 0.02, 
      Paint()..color = Colors.white,
    );
  }
  
  // Draw center dot
  canvas.drawCircle(Offset(size / 2, size / 2), size * 0.08, iconPaint);
  
  // Convert to image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();
  
  // Save the image
  final file = File('assets/images/app_icon.png');
  await file.writeAsBytes(buffer);
  
  // Create foreground version (just the icon without background)
  final recorderFg = ui.PictureRecorder();
  final canvasFg = Canvas(recorderFg);
  
  // Draw transparent background
  canvasFg.drawRect(
    Rect.fromLTWH(0, 0, size, size),
    Paint()..color = Colors.transparent,
  );
  
  // Draw white circle with padding for adaptive icon
  canvasFg.drawCircle(
    Offset(size / 2, size / 2), 
    size * 0.35, 
    circlePaint,
  );
  
  // Draw track_changes icon
  for (double radius = size * 0.3; radius > size * 0.08; radius -= size * 0.07) {
    canvasFg.drawCircle(Offset(size / 2, size / 2), radius, iconPaint);
    canvasFg.drawCircle(
      Offset(size / 2, size / 2), 
      radius - size * 0.02, 
      Paint()..color = Colors.white,
    );
  }
  
  // Draw center dot
  canvasFg.drawCircle(Offset(size / 2, size / 2), size * 0.06, iconPaint);
  
  // Convert to image
  final pictureFg = recorderFg.endRecording();
  final imgFg = await pictureFg.toImage(size.toInt(), size.toInt());
  final byteDataFg = await imgFg.toByteData(format: ui.ImageByteFormat.png);
  final bufferFg = byteDataFg!.buffer.asUint8List();
  
  // Save the foreground image
  final fileFg = File('assets/images/app_icon_foreground.png');
  await fileFg.writeAsBytes(bufferFg);
  
  print('App icons generated successfully!');
  print('Full icon: ${file.path}');
  print('Foreground icon: ${fileFg.path}');
  
  exit(0);
}
