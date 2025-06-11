import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/image_cache_helper.dart';

/// Service for managing app caching
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();

  factory CacheManager() {
    return _instance;
  }

  CacheManager._internal();

  /// Cache expiration time (default: 24 hours)
  final Duration _cacheExpiration = const Duration(hours: 24);

  /// Initialize the cache manager
  Future<void> init() async {
    // Ensure cache directory exists
    final cacheDir = await _getCacheDirectory();
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    // Clean expired cache on startup
    await cleanExpiredCache();
  }

  /// Get the cache directory
  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/cache');
  }

  /// Save data to cache
  Future<bool> saveToCache(
    String key,
    dynamic data, {
    Duration? expiration,
  }) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/$key');

      // Convert data to JSON string
      final jsonData = jsonEncode({
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiration': (expiration ?? _cacheExpiration).inMilliseconds,
      });

      // Write to file
      await file.writeAsString(jsonData);

      return true;
    } catch (e) {
      debugPrint('Error saving to cache: $e');
      return false;
    }
  }

  /// Get data from cache
  Future<T?> getFromCache<T>(String key) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/$key');

      if (!await file.exists()) {
        return null;
      }

      // Read from file
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData);

      // Check if cache is expired
      final timestamp = data['timestamp'] as int;
      final expiration = data['expiration'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > expiration) {
        // Cache expired, delete file
        await file.delete();
        return null;
      }

      return data['data'] as T;
    } catch (e) {
      debugPrint('Error getting from cache: $e');
      return null;
    }
  }

  /// Remove item from cache
  Future<bool> removeFromCache(String key) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/$key');

      if (await file.exists()) {
        await file.delete();
      }

      return true;
    } catch (e) {
      debugPrint('Error removing from cache: $e');
      return false;
    }
  }

  /// Clean expired cache
  Future<void> cleanExpiredCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final files = await cacheDir.list().toList();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final file in files) {
        if (file is File) {
          try {
            final jsonData = await file.readAsString();
            final data = jsonDecode(jsonData);

            final timestamp = data['timestamp'] as int;
            final expiration = data['expiration'] as int;

            if (now - timestamp > expiration) {
              await file.delete();
            }
          } catch (e) {
            // If we can't read the file, delete it
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning expired cache: $e');
    }
  }

  /// Clear all cache
  Future<bool> clearCache() async {
    try {
      // Clear data cache
      final cacheDir = await _getCacheDirectory();

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
      }

      // Clear image cache
      final imageCacheHelper = ImageCacheHelper();
      await imageCacheHelper.clearCache();

      return true;
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      return false;
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      // Get data cache size
      final cacheDir = await _getCacheDirectory();

      int size = 0;

      if (await cacheDir.exists()) {
        final files = await cacheDir.list().toList();

        for (final file in files) {
          if (file is File) {
            size += await file.length();
          }
        }
      }

      // Get image cache size
      final imageCacheHelper = ImageCacheHelper();
      size += await imageCacheHelper.getCacheSize();

      return size;
    } catch (e) {
      debugPrint('Error getting cache size: $e');
      return 0;
    }
  }

  /// Save memory cache to SharedPreferences
  Future<bool> saveMemoryCache(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (data is String) {
        return await prefs.setString(key, data);
      } else if (data is int) {
        return await prefs.setInt(key, data);
      } else if (data is double) {
        return await prefs.setDouble(key, data);
      } else if (data is bool) {
        return await prefs.setBool(key, data);
      } else if (data is List<String>) {
        return await prefs.setStringList(key, data);
      } else {
        // Convert to JSON string for complex objects
        return await prefs.setString(key, jsonEncode(data));
      }
    } catch (e) {
      debugPrint('Error saving memory cache: $e');
      return false;
    }
  }

  /// Get memory cache from SharedPreferences
  Future<T?> getMemoryCache<T>(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey(key)) {
        return null;
      }

      if (T == String) {
        return prefs.getString(key) as T?;
      } else if (T == int) {
        return prefs.getInt(key) as T?;
      } else if (T == double) {
        return prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return prefs.getBool(key) as T?;
      } else if (T == List<String>) {
        return prefs.getStringList(key) as T?;
      } else {
        // Try to parse JSON string for complex objects
        final jsonString = prefs.getString(key);
        if (jsonString == null) return null;
        return jsonDecode(jsonString) as T?;
      }
    } catch (e) {
      debugPrint('Error getting memory cache: $e');
      return null;
    }
  }

  /// Remove memory cache from SharedPreferences
  Future<bool> removeMemoryCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('Error removing memory cache: $e');
      return false;
    }
  }
}
