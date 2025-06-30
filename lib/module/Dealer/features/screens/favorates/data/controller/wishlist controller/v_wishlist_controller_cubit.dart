import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/widget_build_check_box.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/repo/v_add_remove_fav_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/repo/v_whishlist_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';

part 'v_wishlist_controller_state.dart';

class VWishlistControllerCubit extends Cubit<VWishlistControllerState> {
  VWishlistControllerCubit() : super(VWishlistControllerInitialState());

  Future<void> onChangeFavState(
    BuildContext context,
    String inspectionId, {
    bool fetch = false,
  }) async {
    final response = await VAddRemoveFavRepo.addRemoveFromWishList(
      context,
      inspectionId,
    );
    if (response.isNotEmpty) {
      if (fetch == true) {
        if (response['error'] == false) {
          await onFetchWishList(context);
        }
      }
    }
  }

  Future<void> onFetchWishList(BuildContext context) async {
    emit(VWishlistControllerLoadingState());
    final response = await VWhishlistRepo.onFetchWishList(context);
    if (response.isNotEmpty) {
      if (response['error'] == false) {
        final list = response['data'] as List;
        emit(
          VWishlistControllerSuccessState(
            myWishList: list.map((e) => VCarModel.fromJson(e)).toList(),
          ),
        );
      } else {
        emit(VWishlistControllerErrorState(error: response['message']));
      }
    } else {
      emit(VWishlistControllerErrorState(error: response['message']));
    }
  }
}
