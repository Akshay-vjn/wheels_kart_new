part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VDashboardControlllerState {}

final class VDashboardControlllerInitialState
    extends VDashboardControlllerState {}

final class VDashboardControlllerLoadingState
    extends VDashboardControlllerState {}

final class VDashboardControllerErrorState extends VDashboardControlllerState {
  final String errorMesage;
  VDashboardControllerErrorState({required this.errorMesage});
}

final class VDashboardControllerSuccessState
    extends VDashboardControlllerState {
  final List<VCarModel> listOfCars;

  VDashboardControllerSuccessState({required this.listOfCars});
}
