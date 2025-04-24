import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/prayer_time_model.dart';

/// Service for interacting with the AlAdhan API
class AlAdhanApiService {
  final http.Client client;
  final String baseUrl = 'https://api.aladhan.com/v1';

  /// Creates a new AlAdhanApiService
  AlAdhanApiService({required this.client});

  /// Get prayer times by city
  Future<List<PrayerTimeModel>> getPrayerTimesByCity({
    required String city,
    required String country,
    required int month,
    required int year,
    String method = '2', // 2 = Islamic Society of North America (ISNA)
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/calendarByCity/$year/$month?city=$city&country=$country&method=$method',
      );
      
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['code'] == 200 && data['status'] == 'OK') {
          final List<dynamic> days = data['data'];
          
          return days.map((day) {
            final timings = day['timings'];
            final date = day['date']['gregorian']['date'];
            
            return PrayerTimeModel(
              date: DateTime.parse(date),
              fajr: _parseTime(timings['Fajr']),
              sunrise: _parseTime(timings['Sunrise']),
              dhuhr: _parseTime(timings['Dhuhr']),
              asr: _parseTime(timings['Asr']),
              maghrib: _parseTime(timings['Maghrib']),
              isha: _parseTime(timings['Isha']),
            );
          }).toList();
        } else {
          throw ServerException(
            message: data['data'] ?? 'Failed to get prayer times',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get prayer times. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Failed to get prayer times: $e',
      );
    }
  }

  /// Get prayer times by coordinates
  Future<List<PrayerTimeModel>> getPrayerTimesByCoordinates({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
    String method = '2', // 2 = Islamic Society of North America (ISNA)
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/calendar/$year/$month?latitude=$latitude&longitude=$longitude&method=$method',
      );
      
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['code'] == 200 && data['status'] == 'OK') {
          final List<dynamic> days = data['data'];
          
          return days.map((day) {
            final timings = day['timings'];
            final date = day['date']['gregorian']['date'];
            
            return PrayerTimeModel(
              date: DateTime.parse(date),
              fajr: _parseTime(timings['Fajr']),
              sunrise: _parseTime(timings['Sunrise']),
              dhuhr: _parseTime(timings['Dhuhr']),
              asr: _parseTime(timings['Asr']),
              maghrib: _parseTime(timings['Maghrib']),
              isha: _parseTime(timings['Isha']),
            );
          }).toList();
        } else {
          throw ServerException(
            message: data['data'] ?? 'Failed to get prayer times',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to get prayer times. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Failed to get prayer times: $e',
      );
    }
  }
  
  /// Parse time string from API response
  DateTime _parseTime(String timeString) {
    // Example: "04:30 (EET)" or "04:30"
    final timeOnly = timeString.split(' ')[0];
    final parts = timeOnly.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }
}
