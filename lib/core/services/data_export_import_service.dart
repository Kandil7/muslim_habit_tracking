// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../constants/app_constants.dart';
//
// /// Service for exporting and importing app data
// class DataExportImportService {
//   /// Export all app data to a JSON file
//   Future<bool> exportData(BuildContext context) async {
//     try {
//       // Request storage permission on Android
//       if (Platform.isAndroid) {
//         final status = await Permission.storage.request();
//         if (!status.isGranted) {
//           debugPrint('Storage permission denied');
//           return false;
//         }
//       }
//
//       // Create export data
//       final exportData = await _createExportData();
//       if (exportData.isEmpty) {
//         debugPrint('No data to export');
//         return false;
//       }
//
//       // Convert to JSON
//       final jsonData = jsonEncode(exportData);
//
//       // Get documents directory
//       final directory = await getApplicationDocumentsDirectory();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final filePath = '${directory.path}/sunnah_track_backup_$timestamp.json';
//
//       // Write to file
//       final file = File(filePath);
//       await file.writeAsString(jsonData);
//
//       debugPrint('Backup file created at: $filePath');
//
//       // Share the file
//       await Share.shareFiles(
//         [filePath],
//         subject: 'SunnahTrack Backup',
//         text: 'Here is your SunnahTrack data backup.',
//       );
//
//       return true;
//     } catch (e) {
//       debugPrint('Error exporting data: $e');
//       return false;
//     }
//   }
//
//   /// Import app data from a JSON file
//   Future<bool> importData() async {
//     try {
//       // Request storage permission on Android
//       if (Platform.isAndroid) {
//         final status = await Permission.storage.request();
//         if (!status.isGranted) {
//           debugPrint('Storage permission denied');
//           return false;
//         }
//       }
//
//       // Pick file
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['json'],
//       );
//
//       if (result == null || result.files.isEmpty) {
//         debugPrint('No file selected');
//         return false;
//       }
//
//       final path = result.files.single.path;
//       if (path == null) {
//         debugPrint('Invalid file path');
//         return false;
//       }
//
//       final file = File(path);
//       if (!await file.exists()) {
//         debugPrint('File does not exist: $path');
//         return false;
//       }
//
//       final jsonData = await file.readAsString();
//
//       // Parse JSON
//       final importData = jsonDecode(jsonData) as Map<String, dynamic>;
//
//       // Validate import data
//       if (!_validateImportData(importData)) {
//         debugPrint('Invalid import data format');
//         return false;
//       }
//
//       // Restore data
//       await _restoreData(importData);
//
//       debugPrint('Data imported successfully');
//       return true;
//     } catch (e) {
//       debugPrint('Error importing data: $e');
//       return false;
//     }
//   }
//
//   /// Validate import data format
//   bool _validateImportData(Map<String, dynamic> importData) {
//     // Check for required sections
//     if (!importData.containsKey('metadata')) {
//       return false;
//     }
//
//     // Check app name in metadata
//     final metadata = importData['metadata'] as Map<String, dynamic>?;
//     if (metadata == null || metadata['app'] != AppConstants.appName) {
//       return false;
//     }
//
//     // At least one data section should be present
//     return importData.containsKey('habits') ||
//            importData.containsKey('habit_logs') ||
//            importData.containsKey('prayer_times') ||
//            importData.containsKey('dua_dhikr') ||
//            importData.containsKey('settings');
//   }
//
//   /// Create export data from Hive boxes
//   Future<Map<String, dynamic>> _createExportData() async {
//     try {
//       final exportData = <String, dynamic>{};
//
//       // Export habits data if box exists
//       if (Hive.isBoxOpen(AppConstants.habitsBoxName) || await _openBox(AppConstants.habitsBoxName)) {
//         final habitsBox = Hive.box(AppConstants.habitsBoxName);
//         final habitsData = <String, dynamic>{};
//
//         for (var i = 0; i < habitsBox.length; i++) {
//           try {
//             final key = habitsBox.keyAt(i);
//             final value = habitsBox.getAt(i);
//             if (key != null && value != null) {
//               habitsData[key.toString()] = value;
//             }
//           } catch (e) {
//             debugPrint('Error exporting habit at index $i: $e');
//           }
//         }
//
//         if (habitsData.isNotEmpty) {
//           exportData['habits'] = habitsData;
//         }
//       }
//
//       // Export prayer times data if box exists
//       if (Hive.isBoxOpen(AppConstants.prayerTimesBoxName) || await _openBox(AppConstants.prayerTimesBoxName)) {
//         final prayerTimesBox = Hive.box(AppConstants.prayerTimesBoxName);
//         final prayerTimesData = <String, dynamic>{};
//
//         for (var i = 0; i < prayerTimesBox.length; i++) {
//           try {
//             final key = prayerTimesBox.keyAt(i);
//             final value = prayerTimesBox.getAt(i);
//             if (key != null && value != null) {
//               prayerTimesData[key.toString()] = value;
//             }
//           } catch (e) {
//             debugPrint('Error exporting prayer time at index $i: $e');
//           }
//         }
//
//         if (prayerTimesData.isNotEmpty) {
//           exportData['prayer_times'] = prayerTimesData;
//         }
//       }
//
//       // Export habit logs data if box exists
//       if (Hive.isBoxOpen(AppConstants.habitLogsBoxName) || await _openBox(AppConstants.habitLogsBoxName)) {
//         final habitLogsBox = Hive.box(AppConstants.habitLogsBoxName);
//         final habitLogsData = <String, dynamic>{};
//
//         for (var i = 0; i < habitLogsBox.length; i++) {
//           try {
//             final key = habitLogsBox.keyAt(i);
//             final value = habitLogsBox.getAt(i);
//             if (key != null && value != null) {
//               habitLogsData[key.toString()] = value;
//             }
//           } catch (e) {
//             debugPrint('Error exporting habit log at index $i: $e');
//           }
//         }
//
//         if (habitLogsData.isNotEmpty) {
//           exportData['habit_logs'] = habitLogsData;
//         }
//       }
//
//       // Export dua & dhikr data if box exists
//       if (Hive.isBoxOpen(AppConstants.duaDhikrBoxName) || await _openBox(AppConstants.duaDhikrBoxName)) {
//         final duaDhikrBox = Hive.box(AppConstants.duaDhikrBoxName);
//         final duaDhikrData = <String, dynamic>{};
//
//         for (var i = 0; i < duaDhikrBox.length; i++) {
//           try {
//             final key = duaDhikrBox.keyAt(i);
//             final value = duaDhikrBox.getAt(i);
//             if (key != null && value != null) {
//               duaDhikrData[key.toString()] = value;
//             }
//           } catch (e) {
//             debugPrint('Error exporting dua/dhikr at index $i: $e');
//           }
//         }
//
//         if (duaDhikrData.isNotEmpty) {
//           exportData['dua_dhikr'] = duaDhikrData;
//         }
//       }
//
//       // Export settings data if box exists
//       if (Hive.isBoxOpen(AppConstants.settingsBoxName) || await _openBox(AppConstants.settingsBoxName)) {
//         final settingsBox = Hive.box(AppConstants.settingsBoxName);
//         final settingsData = <String, dynamic>{};
//
//         for (var i = 0; i < settingsBox.length; i++) {
//           try {
//             final key = settingsBox.keyAt(i);
//             final value = settingsBox.getAt(i);
//             if (key != null && value != null) {
//               settingsData[key.toString()] = value;
//             }
//           } catch (e) {
//             debugPrint('Error exporting setting at index $i: $e');
//           }
//         }
//
//         if (settingsData.isNotEmpty) {
//           exportData['settings'] = settingsData;
//         }
//       }
//
//       // Add export metadata
//       exportData['metadata'] = {
//         'version': '1.0.0',
//         'timestamp': DateTime.now().toIso8601String(),
//         'app': AppConstants.appName,
//       };
//
//       return exportData;
//     } catch (e) {
//       debugPrint('Error creating export data: $e');
//       return {};
//     }
//   }
//
//   /// Helper method to open a Hive box safely
//   Future<bool> _openBox(String boxName) async {
//     try {
//       await Hive.openBox(boxName);
//       return true;
//     } catch (e) {
//       debugPrint('Error opening box $boxName: $e');
//       return false;
//     }
//   }
//
//   /// Restore data to Hive boxes
//   Future<void> _restoreData(Map<String, dynamic> importData) async {
//     try {
//       // Restore habits data
//       if (importData.containsKey('habits')) {
//         if (Hive.isBoxOpen(AppConstants.habitsBoxName) || await _openBox(AppConstants.habitsBoxName)) {
//           final habitsBox = Hive.box(AppConstants.habitsBoxName);
//           await habitsBox.clear();
//
//           final habitsData = importData['habits'] as Map<String, dynamic>;
//           for (final entry in habitsData.entries) {
//             try {
//               await habitsBox.put(entry.key, entry.value);
//             } catch (e) {
//               debugPrint('Error restoring habit ${entry.key}: $e');
//             }
//           }
//           debugPrint('Restored ${habitsData.length} habits');
//         }
//       }
//
//       // Restore prayer times data
//       if (importData.containsKey('prayer_times')) {
//         if (Hive.isBoxOpen(AppConstants.prayerTimesBoxName) || await _openBox(AppConstants.prayerTimesBoxName)) {
//           final prayerTimesBox = Hive.box(AppConstants.prayerTimesBoxName);
//           await prayerTimesBox.clear();
//
//           final prayerTimesData = importData['prayer_times'] as Map<String, dynamic>;
//           for (final entry in prayerTimesData.entries) {
//             try {
//               await prayerTimesBox.put(entry.key, entry.value);
//             } catch (e) {
//               debugPrint('Error restoring prayer time ${entry.key}: $e');
//             }
//           }
//           debugPrint('Restored ${prayerTimesData.length} prayer times');
//         }
//       }
//
//       // Restore habit logs data
//       if (importData.containsKey('habit_logs')) {
//         if (Hive.isBoxOpen(AppConstants.habitLogsBoxName) || await _openBox(AppConstants.habitLogsBoxName)) {
//           final habitLogsBox = Hive.box(AppConstants.habitLogsBoxName);
//           await habitLogsBox.clear();
//
//           final habitLogsData = importData['habit_logs'] as Map<String, dynamic>;
//           for (final entry in habitLogsData.entries) {
//             try {
//               await habitLogsBox.put(entry.key, entry.value);
//             } catch (e) {
//               debugPrint('Error restoring habit log ${entry.key}: $e');
//             }
//           }
//           debugPrint('Restored ${habitLogsData.length} habit logs');
//         }
//       }
//
//       // Restore dua & dhikr data
//       if (importData.containsKey('dua_dhikr')) {
//         if (Hive.isBoxOpen(AppConstants.duaDhikrBoxName) || await _openBox(AppConstants.duaDhikrBoxName)) {
//           final duaDhikrBox = Hive.box(AppConstants.duaDhikrBoxName);
//           await duaDhikrBox.clear();
//
//           final duaDhikrData = importData['dua_dhikr'] as Map<String, dynamic>;
//           for (final entry in duaDhikrData.entries) {
//             try {
//               await duaDhikrBox.put(entry.key, entry.value);
//             } catch (e) {
//               debugPrint('Error restoring dua/dhikr ${entry.key}: $e');
//             }
//           }
//           debugPrint('Restored ${duaDhikrData.length} duas/dhikrs');
//         }
//       }
//
//       // Restore settings data
//       if (importData.containsKey('settings')) {
//         if (Hive.isBoxOpen(AppConstants.settingsBoxName) || await _openBox(AppConstants.settingsBoxName)) {
//           final settingsBox = Hive.box(AppConstants.settingsBoxName);
//           await settingsBox.clear();
//
//           final settingsData = importData['settings'] as Map<String, dynamic>;
//           for (final entry in settingsData.entries) {
//             try {
//               await settingsBox.put(entry.key, entry.value);
//             } catch (e) {
//               debugPrint('Error restoring setting ${entry.key}: $e');
//             }
//           }
//           debugPrint('Restored ${settingsData.length} settings');
//         }
//       }
//     } catch (e) {
//       debugPrint('Error restoring data: $e');
//       throw Exception('Failed to restore data: $e');
//     }
//   }
// }
