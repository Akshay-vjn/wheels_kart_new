import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/fetch_uploaded_vehicle_photo_repo.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/inspection/upload_vehicle_photo_repo.dart';

part 'uplaod_vehilce_photo_state.dart';

class UplaodVehilcePhotoCubit extends Cubit<UplaodVehilcePhotoState> {
  UplaodVehilcePhotoCubit() : super(UplaodVehilcePhotoInitialState());

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
          emit(UplaodVehilcePhotoSuccessState());

          Navigator.of(context).pop();
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
}
