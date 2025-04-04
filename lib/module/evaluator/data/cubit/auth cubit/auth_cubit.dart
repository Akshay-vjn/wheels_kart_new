import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/model/auth_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/login/fetch_profile_repo.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/login/login_repo.dart';
import 'package:wheels_kart/module/spash_screen.dart';

part 'auth_state.dart';

class EvAuthBlocCubit extends Cubit<EvAuthBlocState> {
  EvAuthBlocCubit() : super(AuthCubitInitialState());

  Future<void> _setLoginPreference(AuthUserModel userData) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppString.mobileNumberKey, userData.mobileNumber);
    preferences.setString(AppString.passwordKey, userData.password);
    preferences.setString(AppString.tokenKey, userData.token);

    preferences.setString(AppString.userId, userData.userId);
    preferences.setString(AppString.userName, userData.userName);
    preferences.setString(AppString.userType, userData.userType);
  }

  Future<void> checkForLogin(BuildContext context) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String? number = preferences.getString(AppString.mobileNumberKey);

    String? password = preferences.getString(AppString.passwordKey);

    String? token = preferences.getString(AppString.tokenKey);

    String? userId = preferences.getString(AppString.userId);

    String? name = preferences.getString(AppString.userName);

    String? userType = preferences.getString(AppString.userType);

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
      emit(AuthErrorState(errorMessage: 'Invalid User Credential !'));
      return false;
    }
  }

  // LOG OUT USER
  Future<void> clearPreferenceData(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppString.mobileNumberKey);
    await prefs.remove(AppString.passwordKey);
    await prefs.remove(AppString.tokenKey);
    // profile data
    await prefs.remove(AppString.userName);
    await prefs.remove(AppString.userId);
    await prefs.remove(AppString.userType);

    emit(AuthCubitUnAuthenticatedState());
    Navigator.of(context).pushAndRemoveUntil(
      AppRoutes.createRoute(const SplashScreen()),
      (context) => false,
    );
  }
}
