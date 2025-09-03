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
  UpdatePrice( {required this.newBid,required  this.context});
}

class OnBuyOCB extends VOcbControllerEvent {
  final String inspectionId;
  final BuildContext context;
  OnBuyOCB({required this.inspectionId, required this.context});
}
