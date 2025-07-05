import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';

part 'v_dashboard_controlller_event.dart';
part 'v_dashboard_controlller_state.dart';

class VDashboardControlllerBloc
    extends Bloc<VDashboardControlllerEvent, VDashboardControlllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VDashboardControlllerBloc() : super(VDashboardControlllerInitialState()) {
    on<OnFetchVendorDashboardApi>((event, emit) async {
      emit(VDashboardControlllerLoadingState());
      final response = await VDashboardRepo.getDashboardDataF(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final list = data.map((e) => VCarModel.fromJson(e)).toList();
          emit(VDashboardControllerSuccessState(listOfCars: list));
        } else {
          emit(
            VDashboardControllerErrorState(errorMesage: response['message']),
          );
        }
      }
    });
    // WEB SOCKET

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];
      log("Started ----------------");
      if (cuuremtSate is VDashboardControllerSuccessState) {
        for (var car in cuuremtSate.listOfCars) {
          if (car.evaluationId == event.newBid.evaluationId) {
            final bid = event.newBid;
            car.bidStatus = bid.bidStatus;
            car.soldName = bid.soldName;
            car.soldTo = bid.soldTo;
            car.currentBid = bid.currentBid;
            car.bidClosingTime = bid.bidClosingTime;
            updatedList.add(car);
          } else {
            updatedList.add(car);
          }
        }
        emit(VDashboardControllerSuccessState(listOfCars: updatedList));
      }
      log("Stopped ----------------");
    });
  }

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VDashboardControlllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse('ws://82.112.238.223:8080'));

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
