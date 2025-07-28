part of 'v_ocb_controller_bloc.dart';

@immutable
sealed class VOcbControllerState {}

final class VOcbControlllerInitialState extends VOcbControllerState {}

final class VOcbControlllerLoadingState extends VOcbControllerState {}

final class VOcbControllerErrorState extends VOcbControllerState {
  final String errorMesage;
  VOcbControllerErrorState({required this.errorMesage});
}

final class VOcbControllerSuccessState extends VOcbControllerState {
  final List<VCarModel> listOfCars;
  final bool loadingTheOCBButton;
  final bool enableRefreshButton;

  VOcbControllerSuccessState({
    required this.listOfCars,
    this.loadingTheOCBButton = false,
    required this.enableRefreshButton,
  });
  VOcbControllerSuccessState copyWith({
    List<VCarModel>? listOfCars,
    bool? loadingTheOCBButton,
    bool? enableRefreshButton,
  }) {
    return VOcbControllerSuccessState(
      enableRefreshButton: enableRefreshButton ?? this.enableRefreshButton,
      loadingTheOCBButton: loadingTheOCBButton ?? this.loadingTheOCBButton,
      listOfCars: listOfCars ?? this.listOfCars,
    );
  }
}
