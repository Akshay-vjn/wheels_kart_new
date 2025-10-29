// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:meta/meta.dart';
// import 'package:wheels_kart/common/utils/custome_show_messages.dart';
// import 'package:wheels_kart/common/utils/routes.dart';
// import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
// import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/upload_vehicle_photo_repo.dart';
// import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/camera_screen.dart';

// part 'uplaod_vehilce_photo_state.dart';

// class UplaodVehilcePhotoCubit extends Cubit<UplaodVehilcePhotoState> {
//   String? selectedAngleId;
//   File? selectedImageFile;
//   UplaodVehilcePhotoCubit() : super(UplaodVehilcePhotoInitialState());

//   void onClearAll() {
//     emit(UplaodVehilcePhotoSuccessState(null, null));
//   }

//   Future<void> onUploadVehilcePhoto(
//     BuildContext context,
//     String inspectionId,
//     Map<String, dynamic> photo,
//   ) async {
//     try {
//       emit(UplaodVehilcePhotoLoadingState());

//       final response = await UploadVehiclePhotoRepo.uploadVehiclePhoto(
//         context,
//         inspectionId,
//         photo,
//       );
//       if (response.isNotEmpty) {
//         if (response['error'] == false) {
//           context
//               .read<FetchUploadedVehilcePhotosCubit>()
//               .onFetchUploadVehiclePhotos(context, inspectionId);
//           emit(UplaodVehilcePhotoSuccessState(null, null));
//         } else {
//           showSnakBar(context, response['message'], isError: true);
//           emit(UplaodVehilcePhotoErrorState(errorMessage: response['message']));
//         }
//       } else {
//         showSnakBar(context, "Error :- Response is empty", isError: true);
//         emit(
//           UplaodVehilcePhotoErrorState(
//             errorMessage: "Error :- Response is empty",
//           ),
//         );
//       }
//     } catch (e) {
//       showSnakBar(context, "Error :- $e", isError: true);
//       UplaodVehilcePhotoErrorState(errorMessage: "Error :- $e");
//     }
//   }

//   void onSelectAngle(String angleId) {
//     selectedAngleId = angleId;
//     selectedImageFile = null;
//     emit(UplaodVehilcePhotoSuccessState(angleId, null));
//   }

//   void onSelectImage(BuildContext context) async {
//     // final controller = ImagePicker();
//     // final xFile = await controller.pickImage(
//     //   source: ImageSource.camera,
//     //   preferredCameraDevice: CameraDevice.rear,
//     // );
//     // if (xFile == null) return;
//     // selectedImageFile = File(xFile.path);

//     Navigator.of(context).push(
//       AppRoutes.createRoute(
//         CameraScreen(
//           onImageCaptured: (file) {
//             selectedImageFile = file;
//             emit(
//               UplaodVehilcePhotoSuccessState(
//                 selectedAngleId,
//                 selectedImageFile,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/camera_platform_utils.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/upload_vehicle_photo_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/camera_screen.dart';

part 'uplaod_vehilce_photo_state.dart';

enum UploadStatus { idle, queued, uploading, success, error }

class UploadItem {
  final String angleId;
  final String angleName;
  File? file;
  UploadStatus status;
  String? error;
  UploadItem({
    required this.angleId,
    required this.angleName,
    this.file,
    this.status = UploadStatus.idle,
    this.error,
  });
}

class UplaodVehilcePhotoCubit extends Cubit<UplaodVehilcePhotoState> {
  String? selectedAngleId;
  File? selectedImageFile;

  // track upload items by angleId
  final Map<String, UploadItem> _uploadItems = {};

  // expose as unmodifiable map in state via helper methods
  Map<String, UploadItem> get uploadItems => Map.unmodifiable(_uploadItems);

  UplaodVehilcePhotoCubit() : super(UplaodVehilcePhotoInitialState());

  void onClearAll() {
    selectedAngleId = null;
    selectedImageFile = null;
    _uploadItems.clear();
    emit(UplaodVehilcePhotoSuccessState(null, null, 0));
  }

  void onSelectAngle(String angleId, String angleName, int index) {
    selectedAngleId = angleId;
    selectedImageFile = null;
    // ensure an upload item exists for this angle
    _uploadItems.putIfAbsent(
      angleId,
      () => UploadItem(angleId: angleId, angleName: angleName),
    );
    emit(UplaodVehilcePhotoSuccessState(angleId, null, index));
  }

