part of 'upload_vehicle_video_cubit.dart';

@immutable
sealed class UploadVehicleVideoState {}

final class UploadVehicleVideoInitialState extends UploadVehicleVideoState {}

class UploadVehicleVideoLoadingState extends UploadVehicleVideoState{}

class UploadVehicleVideoErrorState extends UploadVehicleVideoState{
  final String error;

  UploadVehicleVideoErrorState({required this.error});
}

class UploadVehicleVideoSuccessState extends UploadVehicleVideoState{}
