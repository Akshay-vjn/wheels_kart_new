part of 'auth_cubit.dart';

sealed class AppAuthControllerState {}

final class AppAuthControllerInitialState extends AppAuthControllerState {}

final class AuthLodingState extends AppAuthControllerState {}

final class AuthErrorState extends AppAuthControllerState {
  String errorMessage;
  AuthErrorState({required this.errorMessage});
}

final class AuthCubitSendOTPState extends AppAuthControllerState {
  int userId;
  final bool? isEnabledResendOTPButton;
   int? runTime;

  AuthCubitSendOTPState({
    this.isEnabledResendOTPButton,
    this.runTime,
    required this.userId,
  });

  AuthCubitSendOTPState copyWith({
    int? userId,
    bool? isEnabledResendOTPButton,
    int? runTime,
  }) {
    return AuthCubitSendOTPState(
      isEnabledResendOTPButton:
          isEnabledResendOTPButton ?? this.isEnabledResendOTPButton,
      runTime: runTime ?? this.userId,
      userId: userId ?? this.userId,
    );
  }
}

final class AuthCubitAuthenticateState extends AppAuthControllerState {
  AuthUserModel userModel;
  String loginMesaage;

  AuthCubitAuthenticateState({
    required this.userModel,
    required this.loginMesaage,
  });
}

final class AuthCubitUnAuthenticatedState extends AppAuthControllerState {}
