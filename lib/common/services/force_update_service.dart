import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service to check if the app needs a forced update
class ForceUpdateService {
  static final ForceUpdateService _instance = ForceUpdateService._internal();
  factory ForceUpdateService() => _instance;
  ForceUpdateService._internal();

  FirebaseRemoteConfig? _remoteConfig;

  /// Initialize Firebase Remote Config
  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(hours: 1), // Production fetch interval
        ),
      );
      await _remoteConfig!.setDefaults({
        'android_min_version': '1.0.0',
        'ios_min_version': '1.0.0',
        'force_update_enabled': true,
      });
      await _remoteConfig!.fetchAndActivate();
    } catch (_) {
      // Fail silently in production to avoid blocking users
    }
  }

  /// Check if the current app version is below the minimum required version
  Future<bool> isUpdateRequired() async {
    try {
      if (_remoteConfig == null) {
        await initialize();
      }

      if (!(_remoteConfig?.getBool('force_update_enabled') ?? false)) {
        return false;
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      String minVersion = Platform.isAndroid
          ? _remoteConfig!.getString('android_min_version')
          : Platform.isIOS
          ? _remoteConfig!.getString('ios_min_version')
          : '';

      if (minVersion.isEmpty) return false;

      return _isVersionLower(currentVersion, minVersion);
    } catch (_) {
      return false;
    }
  }

  /// Compare two version strings (returns true if current < minimum)
  bool _isVersionLower(String currentVersion, String minVersion) {
    try {
      List<int> current =
      currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      List<int> minimum =
      minVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      int length = current.length > minimum.length ? current.length : minimum.length;
      while (current.length < length) current.add(0);
      while (minimum.length < length) minimum.add(0);

      for (int i = 0; i < length; i++) {
        if (current[i] < minimum[i]) return true;
        if (current[i] > minimum[i]) return false;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Get the store URL based on platform
  String getStoreUrl() {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.crisant.wheelskart';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/idYOUR_APP_ID';
    }
    return '';
  }

  /// Get current app version
  Future<String> getCurrentVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (_) {
      return '0.0.0';
    }
  }
}