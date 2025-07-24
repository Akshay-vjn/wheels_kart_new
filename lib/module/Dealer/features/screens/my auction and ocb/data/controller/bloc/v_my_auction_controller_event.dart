part of 'v_my_auction_controller_bloc.dart';

@immutable
sealed class VMyAuctionControllerEvent {}

class OnGetMyAuctions extends VMyAuctionControllerEvent {
  final BuildContext context;

  OnGetMyAuctions({required this.context});
}
