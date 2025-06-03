import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/auth_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/fetch_profile_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/login/login_repo.dart';
import 'package:wheels_kart/module/spash_screen.dart';

part 'auth_state.dart';

class EvAuthBlocCubit extends Cubit<EvAuthBlocState> {
  EvAuthBlocCubit() : super(AuthCubitInitialState());

  static const String mobileNumberKey = 'MOBILE_NUMBER';
  static const String passwordKey = 'PASSWORD_KEY';
  static const String tokenKey = 'TOKEN_KEY';
  static const String userIdKey = "USER_ID";
  static const String userNameKey = "USER_NAME";
  static const String userTypeKey = "USER_TYPE";

  Future<void> _setLoginPreference(AuthUserModel userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(mobileNumberKey, userData.mobileNumber);
    preferences.setString(passwordKey, userData.password);
    preferences.setString(tokenKey, userData.token);

    preferences.setString(userIdKey, userData.userId);
    preferences.setString(userNameKey, userData.userName);
    preferences.setString(userTypeKey, userData.userType);
  }

  Future<void> checkForLogin(BuildContext context) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String? number = preferences.getString(mobileNumberKey);

    String? password = preferences.getString(passwordKey);

    String? token = preferences.getString(tokenKey);

    String? userId = preferences.getString(userIdKey);

    String? name = preferences.getString(userNameKey);

    String? userType = preferences.getString(userTypeKey);

    log(
      'Name - > ${name}\nNumber - > $number\nType -> $userType\nUser ID - > $userId',
    );

    if (token != null && password != null && number != null) {
      await loginUser(context, number, password);
    } else {
      emit(AuthCubitUnAuthenticatedState());
    }
  }

  // LOGIN USER
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
  }

  // LOG OUT USER
  Future<void> clearPreferenceData(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(mobileNumberKey);
    await prefs.remove(passwordKey);
    await prefs.remove(tokenKey);
    // profile data
    await prefs.remove(userNameKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userTypeKey);

    emit(AuthCubitUnAuthenticatedState());

    Navigator.of(context).pushAndRemoveUntil(
      AppRoutes.createRoute(const SplashScreen()),
      (context) => false,
    );
  }
}
