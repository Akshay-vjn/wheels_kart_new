part of 'auth_cubit.dart';

sealed class AppAuthControllerState {}

final class AppAuthControllerInitialState extends AppAuthControllerState {}

final class AuthLodingState extends AppAuthControllerState {
 
}

final class AuthErrorState extends AppAuthControllerState {
  String errorMessage;
  AuthErrorState({required this.errorMessage});
}

final class AuthCubitAuthenticateState extends AppAuthControllerState {
  AuthUserModel userModel;
  String loginMesaage;

  AuthCubitAuthenticateState(
      {required this.userModel, required this.loginMesaage});
}

final class AuthCubitUnAuthenticatedState extends AppAuthControllerState {}
