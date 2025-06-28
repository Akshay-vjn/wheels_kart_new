part of 'v_details_controller_bloc.dart';

@immutable
sealed class VDetailsControllerState {}

final class VDetailsControllerInitialState extends VDetailsControllerState {}

final class VDetailsControllerErrorState extends VDetailsControllerState {
  final String error;

  VDetailsControllerErrorState({required this.error});
}

final class VDetailsControllerLoadingState extends VDetailsControllerState {}

final class VDetailsControllerSuccessState extends VDetailsControllerState {
  final VCarDetailModel detail;
  final int currentImageIndex;

  VDetailsControllerSuccessState({
    required this.detail,
    this.currentImageIndex = 0,
  });

  VDetailsControllerSuccessState coptyWith({
    VCarDetailModel? detail,
    int? currentImageIndex,
  }) {
    return VDetailsControllerSuccessState(
      detail: detail ?? this.detail,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }
}
