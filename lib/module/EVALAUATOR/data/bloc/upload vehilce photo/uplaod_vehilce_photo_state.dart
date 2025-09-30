part of 'uplaod_vehilce_photo_cubit.dart';

@immutable
sealed class UplaodVehilcePhotoState {
  final String? selectedAngleId;
  final File? selectedImageFile;
  final int? currentPageIndex;

  const UplaodVehilcePhotoState({
    this.selectedAngleId,
    this.selectedImageFile,
    this.currentPageIndex = 0,
  });
}

final class UplaodVehilcePhotoInitialState extends UplaodVehilcePhotoState {}

final class UplaodVehilcePhotoErrorState extends UplaodVehilcePhotoState {
  final String errorMessage;

  UplaodVehilcePhotoErrorState({required this.errorMessage});
}

final class UplaodVehilcePhotoLoadingState extends UplaodVehilcePhotoState {}

final class UplaodVehilcePhotoSuccessState extends UplaodVehilcePhotoState {
  UplaodVehilcePhotoSuccessState(
    String? angleId,
    File? selectedImageFile,
    int? currentPageIndex,
  ) : super(
        selectedAngleId: angleId,
        selectedImageFile: selectedImageFile,
        currentPageIndex: currentPageIndex,
      );
}
