part of 'v_auction_update_controller_cubit.dart';

@immutable
sealed class VAuctionUpdateControllerState {}

final class VAuctionUpdateControllerInitialState
    extends VAuctionUpdateControllerState {}

final class VAuctionUpdateLoadingState extends VAuctionUpdateControllerState {}

final class VAuctionUpdateErrorState extends VAuctionUpdateControllerState {}

final class VAcutionUpdateSuccessState extends VAuctionUpdateControllerState {}
