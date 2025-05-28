part of 'uplaod_vehilce_photo_cubit.dart';

@immutable
sealed class UplaodVehilcePhotoState {
  final  String ?selectedAngleId;
  final File ?selectedImageFile;

  UplaodVehilcePhotoState({ this.selectedAngleId, this.selectedImageFile});
}

final class UplaodVehilcePhotoInitialState extends UplaodVehilcePhotoState {
}

final class UplaodVehilcePhotoErrorState extends UplaodVehilcePhotoState {
  final String errorMessage;

  UplaodVehilcePhotoErrorState({required this.errorMessage});
}

final class UplaodVehilcePhotoLoadingState extends UplaodVehilcePhotoState {
}

final class UplaodVehilcePhotoSuccessState extends UplaodVehilcePhotoState {
  UplaodVehilcePhotoSuccessState(String ?angleId,File ?selectedImageFile):super(selectedAngleId: angleId,selectedImageFile: selectedImageFile);

  // UplaodVehilcePhotoSuccessState copyWith({String ?selectedAngle}){
  //   return UplaodVehilcePhotoSuccessState(selectedAngleId: selectedAngle);
  // }
}
