part of 'live_price_change_controller_bloc.dart';

@immutable
sealed class LivePriceChangeControllerState {}

final class LivePriceChangeControllerInitial
    extends LivePriceChangeControllerState {}

class PriceUpdated extends LivePriceChangeControllerState {
  final String price;
  PriceUpdated(this.price);
}
