part of 'v_details_controller_bloc.dart';

@immutable
sealed class VDetailsControllerEvent {}

class OnFetchDetails extends VDetailsControllerEvent {
  final String inspectionId;
  final BuildContext context;

  OnFetchDetails({required this.inspectionId, required this.context});
}

class OnChangeImageIndex extends VDetailsControllerEvent {
  final int newIndex;

  OnChangeImageIndex({required this.newIndex});
}

class OnCollapesCard extends VDetailsControllerEvent {
  final int index;

  OnCollapesCard({required this.index});
}

class OnChangeImageTab extends VDetailsControllerEvent {
  final int imageTabIndex;

  OnChangeImageTab({
    required this.imageTabIndex,
  });
}



// WEB SOCKET

class ConnectWebSocket extends VDetailsControllerEvent {}

class UpdatePrice extends VDetailsControllerEvent {
  final LiveBidModel newBid;
  UpdatePrice({required this.newBid});
}