import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Helper class for caching images
class ImageCacheHelper {
  static final ImageCacheHelper _instance = ImageCacheHelper._internal();
  
  factory ImageCacheHelper() {
    return _instance;
  }
  
  ImageCacheHelper._internal();
  
  /// Cache expiration time (default: 7 days)
  final Duration _cacheExpiration = const Duration(days: 7);
  
  /// Get the cache directory
  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/image_cache');
    
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    
    return cacheDir;
  }
  
  /// Generate a hash for the URL
  String _generateHash(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
  
  /// Get the cached file path for a URL
  Future<String> _getCachedFilePath(String url) async {
    final cacheDir = await _getCacheDirectory();
    final hash = _generateHash(url);
    return '${cacheDir.path}/$hash';
  }
  
  /// Check if a URL is cached
  Future<bool> isUrlCached(String url) async {
    final filePath = await _getCachedFilePath(url);
    final file = File(filePath);
    
    if (await file.exists()) {
      final stat = await file.stat();
      final now = DateTime.now();
      final fileAge = now.difference(stat.modified);
      
      // Check if the file is expired
      if (fileAge > _cacheExpiration) {
        await file.delete();
        return false;
      }
      
      return true;
    }
    
    return false;
  }
  
  /// Get cached image from URL
  Future<File?> getCachedImage(String url) async {
    final filePath = await _getCachedFilePath(url);
    final file = File(filePath);
    
    if (await file.exists()) {
      final stat = await file.stat();
      final now = DateTime.now();
      final fileAge = now.difference(stat.modified);
      
      // Check if the file is expired
      if (fileAge > _cacheExpiration) {
        await file.delete();
        return null;
      }
      
      return file;
    }
    
    return null;
  }
  
  /// Cache an image from URL
  Future<File?> cacheImage(String url) async {
    try {
      final filePath = await _getCachedFilePath(url);
      final file = File(filePath);
      
      // Check if already cached and not expired
      if (await isUrlCached(url)) {
        return file;
      }
      
      // Download the image
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Save to cache
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error caching image: $e');
      return null;
    }
  }
  
  /// Get image provider for a URL (with caching)
  Future<ImageProvider> getImageProvider(String url) async {
    if (await isUrlCached(url)) {
      final file = await getCachedImage(url);
      if (file != null) {
        return FileImage(file);
      }
    }
    
    // Cache the image for next time
    final file = await cacheImage(url);
    if (file != null) {
      return FileImage(file);
    }
    
    // Fallback to network image
    return NetworkImage(url);
  }
  
  /// Clear all cached images
  Future<bool> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error clearing image cache: $e');
      return false;
    }
  }
  
  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _getCacheDirectory();
      
      if (!await cacheDir.exists()) {
        return 0;
      }
      
      int size = 0;
      final files = await cacheDir.list().toList();
      
      for (final file in files) {
        if (file is File) {
          size += await file.length();
        }
      }
      
      return size;
    } catch (e) {
      debugPrint('Error getting image cache size: $e');
      return 0;
    }
  }
}
