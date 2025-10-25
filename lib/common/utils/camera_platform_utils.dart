import 'dart:io';
import 'package:camera/camera.dart';

class CameraPlatformUtils {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  
  /// Get optimal resolution for each platform
  static ResolutionPreset getOptimalResolution() {
    return isIOS ? ResolutionPreset.max : ResolutionPreset.high;
  }
  
  /// Check if audio should be enabled for camera
  static bool shouldEnableAudio() {
    return isIOS; // iOS may require audio enabled
  }
  
  /// Get optimal image quality for each platform
  static int getOptimalQuality() {
    return isIOS ? 95 : 90;
  }
  
  /// Get optimal max width for image resizing
  static int getOptimalMaxWidth() {
    return isIOS ? 2560 : 1920;
  }
}
