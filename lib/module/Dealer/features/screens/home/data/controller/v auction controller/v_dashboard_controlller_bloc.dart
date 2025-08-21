import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';

part 'v_dashboard_controlller_event.dart';
part 'v_dashboard_controlller_state.dart';

class VAuctionControlllerBloc
    extends Bloc<VAuctionControlllerEvent, VAuctionControlllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VAuctionControlllerBloc() : super(VAuctionControlllerInitialState()) {
    on<OnFetchVendorAuctionApi>((event, emit) async {
      emit(VAuctionControlllerLoadingState());
      final response = await VDashboardRepo.getDashboardDataF(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final list = data.map((e) => VCarModel.fromJson(e)).toList();

          emit(
            VAuctionControllerSuccessState(
              listOfCars: list,
              enableRefreshButton: false,
            ),
          );
        } else {
          emit(VVAuctionControllerErrorState(errorMesage: response['message']));
        }
      }
    });
    // WEB SOCKET

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];

      if (cuuremtSate is VAuctionControllerSuccessState) {
        if (event.newBid.trigger != null && event.newBid.trigger == "new") {
          log("--------New Auction Listed");
          emit(
            VAuctionControllerSuccessState(
              listOfCars: cuuremtSate.listOfCars,
              enableRefreshButton: true,
            ),
          );
        } else {
          log("--------Auction Updated");
          for (var car in cuuremtSate.listOfCars) {
            if (car.evaluationId == event.newBid.evaluationId) {
              final bid = event.newBid;
              final reversed = bid.vendorBids.toList();

              car.bidStatus = bid.bidStatus;
              car.soldName = bid.soldName;
              car.soldTo = bid.soldTo;
              car.currentBid = bid.currentBid;
              car.bidClosingTime = bid.bidClosingTime;
              car.vendorIds = reversed.map((e) => e.vendorId).toList();
              
              updatedList.add(car);
            } else {
              updatedList.add(car);
            }
          }
          emit(
            VAuctionControllerSuccessState(
              listOfCars: updatedList,
              enableRefreshButton: cuuremtSate.enableRefreshButton,
            ),
          );
          log("Updating Done------------");
        }
      }
    });
  }

  // void _connectWebSocket(
  //   ConnectWebSocket event,
  //   Emitter<VAuctionControlllerState> emit,
  // ) {
  //   channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

  //   _subscription = channel.stream.listen((data) {
  //     log("triggered ----------------");
  //     String decoded = utf8.decode(data);
  //     final jsonData = jsonDecode(decoded);
  //     log("Converted ----------------");

  //     add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
  //   });
  // }

  void _connectWebSocket(
  ConnectWebSocket event,
  Emitter<VAuctionControlllerState> emit,
) {
  channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

  // Send heartbeat every 30 seconds
  Timer.periodic(Duration(seconds: 30), (_) {
    try {
      channel.sink.add(jsonEncode({"type": "ping"}));
    } catch (e) {
      log("Ping failed: $e");
    }
  });

  _subscription = channel.stream.listen(
    (data) {
      log("triggered ----------------");

      try {
        final decoded = (data is String) ? data : utf8.decode(data);
        final jsonData = jsonDecode(decoded);
        log("Converted ----------------");

        add(UpdatePrice(
          newBid: LiveBidModel.fromJson(jsonData),
        ));
      } catch (e) {
        log("Error decoding WebSocket data: $e");
      }
    },
    onError: (error) {
      log("WebSocket error: $error");
      _reconnect(event);
    },
    onDone: () {
      log("WebSocket closed. Reconnecting...");
      _reconnect(event);
    },
    cancelOnError: true,
  );
}

void _reconnect(ConnectWebSocket event) {
  Future.delayed(Duration(seconds: 3), () {
    add(ConnectWebSocket());
  });
}

  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
