import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/data/model/v_profile_model.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/data/repo/v_edit_profile_repo.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/data/repo/v_profile_repo.dart';
import 'package:wheels_kart/module/vendor/core/utils/v_messages.dart';

part 'v_profile_controller_state.dart';

class VProfileControllerCubit extends Cubit<VProfileControllerState> {
  VProfileControllerCubit() : super(VProfileControllerInitialState());

  Future<void> onFetchProfile(BuildContext context) async {
    emit(VProfileControllerLoadingState());
    final response = await VProfileRepo.onFetchProfile(context);
    if (response.isNotEmpty) {
      if (response['error'] == false) {
        final data = response['data'] as Map;
        emit(
          VProfileControllerSuccessState(
            profileModel: VProfileModel.fromJson(data as Map<String, dynamic>),
          ),
        );
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
}
