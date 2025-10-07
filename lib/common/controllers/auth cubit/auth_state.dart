part of 'auth_cubit.dart';

sealed class AppAuthControllerState {
  bool? isEnabledResendOTPButton;
  int? runTime;
  int? userId;

  AppAuthControllerState({
    this.isEnabledResendOTPButton,
    this.runTime,
    this.userId,
  });
}

final class AppAuthControllerInitialState extends AppAuthControllerState {
  AppAuthControllerInitialState({super.userId}) {
    log("Initial .... ${userId.toString()}");
  }
}

final class AuthLodingState extends AppAuthControllerState {
  AuthLodingState({super.userId}) {
    log("Loading .... ${userId.toString()}");
  }
}

final class AuthErrorState extends AppAuthControllerState {
  String errorMessage;
  AuthErrorState({required this.errorMessage, super.userId}) {
    log("Error .... ${userId.toString()}");
  }
}

final class AuthCubitSendOTPState extends AppAuthControllerState {
  String? sheetErrorMessage;
  bool isLoadingVerifyOTP;
  AuthCubitSendOTPState({
    super.isEnabledResendOTPButton = true,
    super.runTime,
    super.userId,
    required this.sheetErrorMessage,
    required this.isLoadingVerifyOTP,
  }) {
    log("OTP STATE .... ${userId.toString()}");
  }

  AuthCubitSendOTPState copyWith({
    int? userId,
    bool? isEnabledResendOTPButton,
    int? runTime,
    String? sheetErrorMessage,
    bool? isLoadingVerifyOTP,
  }) {
    return AuthCubitSendOTPState(
      isLoadingVerifyOTP: isLoadingVerifyOTP ?? this.isLoadingVerifyOTP,
      sheetErrorMessage: sheetErrorMessage ?? this.sheetErrorMessage,
      isEnabledResendOTPButton:
          isEnabledResendOTPButton ?? super.isEnabledResendOTPButton,
      runTime: runTime ?? super.runTime,
      userId: userId ?? super.userId,
    );
  }
}

final class AuthCubitAuthenticateState extends AppAuthControllerState {
  AuthUserModel userModel;
  String loginMesaage;

  AuthCubitAuthenticateState({
    required this.userModel,
    required this.loginMesaage,
    super.userId,
  }) {
    log("Authenticated .... ${userId.toString()}");
  }
}

final class AuthCubitUnAuthenticatedState extends AppAuthControllerState {}
