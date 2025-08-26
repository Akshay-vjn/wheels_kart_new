import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
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
          // log("New Price");
          // log(event.newBid.bidClosingTime.toString());
          if (car.evaluationId == event.newBid.evaluationId) {
            final bid = event.newBid;
            final myBids =
                bid.vendorBids
                    .where((element) => element.vendorId == event.myId)
                    .toList();

            final reversed = myBids.reversed.toList();
            car.bidStatus = bid.bidStatus;
            car.soldName = bid.soldName;
            car.soldTo = bid.soldTo;
            car.bidAmount = bid.currentBid;
            car.bidClosingTime = bid.bidClosingTime;
            car.yourBids =
                reversed
                    .map(
                      (e) => YourBid(
                        amount: int.parse(e.currentBid),
                        time: e.createdAt,
                        status: '',
                      ),
                    )
                    .toList();
            // car.toJson().toString();

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

  // void _connectWebSocket(
  //   ConnectWebSocket event,
  //   Emitter<VMyAuctionControllerState> emit,
  // ) {
  //   channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

  //   _subscription = channel.stream.listen((data) {
  //     log("triggered ----------------");
  //     String decoded = utf8.decode(data);
  //     final jsonData = jsonDecode(decoded);
  //     log("Converted ----------------");

  //     add(
  //       UpdatePrice(newBid: LiveBidModel.fromJson(jsonData), myId: event.myId),
  //     );
  //   });
  // }
  Timer? _heartbeatTimer;

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VMyAuctionControllerState> emit,
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
              myId: event.myId,
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
      add(ConnectWebSocket(myId: event.myId));
    });
  }

  @override
  Future<void> close() {
    log(
      "------------Closing Bloc and WebSocket.  ------------ My Auction Bloc",
    );

    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
