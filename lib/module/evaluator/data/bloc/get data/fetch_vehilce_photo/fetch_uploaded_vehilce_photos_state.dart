part of 'fetch_uploaded_vehilce_photos_cubit.dart';

@immutable
sealed class FetchUploadedVehilcePhotosState {}

final class FetchUploadedVehilcePhotosInitialState
    extends FetchUploadedVehilcePhotosState {}

final class FetchUploadedVehilcePhotosErrorState
    extends FetchUploadedVehilcePhotosState {
  final String errorMessage;

  FetchUploadedVehilcePhotosErrorState({required this.errorMessage});
}

final class FetchUploadedVehilcePhotosLoadingState
    extends FetchUploadedVehilcePhotosState {}

final class FetchUploadedVehilcePhotosSuccessSate
    extends FetchUploadedVehilcePhotosState {
  final List<VehiclePhotoModel> vehiclePhtotos;

  FetchUploadedVehilcePhotosSuccessSate({required this.vehiclePhtotos});
}
