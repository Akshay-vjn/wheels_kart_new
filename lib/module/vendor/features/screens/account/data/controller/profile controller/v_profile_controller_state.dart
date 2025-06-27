part of 'v_profile_controller_cubit.dart';

@immutable
sealed class VProfileControllerState {}

final class VProfileControllerInitialState extends VProfileControllerState {}

final class VProfileControllerLoadingState extends VProfileControllerState {}

final class VProfileControllerErrorState extends VProfileControllerState {
  final String error;

  VProfileControllerErrorState({required this.error});
}

final class VProfileControllerSuccessState extends VProfileControllerState {
  final VProfileModel profileModel;

  VProfileControllerSuccessState({required this.profileModel});
}
