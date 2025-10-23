import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_owned_car_detail_repo.dart';

class OcbDetailsCache {
  static final Map<String, VCarDetailModel> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 30); // Cache for 30 minutes

  /// Get owned details from cache or fetch from API
  static Future<VCarDetailModel?> getOwnedDetails(
    BuildContext context,
    String inspectionId,
  ) async {
    // Check if we have valid cached data
    if (_cache.containsKey(inspectionId) && 
        _cacheTimestamps.containsKey(inspectionId)) {
      final cacheTime = _cacheTimestamps[inspectionId]!;
      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        log('OcbDetailsCache: Using cached data for $inspectionId');
        return _cache[inspectionId];
      } else {
        // Cache expired, remove it
        _cache.remove(inspectionId);
        _cacheTimestamps.remove(inspectionId);
        log('OcbDetailsCache: Cache expired for $inspectionId, removed');
      }
    }

    // Fetch from API
    try {
      log('OcbDetailsCache: Fetching fresh data for $inspectionId');
      final response = await VFetchOwnedCarDetailRepo.onGetOwnedCarDetails(
        context, 
        inspectionId,
      );
      
      if (response['error'] == false) {
        final model = VCarDetailModel.fromJson(response['data']);
        
        // Cache the result
        _cache[inspectionId] = model;
        _cacheTimestamps[inspectionId] = DateTime.now();
        
        log('OcbDetailsCache: Cached fresh data for $inspectionId');
        return model;
      } else {
        log('OcbDetailsCache: API error for $inspectionId: ${response['message']}');
        return null;
      }
    } catch (e) {
      log('OcbDetailsCache: Exception for $inspectionId: $e');
      return null;
    }
  }

  /// Preload owned details for multiple inspection IDs
  static Future<List<VCarDetailModel?>> preloadOwnedDetails(
    BuildContext context,
    List<String> inspectionIds,
  ) async {
    log('OcbDetailsCache: Preloading ${inspectionIds.length} items');
    
    final List<VCarDetailModel?> results = [];
    
    // Process in batches to avoid overwhelming the API
    const batchSize = 3;
    for (int i = 0; i < inspectionIds.length; i += batchSize) {
      final batch = inspectionIds.skip(i).take(batchSize);
      
      final futures = batch.map((id) => getOwnedDetails(context, id));
      final batchResults = await Future.wait(futures);
      
      results.addAll(batchResults);
      
      // Small delay between batches to be gentle on the API
      if (i + batchSize < inspectionIds.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    
    log('OcbDetailsCache: Preloaded ${results.length} items');
    return results;
  }

  /// Clear expired cache entries
  static void clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    _cacheTimestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) >= _cacheExpiry) {
        expiredKeys.add(key);
      }
    });
    
    for (final key in expiredKeys) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      log('OcbDetailsCache: Cleared ${expiredKeys.length} expired entries');
    }
  }

  /// Clear all cache
  static void clearAllCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    log('OcbDetailsCache: Cleared all cache');
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'totalEntries': _cache.length,
      'cacheSize': _cache.length,
      'oldestEntry': _cacheTimestamps.values.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
      'newestEntry': _cacheTimestamps.values.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }
}




