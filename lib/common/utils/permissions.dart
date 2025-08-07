import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> askCameraAndGallary() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request(); // iOS uses .photos

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      return true;
    } else {
      openAppSettings(); // Optional: prompt user to manually enable
      return false;
    }
  }
}
