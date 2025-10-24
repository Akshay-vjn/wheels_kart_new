import 'dart:async';
import 'package:wheels_kart/common/managers/websocket_manager.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';

class WebSocketIntegrationHelper {
  static final WebSocketIntegrationHelper _instance = WebSocketIntegrationHelper._internal();
  factory WebSocketIntegrationHelper() => _instance;
  WebSocketIntegrationHelper._internal();

  final WebSocketManager _wsManager = WebSocketManager();

  /// Register and connect a websocket for VDetailsController
  void registerVDetailsController({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _wsManager.registerConnection(
      connectionId: connectionId,
      url: VApiConst.socket,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );
    
    _wsManager.connect(connectionId);
  }

  /// Register and connect a websocket for VOcbController
  void registerVOcbController({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _wsManager.registerConnection(
      connectionId: connectionId,
      url: VApiConst.socket,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );
    
    _wsManager.connect(connectionId);
  }

  /// Register and connect a websocket for VAuctionController
  void registerVAuctionController({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _wsManager.registerConnection(
      connectionId: connectionId,
      url: VApiConst.socket,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );
    
    _wsManager.connect(connectionId);
  }

  /// Register and connect a websocket for VMyAuctionController
  void registerVMyAuctionController({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _wsManager.registerConnection(
      connectionId: connectionId,
      url: VApiConst.socket,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );
    
    _wsManager.connect(connectionId);
  }

  /// Register and connect a websocket for VWishlistController
  void registerVWishlistController({
    required String connectionId,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
  }) {
    _wsManager.registerConnection(
      connectionId: connectionId,
      url: VApiConst.socket,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );
    
    _wsManager.connect(connectionId);
  }

  /// Disconnect a specific websocket
  void disconnect(String connectionId) {
    _wsManager.disconnect(connectionId);
  }

  /// Check if a connection is active
  bool isConnected(String connectionId) {
    return _wsManager.isConnected(connectionId);
  }

  /// Get all connection statuses
  Map<String, bool> getAllConnectionStatuses() {
    return _wsManager.getAllConnectionStatuses();
  }

  /// Reconnect all connections
  Future<void> reconnectAll() async {
    await _wsManager.reconnectAllConnections();
  }

  /// Dispose all connections
  void dispose() {
    _wsManager.dispose();
  }
}

/// Helper class to create unique connection IDs
class WebSocketConnectionId {
  static String vDetailsController(String inspectionId) => 'v_details_$inspectionId';
  static String vOcbController(String inspectionId) => 'v_ocb_$inspectionId';
  static String vAuctionController(String inspectionId) => 'v_auction_$inspectionId';
  static String vMyAuctionController(String myId) => 'v_my_auction_$myId';
  static String vWishlistController() => 'v_wishlist';
}
