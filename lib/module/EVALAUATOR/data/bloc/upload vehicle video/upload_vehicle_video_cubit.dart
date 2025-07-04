import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'upload_vehicle_video_state.dart';

class UploadVehicleVideoCubit extends Cubit<UploadVehicleVideoState> {
  UploadVehicleVideoCubit() : super(UploadVehicleVideoInitialState());

  Future<void> onFetcUploadVideos() async {
    emit(UploadVehicleVideoSuccessState());
  }

  Future<void> _uploadVideo(File file, String id) async {}

  Future<void> onClickFullWalkaroundVideo(
    bool alredyHaveVideo,
    String id,
  ) async {
    final pickedFIle = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: 1),
    );

    if (pickedFIle == null) return;

    if (alredyHaveVideo) {
      _deleteVideo();
    }
    await _uploadVideo(File(pickedFIle.path), id);
  }

  Future<void> onClickFullEngineVideo(bool alredyHaveVideo, String id) async {
    final pickedFIle = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: 1),
    );

    if (pickedFIle == null) return;

    if (alredyHaveVideo) {
      _deleteVideo();
    }
    await _uploadVideo(File(pickedFIle.path), id);
  }

  Future<void> _deleteVideo() async {}
}
