part of 'live_price_change_controller_bloc.dart';

@immutable
sealed class LivePriceChangeControllerEvent {}

class ConnectWebSocket extends LivePriceChangeControllerEvent {}

class UpdatePrice extends LivePriceChangeControllerEvent {
  final String price;
  UpdatePrice(this.price);
}
