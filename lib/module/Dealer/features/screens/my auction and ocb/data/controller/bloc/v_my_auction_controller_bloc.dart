import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/repo/v_get_my_auctions_epo.dart';

part 'v_my_auction_controller_event.dart';
part 'v_my_auction_controller_state.dart';

class VMyAuctionControllerBloc
    extends Bloc<VMyAuctionControllerEvent, VMyAuctionControllerState> {
  VMyAuctionControllerBloc() : super(VMyAuctionControllerInitial()) {
    on<OnGetMyAuctions>(_onGetMyAuction);
  }

  Future<void> _onGetMyAuction(
    OnGetMyAuctions event,
    Emitter<VMyAuctionControllerState> emit,
  ) async {
    emit(VMyAuctionControllerLoadingState());
    final response = await VGetMyAuctionsEpo.onGetMyAuction(event.context);
    if (response['error'] == true) {
      emit(VMyAuctionControllerErrorState(response['message']));
    } else {
      final data = response['data'] as List;
      emit(
        VMyAuctionControllerSuccessState(
          listOfMyAuctions:
              data.map((e) => VMyAuctionModel.fromJson(e)).toList(),
        ),
      );
    }
  }
}
