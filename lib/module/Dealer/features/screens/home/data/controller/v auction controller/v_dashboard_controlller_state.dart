part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VAuctionControlllerState {}

final class VAuctionControlllerInitialState extends VAuctionControlllerState {}

final class VAuctionControlllerLoadingState extends VAuctionControlllerState {}

final class VVAuctionControllerErrorState extends VAuctionControlllerState {
  final String errorMesage;
  VVAuctionControllerErrorState({required this.errorMesage});
}

final class VAuctionControllerSuccessState extends VAuctionControlllerState {
  final List<VCarModel> listOfAllLiveAuctionFromServer;
  // final List<VCarModel> listOfAllClosedAuctionFromServer;

  final List<VCarModel> filterdAutionList;

  final bool enableRefreshButton;

  VAuctionControllerSuccessState({
    required this.listOfAllLiveAuctionFromServer,
    required this.enableRefreshButton,
    required this.filterdAutionList,
    // required this.listOfAllClosedAuctionFromServer,
  });

  VAuctionControllerSuccessState copyWith({
    List<VCarModel>? listOfAllLiveAuctionFromServer,
    List<VCarModel>? filterdAutionList,
    bool? enableRefreshButton,
    // List<VCarModel>? listOfAllClosedAuctionFromServer,
  }) {
    return VAuctionControllerSuccessState(
      // listOfAllClosedAuctionFromServer:
      //     listOfAllClosedAuctionFromServer ??
      //     this.listOfAllClosedAuctionFromServer,
      listOfAllLiveAuctionFromServer:
          listOfAllLiveAuctionFromServer ?? this.listOfAllLiveAuctionFromServer,
      enableRefreshButton: enableRefreshButton ?? this.enableRefreshButton,
      filterdAutionList: filterdAutionList ?? this.filterdAutionList,
    );
  }
}
