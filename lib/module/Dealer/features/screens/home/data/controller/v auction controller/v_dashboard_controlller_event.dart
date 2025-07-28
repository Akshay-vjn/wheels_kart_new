part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VAuctionControlllerEvent {}

class OnFetchVendorAuctionApi extends VAuctionControlllerEvent {
  final BuildContext context;

  OnFetchVendorAuctionApi({required this.context});
}


class ConnectWebSocket extends VAuctionControlllerEvent {}

class UpdatePrice extends VAuctionControlllerEvent {
  final LiveBidModel newBid;
  UpdatePrice({required this.newBid});
}