  Future<void> onSelectImage(
    BuildContext context,
    String inspectionId,
    int index,
    String angleName,
  ) async {
    // open camera screen which returns a File via callback
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => CameraScreen(
              isFromVhiclePhotoScreen: true,
              angleName: angleName, // Pass angle name to camera screen
              onImageCaptured: (file) {
                // immediate UI update
                selectedImageFile = file;
                if (selectedAngleId != null) {
                  _uploadItems[selectedAngleId!] = UploadItem(
                    angleName: angleName,
                    angleId: selectedAngleId!,
                    file: file,
                    status: UploadStatus.queued,
                  );
                }
                emit(
                  UplaodVehilcePhotoSuccessState(selectedAngleId, file, index),
                );
                // schedule background upload (non-blocking)
                _queueBackgroundUpload(
                  context,
                  selectedAngleId!,
                  file,
                  inspectionId,
                  index,
                  angleName,
                );
              },
            ),
      ),
    );
  }

  Future<void> _queueBackgroundUpload(
    BuildContext context,
    String angleId,
    File file,
    String inspectionId,
    int index,
    String angleName,
  ) async {
    // mark queued -> emit
    _uploadItems[angleId]?.status = UploadStatus.queued;
    emit(
      UplaodVehilcePhotoSuccessState(selectedAngleId, selectedImageFile, index),
    );

    // run upload asynchronously but don't await where caller needs to continue
    unawaited(
      _startUpload(context, angleId, file, inspectionId, index, angleName),
    );
  }

  Future<void> _startUpload(
    BuildContext context,
    String angleId,
    File file,
    String inspectionId,
    int index,
    String angleName,
  ) async {
    try {
      _uploadItems[angleId]?.status = UploadStatus.uploading;
      emit(
        UplaodVehilcePhotoSuccessState(
          selectedAngleId,
          selectedImageFile,
          index,
        ),
      );

      final encoded = await _convertFileToBase64(file);

      final json = {
        "pictureType": "FINAL",
        "pictureName":
            '$angleName-${DateTime.now().millisecondsSinceEpoch}.jpg',
        'angleId': angleId,
        'description': angleName,
        'picture': encoded,
      };

      final response = await UploadVehiclePhotoRepo.uploadVehiclePhoto(
        context,
        inspectionId,
        json,
      );

      if (response != null &&
          response.isNotEmpty &&
          response['error'] == false) {
        _uploadItems[angleId]?.status = UploadStatus.success;
        _uploadItems[angleId]?.file = null; // we don't need local copy now
        // refresh server-side list
        // You should pass the inspectionId or read it externally; for now emit and let UI caller refresh.
        // Example:
        context
            .read<FetchUploadedVehilcePhotosCubit>()
            .onFetchUploadVehiclePhotos(
              context,
              inspectionId,
              isInsideCall: null,
            );
      } else {
        _uploadItems[angleId]?.status = UploadStatus.error;
        _uploadItems[angleId]?.error =
            response['message']?.toString() ?? 'Upload failed';
      }
    } catch (e) {
      _uploadItems[angleId]?.status = UploadStatus.error;
      _uploadItems[angleId]?.error = e.toString();
      // retryUpload(context, inspectionId, angleId);
    } finally {
      emit(
        UplaodVehilcePhotoSuccessState(
          selectedAngleId,
          selectedImageFile,
          index,
        ),
      );
    }
  }

  // helper to convert & resize image with platform-specific optimization
  Future<String> _convertFileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Unable to decode image");
    
    // Platform-specific resizing
    final maxWidth = CameraPlatformUtils.getOptimalMaxWidth();
    if (image.width > maxWidth) {
      image = img.copyResize(image, width: maxWidth);
    }
    
    // Platform-specific quality
    final quality = CameraPlatformUtils.getOptimalQuality();
    final compressed = img.encodeJpg(image, quality: quality);
    return base64Encode(compressed);
  }

  // Optional: allow retry of failed upload
  void retryUpload(
    BuildContext context,
    String inspectionId,
    String angleId,
    int index,
    String angleName,
  ) {
    final item = _uploadItems[angleId];
    if (item == null || item.file == null) return;
    item.status = UploadStatus.queued;
    emit(
      UplaodVehilcePhotoSuccessState(selectedAngleId, selectedImageFile, index),
    );
    unawaited(
      _startUpload(
        context,
        angleId,
        item.file!,
        inspectionId,
        index,
        angleName,
      ),
    );
  }

  // Optional: cancel queued upload (if still queued)
  void cancelQueuedUpload(String angleId, int index) {
    final item = _uploadItems[angleId];
    if (item == null) return;
    if (item.status == UploadStatus.queued) {
      _uploadItems.remove(angleId);
      emit(
        UplaodVehilcePhotoSuccessState(
          selectedAngleId,
          selectedImageFile,
          index,
        ),
      );
    }
  }
}
