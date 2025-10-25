import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/managers/websocket_integration_helper.dart';

/// Mixin to add websocket auto-reconnection capabilities to existing BLoCs
mixin WebSocketAutoReconnectMixin<T extends BlocBase<S>, S> {
  final WebSocketIntegrationHelper _wsHelper = WebSocketIntegrationHelper();
  String? _connectionId;
  bool _isConnected = false;

  /// Initialize websocket connection with auto-reconnection
  void initializeWebSocket({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _connectionId = connectionId;
    
    _wsHelper.registerVDetailsController(
      connectionId: connectionId,
      onData: (data) {
        _isConnected = true;
        onData(data);
      },
      onError: (error) {
        _isConnected = false;
        onError(error);
      },
      onDone: () {
        _isConnected = false;
        onDone();
      },
    );
  }

  /// Check if websocket is connected
  bool get isWebSocketConnected => _isConnected;

  /// Get connection ID
  String? get connectionId => _connectionId;

  /// Disconnect websocket
  void disconnectWebSocket() {
    if (_connectionId != null) {
      _wsHelper.disconnect(_connectionId!);
      _isConnected = false;
    }
  }

  /// Reconnect websocket manually
  Future<void> reconnectWebSocket() async {
    if (_connectionId != null) {
      await _wsHelper.reconnectAll();
    }
  }

  /// Dispose websocket connection
  void disposeWebSocket() {
    disconnectWebSocket();
  }
}

