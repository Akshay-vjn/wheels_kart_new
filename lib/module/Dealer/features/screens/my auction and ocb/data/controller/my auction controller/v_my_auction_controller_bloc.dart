import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/repo/v_get_my_auctions_epo.dart';

part 'v_my_auction_controller_event.dart';
part 'v_my_auction_controller_state.dart';

class VMyAuctionControllerBloc
    extends Bloc<VMyAuctionControllerEvent, VMyAuctionControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VMyAuctionControllerBloc() : super(VMyAuctionControllerInitial()) {
    on<OnGetMyAuctions>(_onGetMyAuction);

    // WEB SOCKET

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) {
      final cuuremtSate = state;
      List<VMyAuctionModel> updatedList = [];
      log("--------Auction Updated");
      if (cuuremtSate is VMyAuctionControllerSuccessState) {
        for (var car in cuuremtSate.listOfMyAuctions) {
          if (car.evaluationId == event.newBid.evaluationId) {
            final bid = event.newBid;

            car.bidStatus = bid.bidStatus;
            car.soldName = bid.soldName;
            car.soldTo = bid.soldTo;
            car.bidAmount = bid.currentBid;
            car.bidTime = bid.bidClosingTime;

            updatedList.add(car);
          } else {
            updatedList.add(car);
          }
        }
        emit(VMyAuctionControllerSuccessState(listOfMyAuctions: updatedList));
      }
      log("Updating Done------------");
    });
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

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VMyAuctionControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    _subscription = channel.stream.listen((data) {
      log("triggered ----------------");
      String decoded = utf8.decode(data);
      final jsonData = jsonDecode(decoded);
      log("Converted ----------------");

      add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
