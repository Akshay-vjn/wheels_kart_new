import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/permissions.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/video_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/delete_upload_video_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/fetch_upload_video_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/upload_vehicle_video_repo.dart';

part 'upload_vehicle_video_state.dart';

class UploadVehicleVideoCubit extends Cubit<UploadVehicleVideoState> {
  UploadVehicleVideoCubit() : super(UploadVehicleVideoInitialState());
  static const WLAKAROUND = "Walkaround";
  static const ENGINESIDE = "Engine Side";
  static const _targetVideoSizeMb = 9;
  static const _maxVideoDuration = Duration(minutes: 1);
  final LightCompressor _compressor = LightCompressor();
  static const _hdVideoWidth = 1280;
  static const _hdVideoHeight = 720;
  static const _oneMinuteVideoWidth = 960;
  static const _oneMinuteVideoHeight = 540;
  Future<void> onFetcUploadVideos(
    BuildContext context,
    String inspectionId,
  ) async {
    log("Fetching videos for Inspection Id: ${inspectionId}");
    emit(UploadVehicleVideoLoadingState());
    final response = await FetchUploadVideoRepo.fetchVihicleVideo(
      context,
      inspectionId,
    );

    if (response.isEmpty) {
      log("Empty response received from fetch videos API");
      emit(UploadVehicleVideoErrorState(error: "Failed to fetch videos. Please try again."));
      return;
    }

    if (response['error'] == true) {
      log("Error fetching videos: ${response['message']}");
      emit(UploadVehicleVideoErrorState(error: response['message'] ?? "Failed to fetch videos"));
    } else {
      log("Videos fetched successfully: ${response['message'] ?? 'Success'}");
      final data = response['data'];

      if (data == null) {
        log("No data in response, treating as empty list");
        emit(
          UploadVehicleVideoSuccessState(
            videos: [],
            isAvailabeWalkaroundVideo: false,
            isAvailableEngineVideo: false,
          ),
        );
        return;
      }

      final dataList = data is List ? data : [];
      log("Videos data: ${dataList.toString()}");

      final listItems = dataList.map((e) => VideoModel.fromJson(e)).toList();
      bool isValilabeEnigineSideVideo = listItems.any(
        (element) => element.videoType == ENGINESIDE,
      );
      bool isAvailabeWalkaroundVideo = listItems.any(
        (element) => element.videoType == WLAKAROUND,
      );

      log("Found ${listItems.length} videos - Walkaround: $isAvailabeWalkaroundVideo, Engine: $isValilabeEnigineSideVideo");

      emit(
        UploadVehicleVideoSuccessState(
          videos: listItems,
          isAvailabeWalkaroundVideo: isAvailabeWalkaroundVideo,
          isAvailableEngineVideo: isValilabeEnigineSideVideo,
        ),
      );
    }
  }

