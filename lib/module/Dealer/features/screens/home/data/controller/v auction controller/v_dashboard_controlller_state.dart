part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VAuctionControlllerState {}

final class VAuctionControlllerInitialState
    extends VAuctionControlllerState {}

final class VAuctionControlllerLoadingState
    extends VAuctionControlllerState {}

final class VVAuctionControllerErrorState extends VAuctionControlllerState {
  final String errorMesage;
  VVAuctionControllerErrorState({required this.errorMesage});
}

final class VAuctionControllerSuccessState
    extends VAuctionControlllerState {
  final List<VCarModel> listOfCars;

  VAuctionControllerSuccessState({required this.listOfCars});
}
