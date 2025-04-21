part of 'uplaod_vehilce_photo_cubit.dart';

@immutable
sealed class UplaodVehilcePhotoState {}

final class UplaodVehilcePhotoInitialState extends UplaodVehilcePhotoState {}

final class UplaodVehilcePhotoErrorState extends UplaodVehilcePhotoState {
  final String errorMessage;

  UplaodVehilcePhotoErrorState({required this.errorMessage});
}

final class UplaodVehilcePhotoLoadingState extends UplaodVehilcePhotoState {}

final class UplaodVehilcePhotoSuccessState extends UplaodVehilcePhotoState {}
