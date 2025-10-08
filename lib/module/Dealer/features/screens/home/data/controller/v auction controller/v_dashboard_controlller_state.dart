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

  final List<VCarModel> filterdAutionList;

  final bool enableRefreshButton;

  VAuctionControllerSuccessState({
    required this.listOfAllLiveAuctionFromServer,
    required this.enableRefreshButton,
    required this.filterdAutionList,
  });

  VAuctionControllerSuccessState copyWith({
    List<VCarModel>? listOfAllLiveAuctionFromServer,
    List<VCarModel>? filterdAutionList,
    bool? enableRefreshButton,
  }) {
    return VAuctionControllerSuccessState(
   
      listOfAllLiveAuctionFromServer:
          listOfAllLiveAuctionFromServer ?? this.listOfAllLiveAuctionFromServer,
      enableRefreshButton: enableRefreshButton ?? this.enableRefreshButton,
      filterdAutionList: filterdAutionList ?? this.filterdAutionList,
    );
  }
}
