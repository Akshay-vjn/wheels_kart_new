import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_kart/common/components/delete_account_success_screen.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/auth_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/ev_register_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/fetch_profile_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/login_repo.dart';
import 'package:wheels_kart/module/Dealer/core/utils/v_messages.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_login_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/data/repo/v_register_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/auth/screens/v_login_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/auth/ev_login_screen.dart';
import 'package:wheels_kart/module/spash_screen.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';

part 'auth_state.dart';

class AppAuthController extends Cubit<AppAuthControllerState> {
  AppAuthController() : super(AppAuthControllerInitialState());

  static const String mobileNumberKey = 'MOBILE_NUMBER';
  static const String passwordKey = 'PASSWORD_KEY';
  static const String tokenKey = 'TOKEN_KEY';
  static const String userIdKey = "USER_ID";
  static const String userNameKey = "USER_NAME";
  static const String userTypeKey = "USER_TYPE";
  static const String isDealerAcceptedTermsAndCondition =
      "IS_ACCEPTED_TERMS_AND_CONDITION";

  Future<void> _setLoginPreference(AuthUserModel userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(mobileNumberKey, userData.mobileNumber ?? '');
    preferences.setString(passwordKey, userData.password ?? '');
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
    preferences.setString(
      passwordKey,
      userData.password ?? data.password ?? '',
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

    log(
      "New Updated Data -> \n"
      'Name - > ${newData.userName}\nNumber - > ${newData.mobileNumber}\nType -> ${newData.userType}\nUser ID - > ${newData.userId}. \nTerms Accepted=> ${newData.isDealerAcceptedTermsAndCondition}',
    );
  }

  Future<void> checkForLogin(BuildContext context) async {
    final userData = await getUserData;
    //  context.read<AppAuthController>().clearPreferenceData(context);

    log(
      "cjeck for login -> \n"
      'Name - > ${userData.userName}\nNumber - > ${userData.mobileNumber}\nType -> ${userData.userType}\nUser ID - > ${userData.userId}. \nTerms Accepted=> ${userData.isDealerAcceptedTermsAndCondition}',
    );

    if (userData.token != null &&
        userData.password != null &&
        userData.userName != null) {
      if (userData.userType != null &&
          (userData.userType == "EVALUATOR" || userData.userType == "ADMIN")) {
        await loginUser(context, userData.mobileNumber!, userData.password!);
      } else {
        await loginVendor(
          context,
          userData.mobileNumber!,
          userData.password!,
          id: userData.userId,
          name: userData.userName,
        );
      }
    } else {
      emit(AuthCubitUnAuthenticatedState());
    }
  }

  // GET USER DATA

  Future<AuthUserModel> get getUserData async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String? number = preferences.getString(mobileNumberKey);

    String? password = preferences.getString(passwordKey);

    String? token = preferences.getString(tokenKey);

    String? userId = preferences.getString(userIdKey);

    String? name = preferences.getString(userNameKey);

    String? userType = preferences.getString(userTypeKey);

    bool? isAcceptedTermsAndCondition = preferences.getBool(
      isDealerAcceptedTermsAndCondition,
    );

    return AuthUserModel(
      mobileNumber: number,
      password: password,
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
    await prefs.remove(passwordKey);
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

  // LOGIN EVALUATOR
  Future<bool> loginUser(
    BuildContext context,
    String mobileNumber,
    String password,
  ) async {
    emit(AuthLodingState());
    final snapshot = await LoginRepo.loginUserRepo(mobileNumber, password);

    if (snapshot['error'] == false) {
      final profileSnapshot = await FetchFProfileDataRepos.getProfileData(
        snapshot['token'],
      );
      if (snapshot['error'] == false) {
        log(snapshot['message']);

        final authmodel = AuthUserModel(
          mobileNumber: mobileNumber,
          password: password,
          token: snapshot['token'],
          userName: profileSnapshot['data']['userFullName'],
          userId: profileSnapshot['data']['userId'],
          userType: profileSnapshot['data']['userType'],
        );
        await _setLoginPreference(authmodel);
        emit(
          AuthCubitAuthenticateState(
            userModel: authmodel,
            loginMesaage: snapshot['message'],
          ),
        );
        return true;
      } else if (snapshot['error'] == true) {
        emit(AuthErrorState(errorMessage: profileSnapshot['message']));
        return false;
      } else {
        emit(
          AuthErrorState(
            errorMessage: 'Profile not matching for this credential',
          ),
        );
        return false;
      }
    } else if (snapshot['error'] == true) {
      log(snapshot['message']);
      emit(AuthErrorState(errorMessage: snapshot['message']));
      return false;
    } else {
      log('error');
      emit(AuthErrorState(errorMessage: 'No Internet Connection !'));
      return false;
    }
  } // REGISTER EVALUATOR

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
      vSnackBarMessage(
        context,
        "Congratulation!.Registration successful, you can login now.",
      );
      Navigator.of(
        context,
      ).pushReplacement(AppRoutes.createRoute(EvLoginScreen()));
      return true;
    } else {
      vSnackBarMessage(context, snapshot['message'], state: VSnackState.ERROR);
      emit(AuthErrorState(errorMessage: snapshot['message']));
      return false;
    }
  }

  // LOGIN VENDOR
  Future<bool> loginVendor(
    BuildContext context,
    String mobileNumber,
    String password, {
    String? name,
    String? id,
  }) async {
    emit(AuthLodingState());
    final snapshot = await VLoginRepo.loginVendor(mobileNumber, password);
    if (snapshot.isNotEmpty) {
      if (snapshot['error'] == false) {
        log(snapshot['data'].toString());
        final currentUserData = await getUserData;
        final authmodel = AuthUserModel(
          mobileNumber: mobileNumber,
          password: password,
          token: snapshot['token'],
          userName: name ?? "",
          userId: id ?? "",
          userType: "VENDOR",
          isDealerAcceptedTermsAndCondition:
              currentUserData.isDealerAcceptedTermsAndCondition,
        );
        await _setLoginPreference(authmodel);
        emit(
          AuthCubitAuthenticateState(
            userModel: authmodel,
            loginMesaage: snapshot['message'],
          ),
        );
        return true;
      } else {
        emit(AuthErrorState(errorMessage: snapshot['message'] ?? ''));
        return false;
      }
    } else {
      emit(AuthErrorState(errorMessage: "No Internet Connection!"));
      return false;
    }
  }

  // RESISTER VENDOR
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
}
