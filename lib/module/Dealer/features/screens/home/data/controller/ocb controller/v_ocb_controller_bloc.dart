import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_ocb_list_repo.dart';

part 'v_ocb_controller_event.dart';
part 'v_ocb_controller_state.dart';

class VOcbControllerBloc
    extends Bloc<VOcbControllerEvent, VOcbControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VOcbControllerBloc() : super(VOcbControlllerInitialState()) {
    on<OnFechOncList>((event, emit) async {
      emit(VOcbControlllerLoadingState());
      final response = await VFetchOcbListRepo.getOcbList(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final list = data.map((e) => VCarModel.fromJson(e)).toList();
          emit(VOcbControllerSuccessState(listOfCars: list));
        } else {
          emit(VOcbControllerErrorState(errorMesage: response['message']));
        }
      }
    });

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];
      log("Started ----------------");
      if (cuuremtSate is VOcbControllerSuccessState) {
        for (var car in cuuremtSate.listOfCars) {
          if (car.evaluationId == event.newBid.evaluationId) {
            final bid = event.newBid;

            car.bidStatus = bid.bidStatus;
            car.soldName = bid.soldName;
            car.soldTo = bid.soldTo;
            car.currentBid = bid.currentBid;
            car.bidClosingTime = bid.bidClosingTime;
            car.vendorIds = bid.vendorIds;
            updatedList.add(car);
          } else {
            updatedList.add(car);
          }
        }
        emit(VOcbControllerSuccessState(listOfCars: updatedList));
      }
      log("Stopped ----------------");
    });
  }

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VOcbControllerState> emit,
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
