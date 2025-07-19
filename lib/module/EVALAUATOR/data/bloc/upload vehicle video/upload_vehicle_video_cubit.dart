import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/video_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/delete_upload_video_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/fetch_upload_video_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/upload_vehicle_video_repo.dart';

part 'upload_vehicle_video_state.dart';

class UploadVehicleVideoCubit extends Cubit<UploadVehicleVideoState> {
  UploadVehicleVideoCubit() : super(UploadVehicleVideoInitialState());
  static const WLAKAROUND = "Walkaround";
  static const ENGINESIDE = "Engine Side";
  Future<void> onFetcUploadVideos(
    BuildContext context,
    String inspectionId,
  ) async {
    log("Inspectipn Id : ${inspectionId}");
    emit(UploadVehicleVideoLoadingState());
    final response = await FetchUploadVideoRepo.fetchVihicleVideo(
      context,
      inspectionId,
    );

    if (response['error'] == true) {
      emit(UploadVehicleVideoErrorState(error: response['message']));
    } else {
      log(response['message']);
      log(response['data'].toString());
      final data = response['data'] as List;
      final listItems = data.map((e) => VideoModel.fromJson(e)).toList();
      bool isValilabeEnigineSideVideo = listItems.any(
        (element) => element.videoType == ENGINESIDE,
      );
      bool isAvailabeWalkaroundVideo = listItems.any(
        (element) => element.videoType == WLAKAROUND,
      );

      emit(
        UploadVehicleVideoSuccessState(
          videos: listItems,
          isAvailabeWalkaroundVideo: isAvailabeWalkaroundVideo,
          isAvailableEngineVideo: isValilabeEnigineSideVideo,
        ),
      );
    }
    // emit(UploadVehicleVideoSuccessState());
  }

  Future<void> _uploadVideo(
    BuildContext context,
    File file,
    String inspectionId,
    String videoType,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      final bytes = await file.readAsBytes();
      final base64File = base64Encode(bytes);
      final response = await UploadVehicleVideoRepo.uploadVehicleVideo(
        context,
        inspectionId,
        base64File,
        videoType,
      );
      if (response['error'] == true) {
        log("Error while uploading video ${response['message']}");
        showSnakBar(context, "Uploading $videoType is failed!", isError: true);
      } else {
        log("Success : ${response['message']}");
        showSnakBar(context, "$videoType video uploaded success");
      }

      emit(
        currentState.copyWith(
          isEngineUploading: videoType == ENGINESIDE ? false : null,
          isWalkAroundUploading: videoType == WLAKAROUND ? false : null,
        ),
      );
      final newState = state;
      if (newState is UploadVehicleVideoSuccessState) {
        if (!newState.isEngineUploading && !newState.isWalkAroundUploading) {
          await onFetcUploadVideos(context, inspectionId);
        }
      }
    }
  }

  Future<void> onClickFullWalkaroundVideo(
    String? videoId,
    String insepctionId,
    BuildContext context,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      final pickedFIle = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(minutes: 1),
      );

      if (pickedFIle == null) return;
      emit(currentState.copyWith(isWalkAroundUploading: true));
      if (videoId != null) {
        await _deleteVideo(insepctionId, videoId, context);
      }
      await _uploadVideo(
        context,
        File(pickedFIle.path),
        insepctionId,
        WLAKAROUND,
      );
    }
  }

  Future<void> onClickFullEngineVideo(
    String? videoId,
    String insepctionId,
    BuildContext context,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      final pickedFIle = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(minutes: 1),
      );

      if (pickedFIle == null) return;
      emit(currentState.copyWith(isEngineUploading: true));
      if (videoId != null) {
        await _deleteVideo(insepctionId, videoId, context);
      }
      await _uploadVideo(
        context,
        File(pickedFIle.path),
        insepctionId,
        ENGINESIDE,
      );
    }
  }

  Future<void> _deleteVideo(
    String inspectionId,
    String videoId,
    BuildContext context,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      final response = await DeleteUploadVideoRepo.deleteVehicleVideo(
        context,
        inspectionId,
        videoId,
      );
      if (response['error'] == true) {
        log("Error while deleting existing Video -> ${response['message']}");
      } else {
        log(response['message']);
      }
    }
  }
}
