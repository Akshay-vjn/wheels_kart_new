part of 'v_my_auction_controller_bloc.dart';

@immutable
sealed class VMyAuctionControllerState {}

final class VMyAuctionControllerInitial extends VMyAuctionControllerState {}

class VMyAuctionControllerLoadingState extends VMyAuctionControllerState {}

class VMyAuctionControllerErrorState extends VMyAuctionControllerState {
  final String error;

  VMyAuctionControllerErrorState(this.error);
}

class VMyAuctionControllerSuccessState extends VMyAuctionControllerState {
  final List<VMyAuctionModel> listOfMyAuctions;

  VMyAuctionControllerSuccessState({required this.listOfMyAuctions});
}

class VMyAuctionControllerOwnedLoadingState extends VMyAuctionControllerState {}

class VMyAuctionControllerOwnedSuccessState extends VMyAuctionControllerState {
  final List<VMyAuctionModel> listOfOwnedAuctions;

  VMyAuctionControllerOwnedSuccessState({required this.listOfOwnedAuctions});
}
