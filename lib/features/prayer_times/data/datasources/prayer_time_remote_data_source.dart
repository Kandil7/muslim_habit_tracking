import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/prayer_time_model.dart';

/// Interface for remote data source for prayer times
abstract class PrayerTimeRemoteDataSource {
  /// Get prayer times for a specific date
  Future<PrayerTimeModel> getPrayerTimeByDate(
    DateTime date,
    double latitude,
    double longitude,
    String calculationMethod,
  );
  
  /// Get prayer times for a date range
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
    double latitude,
    double longitude,
    String calculationMethod,
  );
  
  /// Get available calculation methods
  Future<Map<String, String>> getAvailableCalculationMethods();
}

/// Implementation of PrayerTimeRemoteDataSource using Aladhan API
class PrayerTimeRemoteDataSourceImpl implements PrayerTimeRemoteDataSource {
  final http.Client client;
  final Uuid uuid;
  
  PrayerTimeRemoteDataSourceImpl({
    required this.client,
    required this.uuid,
  });
  
  @override
  Future<PrayerTimeModel> getPrayerTimeByDate(
    DateTime date,
    double latitude,
    double longitude,
    String calculationMethod,
  ) async {
    final url = Uri.parse(
      '${AppConstants.prayerTimesBaseUrl}/timings/${date.day}-${date.month}-${date.year}?latitude=$latitude&longitude=$longitude&method=$calculationMethod',
    );
    
    try {
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['code'] == 200 && jsonData['status'] == 'OK') {
          return PrayerTimeModel.fromAladhanApi(
            jsonData['data'],
            uuid.v4(),
            calculationMethod,
          );
        } else {
          throw ServerException(message: jsonData['data'] ?? 'Failed to get prayer times');
        }
      } else {
        throw ServerException(message: 'Failed to get prayer times');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
    double latitude,
    double longitude,
    String calculationMethod,
  ) async {
    final url = Uri.parse(
      '${AppConstants.prayerTimesBaseUrl}/calendar/${startDate.year}/${startDate.month}?latitude=$latitude&longitude=$longitude&method=$calculationMethod',
    );
    
    try {
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['code'] == 200 && jsonData['status'] == 'OK') {
          final List<dynamic> days = jsonData['data'];
          
          // Filter days within the date range
          final filteredDays = days.where((day) {
            final date = DateTime.parse(day['date']['gregorian']['date']);
            return date.isAfter(startDate.subtract(const Duration(days: 1))) && 
                   date.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
          
          // Convert to PrayerTimeModel objects
          return filteredDays.map((day) => PrayerTimeModel.fromAladhanApi(
            day,
            uuid.v4(),
            calculationMethod,
          )).toList();
        } else {
          throw ServerException(message: jsonData['data'] ?? 'Failed to get prayer times');
        }
      } else {
        throw ServerException(message: 'Failed to get prayer times');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<Map<String, String>> getAvailableCalculationMethods() async {
    final url = Uri.parse('${AppConstants.prayerTimesBaseUrl}/methods');
    
    try {
      final response = await client.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['code'] == 200 && jsonData['status'] == 'OK') {
          final Map<String, dynamic> methods = jsonData['data'];
          
          // Convert to Map<String, String>
          final Map<String, String> result = {};
          methods.forEach((key, value) {
            result[key] = value['name'];
          });
          
          return result;
        } else {
          throw ServerException(message: jsonData['data'] ?? 'Failed to get calculation methods');
        }
      } else {
        throw ServerException(message: 'Failed to get calculation methods');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
