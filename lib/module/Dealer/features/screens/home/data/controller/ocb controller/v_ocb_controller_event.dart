part of 'v_ocb_controller_bloc.dart';

@immutable
sealed class VOcbControllerEvent {}

class OnFechOncList extends VOcbControllerEvent {
  final BuildContext context;

  OnFechOncList({required this.context});
}

class ConnectWebSocket extends VOcbControllerEvent {
  final BuildContext context;

  ConnectWebSocket({required this.context});
}

class UpdatePrice extends VOcbControllerEvent {
  final LiveBidModel newBid;
  final BuildContext context;
  UpdatePrice({required this.newBid, required this.context});
}

class OnApplyFilterAndSortInOCB extends VOcbControllerEvent {
  final String? sortBy;
  Map<FilterCategory, List<dynamic>>? filterBy;

  OnApplyFilterAndSortInOCB({required this.sortBy, this.filterBy});
}

class OnSearchOCB extends VOcbControllerEvent {
  final String query;

  OnSearchOCB({required this.query});
}
