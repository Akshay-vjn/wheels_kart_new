import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> askCameraAndGallery(BuildContext context) async {
    final cameraStatus = await Permission.camera.request();
    final videoStatus = await Permission.videos.request();
    PermissionStatus galleryStatus;

    if (Platform.isIOS) {
      galleryStatus = await Permission.photos.request();
    } else {
      galleryStatus = await Permission.storage.request();
    }

    log("Gallery -> ${galleryStatus.isGranted}");

    log("Camera -> ${cameraStatus.isGranted}");
    log("video -> ${videoStatus.isGranted}");

    // ✅ If both are granted, proceed
    if (cameraStatus.isGranted &&
        galleryStatus.isGranted &&
        videoStatus.isGranted) {
      return true;
    }

    // ❌ If any permission is permanently denied
    if (cameraStatus.isPermanentlyDenied || galleryStatus.isPermanentlyDenied) {
      // Show dialog and offer to open settings
      await showDialog(
        context: context, // or pass context
        builder:
            (context) => AlertDialog(
              title: Text("Permission Required"),
              content: Text(
                "Please enable camera and photo access in Settings.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: Text("Open Settings"),
                ),
              ],
            ),
      );
      return false;
    }

    return false; // denied but not permanently
  }
}
