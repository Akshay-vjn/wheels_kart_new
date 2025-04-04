part of 'auth_cubit.dart';

sealed class EvAuthBlocState {}

final class AuthCubitInitialState extends EvAuthBlocState {}

final class AuthLodingState extends EvAuthBlocState {
 
}

final class AuthErrorState extends EvAuthBlocState {
  String errorMessage;
  AuthErrorState({required this.errorMessage});
}

final class AuthCubitAuthenticateState extends EvAuthBlocState {
  AuthUserModel userModel;
  String loginMesaage;

  AuthCubitAuthenticateState(
      {required this.userModel, required this.loginMesaage});
}

final class AuthCubitUnAuthenticatedState extends EvAuthBlocState {}
