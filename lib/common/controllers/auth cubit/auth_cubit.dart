import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_kart/common/components/delete_account_success_screen.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_otp_login_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_resend_otp_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_verify_otp_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/otp_sheet.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/auth_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/ev_register_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/ev_resend_otp_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/ev_send_otp_repo.dart';
import 'package:wheels_kart/module/Dealer/core/utils/v_messages.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_register_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/v_login_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/ev_verify_otp_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/fetch_profile_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_login_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_otp_sheet.dart';
import 'package:wheels_kart/module/spash_screen.dart';

part 'auth_state.dart';

class AppAuthController extends Cubit<AppAuthControllerState> {
  AppAuthController() : super(AppAuthControllerInitialState());
  //. LOCAL DATA STORING FOR USER CREDANTIAL (COMMON FOR BOTH MODULE)
  static const String mobileNumberKey = 'MOBILE_NUMBER';
  static const String tokenKey = 'TOKEN_KEY';
  static const String userIdKey = "USER_ID";
  static const String userNameKey = "USER_NAME";
  static const String userTypeKey = "USER_TYPE";
  static const String isDealerAcceptedTermsAndCondition =
      "IS_ACCEPTED_TERMS_AND_CONDITION";

  Future<void> _setLoginPreference(AuthUserModel userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(mobileNumberKey, userData.mobileNumber ?? '');
    preferences.setString(tokenKey, userData.token ?? '');

    preferences.setString(userIdKey, userData.userId ?? '');
    preferences.setString(userNameKey, userData.userName ?? '');
    preferences.setString(userTypeKey, userData.userType ?? '');

    preferences.setBool(
      isDealerAcceptedTermsAndCondition,
      userData.isDealerAcceptedTermsAndCondition ?? false,
    );
  }

  Future<void> updateLoginPreference(AuthUserModel userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = await getUserData;

    preferences.setString(
      mobileNumberKey,
      userData.mobileNumber ?? data.mobileNumber ?? '',
    );

    preferences.setString(tokenKey, userData.token ?? data.token ?? '');

    preferences.setString(userIdKey, userData.userId ?? data.userId ?? '');
    preferences.setString(
      userNameKey,
      userData.userName ?? data.userName ?? '',
    );
    preferences.setString(
      userTypeKey,
      userData.userType ?? data.userType ?? '',
    );

    preferences.setBool(
      isDealerAcceptedTermsAndCondition,
      userData.isDealerAcceptedTermsAndCondition ??
          data.isDealerAcceptedTermsAndCondition ??
          false,
    );
    final newData = await getUserData;

    log("New Updated Datas");
    log("Name - > ${newData.userName}");
    log("Number - > ${newData.mobileNumber}");
    log("Type -> ${newData.userType}");
    log("User ID - > ${newData.userId}");
    log("Terms Accepted=> ${newData.isDealerAcceptedTermsAndCondition}");
  }

  // GET USER DATA

  Future<AuthUserModel> get getUserData async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String? number = preferences.getString(mobileNumberKey);

    String? token = preferences.getString(tokenKey);

    String? userId = preferences.getString(userIdKey);

    String? name = preferences.getString(userNameKey);

    String? userType = preferences.getString(userTypeKey);

    bool? isAcceptedTermsAndCondition = preferences.getBool(
      isDealerAcceptedTermsAndCondition,
    );

