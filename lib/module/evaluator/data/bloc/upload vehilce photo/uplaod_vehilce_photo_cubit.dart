import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/upload_vehicle_photo_repo.dart';

part 'uplaod_vehilce_photo_state.dart';

class UplaodVehilcePhotoCubit extends Cubit<UplaodVehilcePhotoState> {
  String? selectedAngleId;
  File? selectedImageFile;
  UplaodVehilcePhotoCubit() : super(UplaodVehilcePhotoInitialState());

 void onClearAll() {
    emit(UplaodVehilcePhotoSuccessState(null, null));
  }

  Future<void> onUploadVehilcePhoto(
    BuildContext context,
    String inspectionId,
    Map<String, dynamic> photo,
  ) async {
    try {
      emit(UplaodVehilcePhotoLoadingState());

      final response = await UploadVehiclePhotoRepo.uploadVehiclePhoto(
        context,
        inspectionId,
        photo,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          context
              .read<FetchUploadedVehilcePhotosCubit>()
              .onFetchUploadVehiclePhotos(context, inspectionId);
          emit(UplaodVehilcePhotoSuccessState(null, null));
        } else {
          showSnakBar(context, response['message'], isError: true);
          emit(UplaodVehilcePhotoErrorState(errorMessage: response['message']));
        }
      } else {
        showSnakBar(context, "Error :- Response is empty", isError: true);
        emit(
          UplaodVehilcePhotoErrorState(
            errorMessage: "Error :- Response is empty",
          ),
        );
      }
    } catch (e) {
      showSnakBar(context, "Error :- $e", isError: true);
      UplaodVehilcePhotoErrorState(errorMessage: "Error :- $e");
    }
  }

  void onSelectAngle(String angleId) {
    selectedAngleId = angleId;
    selectedImageFile = null;
    emit(UplaodVehilcePhotoSuccessState(angleId, null));
  }

  void onSelectImage() async {
    final controller = ImagePicker();
    final xFile = await controller.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (xFile == null) return;
    selectedImageFile = File(xFile.path);

    emit(UplaodVehilcePhotoSuccessState(selectedAngleId, selectedImageFile));
  }
}
