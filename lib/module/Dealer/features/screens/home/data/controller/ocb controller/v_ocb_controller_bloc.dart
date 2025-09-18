import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

          emit(
            VOcbControllerSuccessState(
              listOfCars: list,
              enableRefreshButton: false,
            ),
          );
        } else {
          emit(VOcbControllerErrorState(errorMesage: response['message']));
        }
      }
    });

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) async {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];

      if (cuuremtSate is VOcbControllerSuccessState) {
        if (event.newBid.trigger != null && event.newBid.trigger == "ocb new") {
          log("--------New OCB Listed");

          // emit(
          //   VOcbControllerSuccessState(
          //     listOfCars: cuuremtSate.listOfCars,
          //     enableRefreshButton: true,
          //   ),
          // );

          final response = await VFetchOcbListRepo.getOcbList(event.context);
          if (response.isNotEmpty) {
            if (response['error'] == false) {
              final data = response['data'] as List;
              final list = data.map((e) => VCarModel.fromJson(e)).toList();

              emit(
                VOcbControllerSuccessState(
                  listOfCars: list,
                  enableRefreshButton: false,
                ),
              );
            } else {
              emit(VOcbControllerErrorState(errorMesage: response['message']));
            }
          }
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
            VOcbControllerSuccessState(
              listOfCars: updatedList,
              enableRefreshButton: cuuremtSate.enableRefreshButton,
            ),
          );
          log("Stopped ----------------");
        }
      }
    });
  }

  Timer? _heartbeatTimer;

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VOcbControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    // Send heartbeat every 30 seconds
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) {
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

          add(
            UpdatePrice(
              newBid: LiveBidModel.fromJson(jsonData),
              context: event.context,
            ),
          );
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
    _subscription?.cancel();
    Future.delayed(Duration(seconds: 3), () {
      add(ConnectWebSocket(context: event.context));
    });
  }

  // Future<void> _onBuyOcb(
  //   OnBuyOCB event,
  //   Emitter<VOcbControllerState> emit,
  // ) async {
  //   final currentState = state;
  //   if (currentState is VOcbControllerSuccessState) {
  //     emit(currentState.copyWith(loadingTheOCBButton: true));
  //     // final response = await VBuyOcbAuctionRepo.buyOCB(
  //     //   event.context,
  //     //   event.inspectionId,
  //     // );
  //     await Future.delayed(Duration(seconds: 4));
  //     final response = {"error": true, "message": 'Error'};

  //     emit(currentState.copyWith(loadingTheOCBButton: false));
  //     if (response['error'] == false) {
  //       add(OnFechOncList(context: event.context));
  //       Navigator.of(event.context).pop();
  //       showToastMessage(event.context, response['message'].toString());
  //     } else {
  //       Navigator.of(event.context).pop();
  //       showToastMessage(
  //         event.context,
  //         response['message'].toString(),
  //         isError: true,
  //       );
  //     }
  //   } else {
  //     log("ELse case ");
  //   }
  // }

  @override
  Future<void> close() {
    log("------------Closing Bloc and WebSocket. ------------ OCB Bloc");
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