    return AuthUserModel(
      mobileNumber: number,
      token: token,
      userId: userId,
      userType: userType,
      userName: name,
      isDealerAcceptedTermsAndCondition: isAcceptedTermsAndCondition,
    );
  }

  // LOG OUT USER{}
  Future<void> clearPreferenceData(
    context, {
    bool navigateToDelete = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(mobileNumberKey);
    await prefs.remove(tokenKey);
    // profile data
    await prefs.remove(userNameKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userTypeKey);

    await prefs.remove(isDealerAcceptedTermsAndCondition);

    emit(AuthCubitUnAuthenticatedState());
    if (navigateToDelete) {
      Navigator.of(context).pushAndRemoveUntil(
        AppRoutes.createRoute(AccountDeletionSuccessScreen()),
        (context) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        AppRoutes.createRoute(const SplashScreen()),
        (context) => false,
      );
    }
  }
  // Common Function For Checking The Token Expire Or Not . If The Token Is Expire Then Automatically It Will Logout The User.

  Future<void> checkTheTokenValidity(BuildContext context) async {
    final userData = await getUserData;
    bool isEvaluator =
        userData.userType == "EVALUATOR" || userData.userType == "ADMIN";
    bool alreadyLogin = userData.token != null && userData.userName != null;

    log("Check Token Expire on Not");
    log("Name - > ${userData.userName}");
    log("Number - > ${userData.mobileNumber}");
    log("Type -> ${userData.userType}");
    log("User ID - > ${userData.userId}");
    log("Terms Accepted=> ${userData.isDealerAcceptedTermsAndCondition}");

    if (alreadyLogin) {
      Uri url;

      if (isEvaluator) {
        url = Uri.parse('${EvApiConst.baseUrl}${EvApiConst.fetchProfile}');
      } else {
        url = Uri.parse('${VApiConst.baseUrl}${VApiConst.profile}');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userData.token ?? "",
        },
      );

      final decodedata = jsonDecode(response.body);
      log(decodedata.toString());
      if (decodedata['status'] == 200) {
        emit(
          AuthCubitAuthenticateState(
            loginMesaage: "Login Success",
            userModel: userData,
          ),
        );
      } else {
        await clearPreferenceData(context);

        emit(AuthCubitUnAuthenticatedState());
      }
    } else {
      emit(AuthCubitUnAuthenticatedState());
    }
  }

  // Evalatualor Auth Functiond

  // -- 1 -- Regitser Evaluator (its might be remove)
  Future<bool> registerEvaluator(
    BuildContext context,
    String mobileNumber,
    String password,
    String confirmPassword,
    String name,
  ) async {
    emit(AuthLodingState());
    final snapshot = await EvRegisterRepo.registerEvaluator(
      mobileNumber,
      password,
      confirmPassword,

      name,
    );

    if (snapshot['error'] == false && snapshot.isNotEmpty) {
      emit(AppAuthControllerInitialState());
      showSnakBar(
        context,
        "Congratulation!.Registration successful, you can login now.",
        isError: false,
        enablePop: true,
      );

      Navigator.of(
        context,
      ).pushReplacement(AppRoutes.createRoute(EvLoginScreen()));
      return true;
    } else {
      showSnakBar(context, snapshot['message'], isError: true, enablePop: true);
      emit(AuthErrorState(errorMessage: snapshot['message']));
      return false;
    }
  }

  // -- 2 -- Send OTP for Login
  Future<void> sendOtpForEvaluator(
    BuildContext context,
    String mobileNumber,
  ) async {
    emit(AuthLodingState());
    final snapshot = await EvSendOtpRepo.sendOtp(mobileNumber);

    if (snapshot['error'] == false) {
      log(snapshot['employeeId'].toString());

      HapticFeedback.mediumImpact();

      showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
        ),
        backgroundColor: EvAppColors.white,
        builder:
            (context) => EvOtpSheet(
              mobilNumber: mobileNumber.trim(),
              userId: int.parse(snapshot['employeeId']),
            ),
      );

      emit(
        AuthCubitSendOTPState(
          sheetErrorMessage: null,
          isLoadingVerifyOTP: false,
          runTime: null,
          isEnabledResendOTPButton: true,
          userId: int.parse(snapshot['employeeId']),
        ),
      );
    } else if (snapshot['error'] == true) {
      log(snapshot['message']);
      showSnakBar(context, snapshot['message'], isError: true, enablePop: true);

      emit(AuthErrorState(errorMessage: snapshot['message']));
    } else {
      log('error');
      showSnakBar(
        context,
        'No Internet Connection !',
        isError: true,
        enablePop: true,
      );

      emit(AuthErrorState(errorMessage: 'No Internet Connection !'));
    }
  }
  // -- 3 -- Verify OTP for Login

  Future<void> evaluatorVerifyOtp(
    BuildContext context,
    String mobileNumber,
    String otp,
    int userId, {
    String? name,
  }) async {
    final currentState = state as AuthCubitSendOTPState;
    emit(currentState.copyWith(isLoadingVerifyOTP: true));
    final snapshot = await EvVerifyOtpRepo.verifyOtp(userId, otp);
    if (snapshot.isNotEmpty) {
      if (snapshot['error'] == false) {
        final profileSnapshot = await FetchFProfileDataRepos.getProfileData(
          snapshot['token'],
        );
        if (profileSnapshot['error'] == false) {
          log(profileSnapshot['message']);

          final authmodel = AuthUserModel(
            mobileNumber: mobileNumber,
            token: snapshot['token'],
            userName: profileSnapshot['data']['userFullName'],
            userId: profileSnapshot['data']['userId'],
            userType: profileSnapshot['data']['userType'],
          );
          await _setLoginPreference(authmodel);
          emit(
            AuthCubitAuthenticateState(
              userId: int.parse(profileSnapshot['data']['userId']),
              userModel: authmodel,
              loginMesaage: snapshot['message'],
            ),
          );
        } else if (profileSnapshot['error'] == true) {
          emit(
            currentState.copyWith(
              isLoadingVerifyOTP: false,
              sheetErrorMessage: profileSnapshot['message'],
            ),
          );
          // emit(
          //   AuthErrorState(
          //     userId: userId,
          //     errorMessage: profileSnapshot['message'],
          //   ),
          // );
        } else {
          // emit(
          //   AuthErrorState(
          //     userId: userId,
          //     errorMessage: 'Profile not matching for this credential',
          //   ),
          // );
          emit(
            currentState.copyWith(
              isLoadingVerifyOTP: false,
              sheetErrorMessage: 'Profile not matching for this credential',
            ),
          );
        }
      } else {
        // emit(
        //   AuthErrorState(
        //     userId: userId,
        //     errorMessage: snapshot['message'] ?? '',
        //   ),
        // );
        emit(
          currentState.copyWith(
            isLoadingVerifyOTP: false,
            sheetErrorMessage: snapshot['message'] ?? '',
          ),
        );
        Future.delayed(Duration(seconds: 2)).then((value) {
          emit(
            currentState.copyWith(
              isLoadingVerifyOTP: false,
              sheetErrorMessage: null,
            ),
          );
        });
      }
    } else {
      emit(
        currentState.copyWith(
          isLoadingVerifyOTP: false,
          sheetErrorMessage: "No Internet Connection!",
        ),
      );
      Future.delayed(Duration(seconds: 2)).then((value) {
        emit(
          currentState.copyWith(
            isLoadingVerifyOTP: false,
            sheetErrorMessage: null,
          ),
        );
      });
    }
  }

  Future<void> evaluatorRensendOTP(int userId) async {
    final currentSTate = state as AuthCubitSendOTPState;
    final response = await EvResendOtpRepo.resendOTP(userId);
    if (response.isNotEmpty) {
      if (response['error'] == false) {
        _startTimer();
      } else {
        emit(
          currentSTate.copyWith(
            isEnabledResendOTPButton: true,
            sheetErrorMessage: response['message'],
            isLoadingVerifyOTP: false,
          ),
        );
        // emit(AuthErrorState(userId: userId, errorMessage: response['message']));
      }
    } else {
      emit(
        currentSTate.copyWith(
          isEnabledResendOTPButton: true,
          sheetErrorMessage: "Error while resending OTP",
          isLoadingVerifyOTP: false,
        ),
      );
      // emit(
      //   AuthErrorState(
      //     userId: userId,
      //     errorMessage: "Error while resending OTP",
      //   ),
      // );
    }
  }

  //.  DEALER OR VENDOR AUTH FYUNCTIONS

  // -- 1 -- Regitser Delaer or Vendor (its might be remove)
  Future<bool> registerVendor(
    BuildContext context,
    String mobileNumber,
    String password,
    String confirmPassword,
    String name,
    String email,
    String city,
  ) async {
    emit(AuthLodingState());
    final snapshot = await VRegisterRepo.registerVendor(
      mobileNumber,
      password,
      name,
      email,
      city,
      confirmPassword,
    );

    if (snapshot['error'] == false && snapshot.isNotEmpty) {
      emit(AppAuthControllerInitialState());
      vSnackBarMessage(
        context,
        "Congratulation!.Registration successful, you can login now.",
      );
      Navigator.of(
        context,
      ).pushReplacement(AppRoutes.createRoute(VLoginScreen()));
      return true;
    } else {
      vSnackBarMessage(context, snapshot['message'], state: VSnackState.ERROR);
      emit(AuthErrorState(errorMessage: snapshot['message']));
      return false;
    }
  }

  // -- 2 -- Send OTP for Dealer Or Vendor
  Future<void> sendOtpForDealer(
    BuildContext context,
    String mobileNumber,
  ) async {
    emit(AuthLodingState());
    final snapshot = await VOtpLoginRepo.sendOtp(mobileNumber);
    if (snapshot.isNotEmpty) {
      if (snapshot['error'] == false) {
        log(snapshot['employeeId'].toString());

        HapticFeedback.mediumImpact();

        showModalBottomSheet(
          isDismissible: false,
          context: context,
          isScrollControlled: true,
          backgroundColor: VColors.WHITE,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
          ),
          builder:
              (context) => OtpSheet(
                mobilNumber: mobileNumber.trim(),
                userId: int.parse(snapshot['employeeId']),
              ),
        );
        emit(
          AuthCubitSendOTPState(
            isLoadingVerifyOTP: false,
            sheetErrorMessage: null,
            runTime: null,
            isEnabledResendOTPButton: true,
            userId: int.parse(snapshot['employeeId']),
          ),
        );
      } else {
        vSnackBarMessage(
          context,
          snapshot['message'],
          state: VSnackState.ERROR,
        );
        emit(AuthErrorState(errorMessage: snapshot['message'] ?? ''));
      }
    } else {
      vSnackBarMessage(
        context,
        "No Internet Connection!",
        state: VSnackState.ERROR,
      );
      emit(AuthErrorState(errorMessage: "No Internet Connection!"));
    }
  }
  // -- 3 -- Verify OTP for Dealer Or Vendor

  Future<void> vendorVerifyOtp(
    BuildContext context,
    String mobileNumber,
    String otp,
    int userId, {
    String? name,
  }) async {
    final currentState = state as AuthCubitSendOTPState;
    emit(currentState.copyWith(isLoadingVerifyOTP: true));
    final snapshot = await VVerifyOtpRepo.verifyOtp(userId, otp);
    if (snapshot.isNotEmpty) {
      if (snapshot['error'] == false) {
        final currentUserData = await getUserData;
        final authmodel = AuthUserModel(
          mobileNumber: mobileNumber,

          token: snapshot['token'],
          userName: name ?? "",
          userId: userId.toString(),
          userType: "VENDOR",
          isDealerAcceptedTermsAndCondition:
              currentUserData.isDealerAcceptedTermsAndCondition,
        );
        await _setLoginPreference(authmodel);
        emit(
          AuthCubitAuthenticateState(
            userModel: authmodel,
            userId: userId,

            loginMesaage: snapshot['message'],
          ),
        );
        //   return true;
      } else {
        emit(
          currentState.copyWith(
            isLoadingVerifyOTP: false,
            sheetErrorMessage: snapshot['message'] ?? '',
          ),
        );
        // emit(
        //   AuthErrorState(
        //     userId: userId,
        //     errorMessage: snapshot['message'] ?? '',
        //   ),
        // );
        Future.delayed(Duration(seconds: 2)).then((value) {
          emit(
            currentState.copyWith(
              isLoadingVerifyOTP: false,
              sheetErrorMessage: null,
            ),
          );
        });
      }
    } else {
      emit(
        currentState.copyWith(
          isLoadingVerifyOTP: false,
          sheetErrorMessage: "No Internet Connection!",
        ),
      );

      Future.delayed(Duration(seconds: 2)).then((value) {
        emit(
          currentState.copyWith(
            isLoadingVerifyOTP: false,
            sheetErrorMessage: null,
          ),
        );
      });
    }
  }

  Future<void> dealerRensendOTP(int userId) async {
    final currentSTate = state as AuthCubitSendOTPState;
    final response = await VResendOtpRepo.resendOTP(userId);

    if (response.isNotEmpty) {
      if (response['error'] == false) {
        _startTimer();
      } else {
        emit(
          currentSTate.copyWith(
            isEnabledResendOTPButton: true,
            sheetErrorMessage: response['message'],
            isLoadingVerifyOTP: false,
          ),
        );
        // emit(AuthErrorState(userId: userId, errorMessage: response['message']));
      }
    } else {
      emit(
        currentSTate.copyWith(
          isEnabledResendOTPButton: true,
          sheetErrorMessage: "Error while resending OTP",
          isLoadingVerifyOTP: false,
        ),
      );
      // emit(
      //   AuthErrorState(
      //     userId: userId,
      //     errorMessage: "Error while resending OTP",
      //   ),
      // );
    }
  }

  //.  --- RESEND OTP LOGIN

  Timer? timer;

  void _startTimer() {
    try {
      log("------ in tirmer");
      if (state is! AuthCubitSendOTPState) return;
      log("------ in tirmer");
      timer?.cancel();
      int time = 60;
      final userId = state.userId;

      emit(
        (state as AuthCubitSendOTPState).copyWith(
          isEnabledResendOTPButton: false,

          runTime: time,
        ),
      );

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        time--;
        if (time <= 0) {
          if (state is AuthCubitSendOTPState) {
            emit(
              (state as AuthCubitSendOTPState).copyWith(
                isEnabledResendOTPButton: true,
                runTime: 0,
              ),
            );
          } else {
            // emit(
            //   AuthCubitSendOTPState(
            //     isEnabledResendOTPButton: true,
            //     runTime: 0,
            //     userId: userId,
            //   ),
            // );
          }

          t.cancel();
          return;
        }
        final newState = state;
        if (newState is AuthCubitSendOTPState) {
          emit(
            newState.copyWith(isEnabledResendOTPButton: false, runTime: time),
          );
        }
        // else {
        //   log('isssue .....');
        //   log(state.toString());
        // }
      });
    } catch (e) {
      timer?.cancel();
      emit(AuthCubitUnAuthenticatedState());
      //d
    }
  }

  void dispose() {
    timer?.cancel();
  }
}
