import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  FirebaseRemoteConfig? _remoteConfig;

  /// Initialize Firebase Remote Config
  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Immediate fetch for debug/production
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // always fetch latest
        ),
      );

      // Default values
      await _remoteConfig!.setDefaults({
        'force_update_required': false,           // Global fallback
        'minimum_version': '1.0.0',              // Global fallback
        'ios_minimum_version': '4.0.0',          // iOS-specific
        'android_minimum_version': '3.8.0',      // Android-specific
        'ios_force_update_required': false,      // iOS-specific
        'android_force_update_required': false,  // Android-specific
        'update_message': 'Your app version is outdated. Please update to continue using the app.',
        'android_store_url': 'https://play.google.com/store/apps/details?id=com.crisant.wheelskart',
        'ios_store_url': 'https://apps.apple.com/app/6749476545',
      });

      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();

      if (kDebugMode) {
        print('Remote Config initialized (immediate fetch)');
        print('force_update_required: ${getForceUpdateRequired()}');
        print('minimum_version: ${getMinimumVersion()}');
        print('ios_minimum_version: ${getIosMinimumVersion()}');
        print('android_minimum_version: ${getAndroidMinimumVersion()}');
        print('ios_force_update_required: ${getIosForceUpdateRequired()}');
        print('android_force_update_required: ${getAndroidForceUpdateRequired()}');
      }
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  /// Returns whether a force update is required
  bool getForceUpdateRequired() {
    return _remoteConfig?.getBool('force_update_required') ?? false;
  }

  /// Returns minimum required app version
  String getMinimumVersion() {
    return _remoteConfig?.getString('minimum_version') ?? '1.0.0';
  }

  /// Returns update message
  String getUpdateMessage() {
    return _remoteConfig?.getString('update_message') ??
        'Your app version is outdated. Please update to continue using the app.';
  }

  /// Returns Android store URL
  String getAndroidStoreUrl() {
    return _remoteConfig?.getString('android_store_url') ??
        'https://play.google.com/store/apps/details?id=com.yourapp.id';
  }

  /// Returns iOS store URL
  String getIosStoreUrl() {
    return _remoteConfig?.getString('ios_store_url') ??
        'https://apps.apple.com/app/id123456789';
  }

  /// Returns iOS-specific minimum version
  String getIosMinimumVersion() {
    return _remoteConfig?.getString('ios_minimum_version') ?? 
           getMinimumVersion(); // fallback to global
  }

  /// Returns Android-specific minimum version  
  String getAndroidMinimumVersion() {
    return _remoteConfig?.getString('android_minimum_version') ?? 
           getMinimumVersion(); // fallback to global
  }

  /// Returns iOS-specific force update flag
  bool getIosForceUpdateRequired() {
    return _remoteConfig?.getBool('ios_force_update_required') ?? 
           getForceUpdateRequired(); // fallback to global
  }

  /// Returns Android-specific force update flag
  bool getAndroidForceUpdateRequired() {
    return _remoteConfig?.getBool('android_force_update_required') ?? 
           getForceUpdateRequired(); // fallback to global
  }

  /// Refresh remote config values
  Future<void> refresh() async {
    try {
      if (kDebugMode) print('Fetching latest Remote Config values...');
      final updated = await _remoteConfig?.fetchAndActivate();
      if (kDebugMode) {
        print('Remote Config refresh ${updated == true ? "successful" : "no changes"}');
        print('force_update_required: ${getForceUpdateRequired()}');
        print('minimum_version: ${getMinimumVersion()}');
      }
    } catch (e) {
      print('Error refreshing Remote Config: $e');
    }
  }
}