  Future<void> _uploadVideo(
    BuildContext context,
    File file,
    String inspectionId,
    String videoType,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      File fileToUpload = file;
      try {
        log("Compressing $videoType video...");
        String filePath = file.path;
        if (filePath.startsWith('file://')) {
          filePath = filePath.replaceFirst('file://', '');
        }

        fileToUpload = await _compressVideoForUpload(filePath) ?? file;
        log(
          "Video compressed. Original: ${file.lengthSync()} bytes -> "
          "Compressed: ${fileToUpload.lengthSync()} bytes",
        );
      } catch (e, s) {
        log("Video compression failed: $e", stackTrace: s);
      }

      final bytes = await fileToUpload.readAsBytes();
      final base64File = base64Encode(bytes);

      final response = await UploadVehicleVideoRepo.uploadVehicleVideo(
        context,
        inspectionId,
        base64File,
        videoType,
      );

      // Check if response is empty or has error
      if (response.isEmpty || response['error'] == true) {
        log("Error while uploading video: ${response['message'] ?? 'Unknown error'}");
        log("Response: ${response.toString()}");
        showSnakBar(context, "Uploading $videoType failed!", isError: true);
        emit(
          currentState.copyWith(
            isEngineUploading: videoType == ENGINESIDE ? false : null,
            isWalkAroundUploading: videoType == WLAKAROUND ? false : null,
          ),
        );
        return;
      }

      // Success case
      log("Video upload successful: ${response['message'] ?? 'Video uploaded'}");
      log("Response data: ${response['data']?.toString() ?? 'No data'}");
      showSnakBar(context, "$videoType video uploaded successfully");

      emit(
        currentState.copyWith(
          isEngineUploading: videoType == ENGINESIDE ? false : null,
          isWalkAroundUploading: videoType == WLAKAROUND ? false : null,
        ),
      );

      await Future.delayed(Duration(seconds: 2));

      await onFetcUploadVideos(context, inspectionId);

      final currentStateAfterFetch = state;
      if (currentStateAfterFetch is UploadVehicleVideoSuccessState) {
        if (currentStateAfterFetch.videos.isEmpty) {
          log("Video list is empty after upload, retrying fetch after 3 seconds...");
          await Future.delayed(Duration(seconds: 3));
          await onFetcUploadVideos(context, inspectionId);
        }
      }
    }
  }


  Future<File?> _compressVideoForUpload(String filePath) async {
    final durationSeconds = await _videoDurationSeconds(filePath);
    final isOneMinuteClip = durationSeconds >= 50;
    final targetWidth =
        isOneMinuteClip ? _oneMinuteVideoWidth : _hdVideoWidth;
    final targetHeight =
        isOneMinuteClip ? _oneMinuteVideoHeight : _hdVideoHeight;

    log(
      'Compressing ${durationSeconds.round()}s video to $_targetVideoSizeMb MB, '
      'target ${targetWidth}x$targetHeight',
    );

    final outputName =
        'wheels-kart-${DateTime.now().millisecondsSinceEpoch}.mp4';

    final compressedFile = await _runVideoCompression(
      filePath: filePath,
      outputName: outputName,
      width: targetWidth,
      height: targetHeight,
    );

    if (compressedFile != null) {
      return compressedFile;
    }

    log('Primary compression failed, retrying at 480p');
    return _runVideoCompression(
      filePath: filePath,
      outputName: outputName,
      width: 854,
      height: 480,
    );
  }

  Future<double> _videoDurationSeconds(String filePath) async {
    try {
      final mediaInfo = await _compressor.getMediaInfo(filePath);
      return mediaInfo.duration?.inMilliseconds == null
          ? _maxVideoDuration.inSeconds.toDouble()
          : mediaInfo.duration!.inMilliseconds / 1000;
    } catch (_) {
      return _maxVideoDuration.inSeconds.toDouble();
    }
  }

  Future<File?> _runVideoCompression({
    required String filePath,
    required String outputName,
    required int width,
    required int height,
  }) async {
    final result = await _compressor.compressVideo(
      path: filePath,
      videoQuality: VideoQuality.high,
      isMinBitrateCheckEnabled: false,
      disableAudio: true,
      videoFormat: VideoFormat.h264,
      video: Video(
        videoName: outputName,
        targetSizeMb: _targetVideoSizeMb,
        twoPass: false,
        videoWidth: width,
        videoHeight: height,
      ),
      android: AndroidConfig(isSharedStorage: false),
      ios: IOSConfig(saveInGallery: false),
    );

    if (result is OnSuccess) {
      log(
        'Compression done: ${result.compressedSize} bytes, '
        'codec=${result.usedFormat.name}, '
        'targetMet=${result.targetSizeMet}, passes=${result.passesUsed}',
      );
      return File(result.destinationPath);
    }

    log('Video compression failed: $result');
    return null;
  }

  Future<void> onClickFullWalkaroundVideo(
    String? videoId,
    String insepctionId,
    bool isFromGallery,
    BuildContext context,
  ) async {
    final imagePicker = ImagePicker();
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      // if (await AppPermission.askCameraAndGallery(context)) {
      final pickedFIle = await imagePicker.pickVideo(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,

        maxDuration: _maxVideoDuration,
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
    // }
  }

  Future<void> onClickFullEngineVideo(
    String? videoId,
    String insepctionId,
    bool isFromGallery,
    BuildContext context,
  ) async {
    final imagePicker = ImagePicker();

    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      final pickedFIle = await imagePicker.pickVideo(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        maxDuration: _maxVideoDuration,
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
    // }
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

  Future<void> deleteVideo(
    BuildContext context,
    String videoType,
    String inspctionId,
    String videoId,
  ) async {
    final currentState = state;
    if (currentState is UploadVehicleVideoSuccessState) {
      emit(
        currentState.copyWith(
          isEngineUploading: videoType == ENGINESIDE ? true : null,
          isWalkAroundUploading: videoType == WLAKAROUND ? true : null,
        ),
      );
      await _deleteVideo(inspctionId, videoId, context);
      await onFetcUploadVideos(context, inspctionId);
    }
  }
}
