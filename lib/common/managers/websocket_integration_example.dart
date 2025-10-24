// This file shows how to integrate the websocket auto-reconnection
// with existing BLoCs. Here's an example for VDetailsControllerBloc:

/*
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/managers/websocket_integration_helper.dart';
import 'package:wheels_kart/common/managers/websocket_bloc_mixin.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';

class VDetailsControllerBloc extends Bloc<VDetailsControllerEvent, VDetailsControllerState> 
    with WebSocketAutoReconnectMixin {
  
  VDetailsControllerBloc() : super(VDetailsControllerInitialState()) {
    on<OnFetchDetails>((event, emit) async {
      // Your existing fetch logic here
    });

    on<ConnectWebSocket>((event, emit) async {
      await _connectWebSocket(event, emit);
    });

    on<UpdatePrice>((event, emit) async {
      // Your existing update price logic here
    });
  }

  Future<void> _connectWebSocket(ConnectWebSocket event, Emitter<VDetailsControllerState> emit) async {
    try {
      final connectionId = WebSocketConnectionId.vDetailsController(event.inspectionId ?? 'default');
      
      // Initialize websocket with auto-reconnection
      initializeWebSocket(
        connectionId: connectionId,
        onData: (data) {
          // Handle incoming data
          try {
            final jsonData = data as Map<String, dynamic>;
            
            // Handle ping-pong responses
            if (jsonData['type'] == 'pong') {
              return; // Don't process as bid update
            }

            add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
          } catch (e) {
            log("Error processing websocket data: $e");
          }
        },
        onError: (error) {
          log("WebSocket error: $error");
          // The auto-reconnection will handle this
        },
        onDone: () {
          log("WebSocket closed. Auto-reconnection will handle this.");
        },
      );

      emit(VDetailsControllerWebSocketConnectedState());
    } catch (e) {
      log("Failed to connect websocket: $e");
      emit(VDetailsControllerWebSocketErrorState());
    }
  }

  @override
  Future<void> close() {
    disposeWebSocket();
    return super.close();
  }
}

// Usage in your UI:
class VDetailsScreen extends StatefulWidget {
  @override
  _VDetailsScreenState createState() => _VDetailsScreenState();
}

class _VDetailsScreenState extends State<VDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Connect websocket when screen loads
    context.read<VDetailsControllerBloc>().add(ConnectWebSocket(inspectionId: 'your_inspection_id'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
      builder: (context, state) {
        if (state is VDetailsControllerWebSocketConnectedState) {
          return Text('WebSocket Connected - Auto-reconnection enabled!');
        } else if (state is VDetailsControllerWebSocketErrorState) {
          return Text('WebSocket Error - Will auto-reconnect when app resumes');
        }
        return Text('Connecting...');
      },
    );
  }
}
*/

// Key Benefits:
// 1. Automatic reconnection when app resumes from background
// 2. Centralized websocket management
// 3. Ping-pong mechanism for connection health
// 4. Easy integration with existing BLoCs
// 5. No need to modify existing business logic
// 6. Handles multiple websocket connections simultaneously
