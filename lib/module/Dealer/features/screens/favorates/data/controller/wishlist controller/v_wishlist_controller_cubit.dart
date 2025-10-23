import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/widget_build_check_box.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/repo/v_add_remove_fav_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/repo/v_whishlist_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';

part 'v_wishlist_controller_state.dart';

class VWishlistControllerCubit extends Cubit<VWishlistControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
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
    try {
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
    } catch (e) {
    }
  }

  // void connectWebSocket() {
  //   channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

  //   _subscription = channel.stream.listen((data) {
  //     log("triggered ----------------");
  //     String decoded = utf8.decode(data);
  //     final jsonData = jsonDecode(decoded);
  //     log("Converted ----------------");

  //     _updatePrice(LiveBidModel.fromJson(jsonData));
  //   });
  // }
  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;
  bool _isPongReceived = true;
  DateTime? _lastPingTime;
  static const int _pingInterval = 30; // seconds
  static const int _pongTimeout = 10; // seconds

  void connectWebSocket() {
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

          _updatePrice(LiveBidModel.fromJson(jsonData));
        } catch (e) {
          log("Error decoding WebSocket data: $e");
        }
      },
      onError: (error) {
        log("WebSocket error: $error");
        _reconnect();
      },
      onDone: () {
        log("WebSocket closed. Reconnecting...");
        _reconnect();
      },
      cancelOnError: true,
    );
  }

  void _reconnect() {
    _subscription?.cancel();
    Future.delayed(Duration(seconds: 3), () {
      connectWebSocket();
    });
  }

  Future<void> _updatePrice(LiveBidModel newBid) async {
    final cuuremtSate = state;
    List<VCarModel> updatedList = [];
    log("Started ----------------");
    if (cuuremtSate is VWishlistControllerSuccessState) {
      for (var car in cuuremtSate.myWishList) {
        if (car.evaluationId == newBid.evaluationId) {
          final bid = newBid;
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
      emit(VWishlistControllerSuccessState(myWishList: updatedList));
    }
    log("Stopped ----------------");
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
          _reconnect();
        }
      });
      
    } catch (e) {
      log("❌ [WebSocket] Ping failed: $e");
      if (!isClosed) {
        _reconnect();
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
    log("------------Closing Bloc and WebSocket. ------------ Wishlist Bloc");
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
