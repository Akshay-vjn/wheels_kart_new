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
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/repo/v_get_my_owned_repo.dart';

part 'v_my_auction_controller_event.dart';
part 'v_my_auction_controller_state.dart';

class VMyAuctionControllerBloc
    extends Bloc<VMyAuctionControllerEvent, VMyAuctionControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  
  // Store data for different tabs
  List<VMyAuctionModel>? _myAuctions;
  List<VMyAuctionModel>? _ownedAuctions;
  
  VMyAuctionControllerBloc() : super(VMyAuctionControllerInitial()) {
    on<OnGetMyAuctions>(_onGetMyAuction);
    on<OnGetMyOwnedAuctions>(_onGetMyOwnedAuctions);
    on<GetStoredMyAuctions>(_onGetStoredMyAuctions);

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
      _myAuctions = data.map((e) => VMyAuctionModel.fromJson(e)).toList();

      emit(
        VMyAuctionControllerSuccessState(
          listOfMyAuctions: _myAuctions!,
        ),
      );
    }
  }

  Future<void> _onGetMyOwnedAuctions(
    OnGetMyOwnedAuctions event,
    Emitter<VMyAuctionControllerState> emit,
  ) async {
    log("🔄 Starting to fetch owned auctions...");
    emit(VMyAuctionControllerOwnedLoadingState());
    
    try {
      final response = await VGetMyOwnedRepo.onGetMyOwned(event.context);
      log("📊 Owned auctions API response: $response");
      
      if (response['error'] == true) {
        log("❌ Error in owned auctions API: ${response['message']}");
        emit(VMyAuctionControllerErrorState(response['message']));
      } else {
        final data = response['data'] as List;
        log("✅ Owned auctions data received: ${data.length} items");

        _ownedAuctions = data.map((e) => VMyAuctionModel.fromJson(e)).toList();
        log("📋 Created owned auctions list with ${_ownedAuctions!.length} items");
        
        emit(
          VMyAuctionControllerOwnedSuccessState(
            listOfOwnedAuctions: _ownedAuctions!,
          ),
        );
        log("✅ Owned auctions state emitted successfully");
      }
    } catch (e) {
      log("❌ Exception in owned auctions: $e");
      emit(VMyAuctionControllerErrorState("Failed to fetch owned auctions: $e"));
    }
  }

  Future<void> _onGetStoredMyAuctions(
    GetStoredMyAuctions event,
    Emitter<VMyAuctionControllerState> emit,
  ) async {
    if (_myAuctions != null) {
      emit(VMyAuctionControllerSuccessState(listOfMyAuctions: _myAuctions!));
    } else {
      emit(VMyAuctionControllerInitial());
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
  Timer? _pongTimeoutTimer;
  bool _isPongReceived = true;
  DateTime? _lastPingTime;
  static const int _pingInterval = 30; // seconds
  static const int _pongTimeout = 10; // seconds

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VMyAuctionControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    // Start ping-pong mechanism
    _startPingPong();

    _subscription = channel.stream.listen(
      (data) {
        log("triggered ----------------");

        try {
          final decoded = (data is String) ? data : utf8.decode(data);
          final jsonData = jsonDecode(decoded);
          log("Converted ----------------");

          // Handle ping-pong responses
          if (jsonData['type'] == 'pong') {
            _handlePongResponse();
            return; // Don't process as bid update
          }

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

  void _startPingPong() {
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _isPongReceived = true;
    
    _heartbeatTimer = Timer.periodic(Duration(seconds: _pingInterval), (_) {
      if (isClosed) {
        log("⚠️ [WebSocket] Bloc closed, stopping ping-pong");
        _heartbeatTimer?.cancel();
        _pongTimeoutTimer?.cancel();
        return;
      }
      
      _sendPing();
    });
  }

  void _sendPing() {
    try {
      final pingMessage = jsonEncode({
        "type": "ping",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
      
      channel.sink.add(pingMessage);
      _lastPingTime = DateTime.now();
      _isPongReceived = false;
      
      log("💓 [WebSocket] Ping sent: $pingMessage");
      
      // Start pong timeout timer
      _pongTimeoutTimer?.cancel();
      _pongTimeoutTimer = Timer(Duration(seconds: _pongTimeout), () {
        if (!_isPongReceived && !isClosed) {
          log("⏰ [WebSocket] Pong timeout - reconnecting...");
          _reconnect(ConnectWebSocket(myId: ""));
        }
      });
      
    } catch (e) {
      log("❌ [WebSocket] Ping failed: $e");
      if (!isClosed) {
        _reconnect(ConnectWebSocket(myId: ""));
      }
    }
  }

  void _handlePongResponse() {
    _isPongReceived = true;
    _pongTimeoutTimer?.cancel();
    
    final responseTime = DateTime.now().difference(_lastPingTime ?? DateTime.now());
    log("🏓 [WebSocket] Pong received - Response time: ${responseTime.inMilliseconds}ms");
  }

  @override
  Future<void> close() {
    log(
      "------------Closing Bloc and WebSocket.  ------------ My Auction Bloc",
    );

    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
