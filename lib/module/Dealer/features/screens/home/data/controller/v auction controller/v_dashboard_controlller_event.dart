part of 'v_dashboard_controlller_bloc.dart';

@immutable
sealed class VAuctionControlllerEvent {}

class OnFetchVendorAuctionApi extends VAuctionControlllerEvent {
  final BuildContext context;
  final String tab;

  OnFetchVendorAuctionApi({required this.context, required this.tab});
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

class OnApplyFilterAndSortInAuction extends VAuctionControlllerEvent {
  final String? sortBy;
  Map<FilterCategory, List<dynamic>>? filterBy;

  OnApplyFilterAndSortInAuction({required this.sortBy, this.filterBy});
}

class OnSearchAuction extends VAuctionControlllerEvent {
  final String query;

  OnSearchAuction({required this.query});
}
