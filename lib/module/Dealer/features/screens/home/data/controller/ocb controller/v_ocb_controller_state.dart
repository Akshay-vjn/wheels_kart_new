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

  VOcbControllerSuccessState({required this.listOfCars});
}
