part of 'v_my_auction_controller_bloc.dart';

@immutable
sealed class VMyAuctionControllerEvent {}

class OnGetMyAuctions extends VMyAuctionControllerEvent {
  final BuildContext context;

  OnGetMyAuctions({required this.context});
}

class ConnectWebSocket extends VMyAuctionControllerEvent {}

class UpdatePrice extends VMyAuctionControllerEvent {
  final LiveBidModel newBid;
  UpdatePrice({required this.newBid});
}
