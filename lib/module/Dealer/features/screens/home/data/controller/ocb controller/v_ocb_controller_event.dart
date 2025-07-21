part of 'v_ocb_controller_bloc.dart';

@immutable
sealed class VOcbControllerEvent {}

class OnFechOncList extends VOcbControllerEvent {
  final BuildContext context;

  OnFechOncList({required this.context});
}

class ConnectWebSocket extends VOcbControllerEvent {}

class UpdatePrice extends VOcbControllerEvent {
  final LiveBidModel newBid;
  UpdatePrice({required this.newBid});
}
