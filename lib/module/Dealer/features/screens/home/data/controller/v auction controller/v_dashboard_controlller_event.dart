part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VAuctionControlllerEvent {}

class OnFetchVendorAuctionApi extends VAuctionControlllerEvent {
  final BuildContext context;

  OnFetchVendorAuctionApi({required this.context});
}

class ConnectWebSocket extends VAuctionControlllerEvent {
  final BuildContext context;

  ConnectWebSocket({required this.context});
}

class UpdatePrice extends VAuctionControlllerEvent {
  BuildContext context;
  final LiveBidModel newBid;
  UpdatePrice({required this.newBid, required this.context});
}
