part of 'v_auth_controller_cubit.dart';

@immutable
 class VAuthControllerState {
  bool isObsecure;
  VAuthControllerState({this.isObsecure = true});
}

final class VAuthControllerInitial extends VAuthControllerState {
  VAuthControllerInitial() : super(isObsecure: true);
}
