part of 'v_my_auction_controller_bloc.dart';

@immutable
sealed class VMyAuctionControllerEvent {}

class OnGetMyAuctions extends VMyAuctionControllerEvent {
  final BuildContext context;

  OnGetMyAuctions({required this.context});
}

class ConnectWebSocket extends VMyAuctionControllerEvent {
  final String myId;

  ConnectWebSocket({required this.myId});
}

class UpdatePrice extends VMyAuctionControllerEvent {
  final LiveBidModel newBid;
  final String myId;
  UpdatePrice({required this.newBid, required this.myId});
}
