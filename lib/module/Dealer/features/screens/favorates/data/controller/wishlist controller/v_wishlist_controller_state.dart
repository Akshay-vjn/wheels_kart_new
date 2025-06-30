part of 'v_wishlist_controller_cubit.dart';

@immutable
sealed class VWishlistControllerState {}

final class VWishlistControllerInitialState extends VWishlistControllerState {}

final class VWishlistControllerErrorState extends VWishlistControllerState {
  final String error;

  VWishlistControllerErrorState({required this.error});
}

final class VWishlistControllerLoadingState extends VWishlistControllerState {}

final class VWishlistControllerSuccessState extends VWishlistControllerState {
  final List<VCarModel> myWishList;

  VWishlistControllerSuccessState({required this.myWishList});
}
