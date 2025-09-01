import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/utils/v_messages.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_profile_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_delete_vendor_account.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_edit_profile_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_profile_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/auth_model.dart';
import 'package:wheels_kart/module/spash_screen.dart';

part 'v_profile_controller_state.dart';

class VProfileControllerCubit extends Cubit<VProfileControllerState> {
  VProfileControllerCubit() : super(VProfileControllerInitialState());

  Future<void> onFetchProfile(BuildContext context) async {
    emit(VProfileControllerLoadingState());
    final response = await VProfileRepo.onFetchProfile(context);
    if (response.isNotEmpty) {
      if (response['error'] == false) {
        final data = response['data'] as Map;
        final model = VProfileModel.fromJson(data as Map<String, dynamic>);

        if (context.mounted) {
          context.read<AppAuthController>().updateLoginPreference(
            AuthUserModel(
              userId: model.vendorId,
              userName: model.vendorName,
              isDealerAcceptedTermsAndCondition: true,
            ),
          );
          log("Profile Fetched : ${model.vendorName}");
        }
        emit(VProfileControllerSuccessState(profileModel: model));
      } else {
        emit(VProfileControllerErrorState(error: response['message']));
      }
    } else {
      emit(VProfileControllerErrorState(error: "Profile Fetch Failed!"));
    }
  }

  Future<void> onEditProfile(
    BuildContext context,
    String name,
    String email,
    String city,
  ) async {
    final curenstSTate = state;
    if (curenstSTate is VProfileControllerSuccessState) {
      emit(VProfileControllerLoadingState());
      final response = await VEditProfileRepo.onEditProfile(
        context,
        name,
        email,
        city,
      );
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          if (context.mounted) {
            await onFetchProfile(context);
            vSnackBarMessage(context, response['message']);
            Navigator.of(context).pop();
          }
        } else {
          vSnackBarMessage(
            context,
            response['message'],
            state: VSnackState.ERROR,
          );
          emit(
            VProfileControllerSuccessState(
              profileModel: curenstSTate.profileModel,
            ),
          );
        }
      } else {
        vSnackBarMessage(
          context,
          "Update Profile Failed!",
          state: VSnackState.ERROR,
        );

        emit(
          VProfileControllerSuccessState(
            profileModel: curenstSTate.profileModel,
          ),
        );
      }
    }
  }

  Future<void> onDeleteAccount(BuildContext context) async {
    emit(VProfileControllerLoadingState());
    final response = await VDeleteVendorAccount.deleteAccount(context);
    if (response.isNotEmpty && response['error'] == false) {
      context.read<AppAuthController>().clearPreferenceData(context);

      Navigator.of(context).pushAndRemoveUntil(
        AppRoutes.createRoute(SplashScreen()),
        (route) => false,
      );
      log(response['message']);
    } else {
      log(response['message']);
    }
    emit(VProfileControllerInitialState());
  }
}
