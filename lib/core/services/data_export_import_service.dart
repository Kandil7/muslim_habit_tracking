import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/app_constants.dart';

/// Service for exporting and importing app data
class DataExportImportService {
  /// Export all app data to a JSON file
  Future<bool> exportData(BuildContext context) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }
      
      // Create export data
      final exportData = await _createExportData();
      
      // Convert to JSON
      final jsonData = jsonEncode(exportData);
      
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/sunnah_track_backup_$timestamp.json';
      
      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonData);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'SunnahTrack Backup',
        text: 'Here is your SunnahTrack data backup.',
      );
      
      return true;
    } catch (e) {
      debugPrint('Error exporting data: $e');
      return false;
    }
  }
  
  /// Import app data from a JSON file
  Future<bool> importData() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }
      
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result == null || result.files.isEmpty) {
        return false;
      }
      
      final file = File(result.files.single.path!);
      final jsonData = await file.readAsString();
      
      // Parse JSON
      final importData = jsonDecode(jsonData) as Map<String, dynamic>;
      
      // Restore data
      await _restoreData(importData);
      
      return true;
    } catch (e) {
      debugPrint('Error importing data: $e');
      return false;
    }
  }
  
  /// Create export data from Hive boxes
  Future<Map<String, dynamic>> _createExportData() async {
    final exportData = <String, dynamic>{};
    
    // Export habits data
    final habitsBox = Hive.box(AppConstants.habitsBoxName);
    final habitsData = <String, dynamic>{};
    
    for (var i = 0; i < habitsBox.length; i++) {
      final key = habitsBox.keyAt(i);
      final value = habitsBox.getAt(i);
      habitsData[key.toString()] = value;
    }
    
    exportData['habits'] = habitsData;
    
    // Export prayer times data
    final prayerTimesBox = Hive.box(AppConstants.prayerTimesBoxName);
    final prayerTimesData = <String, dynamic>{};
    
    for (var i = 0; i < prayerTimesBox.length; i++) {
      final key = prayerTimesBox.keyAt(i);
      final value = prayerTimesBox.getAt(i);
      prayerTimesData[key.toString()] = value;
    }
    
    exportData['prayer_times'] = prayerTimesData;
    
    // Export dua & dhikr data
    final duaDhikrBox = Hive.box(AppConstants.duaDhikrBoxName);
    final duaDhikrData = <String, dynamic>{};
    
    for (var i = 0; i < duaDhikrBox.length; i++) {
      final key = duaDhikrBox.keyAt(i);
      final value = duaDhikrBox.getAt(i);
      duaDhikrData[key.toString()] = value;
    }
    
    exportData['dua_dhikr'] = duaDhikrData;
    
    // Export settings data
    final settingsBox = Hive.box(AppConstants.settingsBoxName);
    final settingsData = <String, dynamic>{};
    
    for (var i = 0; i < settingsBox.length; i++) {
      final key = settingsBox.keyAt(i);
      final value = settingsBox.getAt(i);
      settingsData[key.toString()] = value;
    }
    
    exportData['settings'] = settingsData;
    
    // Add export metadata
    exportData['metadata'] = {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'app': 'SunnahTrack',
    };
    
    return exportData;
  }
  
  /// Restore data to Hive boxes
  Future<void> _restoreData(Map<String, dynamic> importData) async {
    // Restore habits data
    if (importData.containsKey('habits')) {
      final habitsBox = Hive.box(AppConstants.habitsBoxName);
      await habitsBox.clear();
      
      final habitsData = importData['habits'] as Map<String, dynamic>;
      for (final entry in habitsData.entries) {
        await habitsBox.put(entry.key, entry.value);
      }
    }
    
    // Restore prayer times data
    if (importData.containsKey('prayer_times')) {
      final prayerTimesBox = Hive.box(AppConstants.prayerTimesBoxName);
      await prayerTimesBox.clear();
      
      final prayerTimesData = importData['prayer_times'] as Map<String, dynamic>;
      for (final entry in prayerTimesData.entries) {
        await prayerTimesBox.put(entry.key, entry.value);
      }
    }
    
    // Restore dua & dhikr data
    if (importData.containsKey('dua_dhikr')) {
      final duaDhikrBox = Hive.box(AppConstants.duaDhikrBoxName);
      await duaDhikrBox.clear();
      
      final duaDhikrData = importData['dua_dhikr'] as Map<String, dynamic>;
      for (final entry in duaDhikrData.entries) {
        await duaDhikrBox.put(entry.key, entry.value);
      }
    }
    
    // Restore settings data
    if (importData.containsKey('settings')) {
      final settingsBox = Hive.box(AppConstants.settingsBoxName);
      await settingsBox.clear();
      
      final settingsData = importData['settings'] as Map<String, dynamic>;
      for (final entry in settingsData.entries) {
        await settingsBox.put(entry.key, entry.value);
      }
    }
  }
}
