part of 'v_policy_controller_cubit.dart';

@immutable
sealed class VPolicyControllerState {}

final class VPolicyControllerInitialState extends VPolicyControllerState {}

final class VPolicyControllerLoadingState extends VPolicyControllerState {}

final class VPolicyControllerErrorState extends VPolicyControllerState {
  final String error;

  VPolicyControllerErrorState({required this.error});
}

final class VPolicyControllerSuccessState extends VPolicyControllerState {
  final String htmlContent;

  VPolicyControllerSuccessState({required this.htmlContent});
}

