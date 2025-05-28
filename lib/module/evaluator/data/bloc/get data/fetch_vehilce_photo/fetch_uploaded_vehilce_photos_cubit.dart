import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/evaluator/data/model/vehicle_photo_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/delete_vehilce_photo_repo.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/fetch_uploaded_vehicle_photo_repo.dart';

part 'fetch_uploaded_vehilce_photos_state.dart';

class FetchUploadedVehilcePhotosCubit
    extends Cubit<FetchUploadedVehilcePhotosState> {
  FetchUploadedVehilcePhotosCubit()
    : super(FetchUploadedVehilcePhotosInitialState());

  Future<void> onFetchUploadVehiclePhotos(
    BuildContext context,
    String inspectionId,
  ) async {
    try {
      emit(FetchUploadedVehilcePhotosLoadingState());
      final response = await FetchUploadedVehiclePhotoRepo.fetchVehilcePhoto(
        context,
        inspectionId,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          emit(
            FetchUploadedVehilcePhotosSuccessSate(
              vehiclePhtotos:
                  data.map((e) => VehiclePhotoModel.fromJson(e)).toList(),
            ),
          );
        } else {
          emit(
            FetchUploadedVehilcePhotosErrorState(
              errorMessage: response['message'],
            ),
          );
        }
      } else {
        emit(
          FetchUploadedVehilcePhotosErrorState(
            errorMessage: "Error- No response",
          ),
        );
      }
    } catch (e) {
      emit(FetchUploadedVehilcePhotosErrorState(errorMessage: 'Error - $e'));
    }
  }

  String? responseMessage;
  Future<void> deleteImage(
    BuildContext context,
    String inspectionId,
    String pictureId,
  ) async {
    try {

      final response = await DeleteVehilcePhotoRepo.deleteVehilcePhoto(
        context,
        inspectionId,
        pictureId,
      );
      if (response.isNotEmpty) {
        responseMessage = response['message'];
      } else {
        responseMessage = 'Error - Empty response';
      }
    } catch (e) {
      responseMessage = 'Error - $e';
    } finally {
      log(responseMessage ?? '');
      await onFetchUploadVehiclePhotos(context, inspectionId);
    }
  }
}
