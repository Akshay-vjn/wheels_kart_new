part of 'upload_vehicle_video_cubit.dart';

@immutable
sealed class UploadVehicleVideoState {}

final class UploadVehicleVideoInitialState extends UploadVehicleVideoState {}

class UploadVehicleVideoLoadingState extends UploadVehicleVideoState {}

class UploadVehicleVideoErrorState extends UploadVehicleVideoState {
  final String error;

  UploadVehicleVideoErrorState({required this.error});
}

class UploadVehicleVideoSuccessState extends UploadVehicleVideoState {
  final List<VideoModel> videos;
  bool isWalkAroundUploading;
  bool isEngineUploading;
  bool isAvailableEngineVideo;
  bool isAvailabeWalkaroundVideo;

  UploadVehicleVideoSuccessState({
    required this.videos,
    this.isWalkAroundUploading = false,
    this.isEngineUploading = false,
    required this.isAvailabeWalkaroundVideo,
    required this.isAvailableEngineVideo,
  });

  UploadVehicleVideoSuccessState copyWith({
    List<VideoModel>? videos,
    bool? isWalkAroundUploading,
    bool? isEngineUploading,
    bool? isAvailableEngineVideo,
    bool? isAvailabeWalkaroundVideo,
  }) {
    return UploadVehicleVideoSuccessState(
      videos: videos ?? this.videos,
      isEngineUploading: isEngineUploading ?? this.isEngineUploading,
      isWalkAroundUploading:
          isWalkAroundUploading ?? this.isWalkAroundUploading,
      isAvailabeWalkaroundVideo:
          isAvailabeWalkaroundVideo ?? this.isAvailabeWalkaroundVideo,
      isAvailableEngineVideo:
          isAvailableEngineVideo ?? this.isAvailableEngineVideo,
    );
  }
}
