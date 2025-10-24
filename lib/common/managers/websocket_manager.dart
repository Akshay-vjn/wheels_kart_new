import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  final Map<String, WebSocketConnection> _connections = {};
  final Map<String, Timer> _reconnectTimers = {};
  static const int _maxReconnectAttempts = 5;
  static const int _reconnectDelay = 3; // seconds

  /// Register a websocket connection
  void registerConnection({
    required String connectionId,
    required String url,
    required Function(dynamic data) onData,
    required Function(dynamic error) onError,
    required Function() onDone,
    Map<String, dynamic>? headers,
  }) {
    log("🔌 Registering websocket connection: $connectionId");
    
    _connections[connectionId] = WebSocketConnection(
      id: connectionId,
      url: url,
      onData: onData,
      onError: onError,
      onDone: onDone,
      headers: headers,
      reconnectAttempts: 0,
    );
  }

  /// Connect a specific websocket
  Future<void> connect(String connectionId) async {
    final connection = _connections[connectionId];
    if (connection == null) {
      log("❌ Connection $connectionId not found");
      return;
    }

    if (connection.isConnected) {
      log("✅ Connection $connectionId already connected");
      return;
    }

    try {
      log("🔌 Connecting websocket: $connectionId");
      
      connection.channel = WebSocketChannel.connect(
        Uri.parse(connection.url),
      );

      connection.subscription = connection.channel!.stream.listen(
        (data) {
          try {
            final decoded = (data is String) ? data : utf8.decode(data);
            final jsonData = jsonDecode(decoded);
            
            // Handle ping-pong responses
            if (jsonData['type'] == 'pong') {
              connection.handlePongResponse();
              return;
            }
            
            connection.onData(jsonData);
            connection.reconnectAttempts = 0; // Reset on successful message
          } catch (e) {
            log("Error decoding WebSocket data for $connectionId: $e");
          }
        },
        onError: (error) {
          log("WebSocket error for $connectionId: $error");
          connection.onError(error);
          _scheduleReconnect(connectionId);
        },
        onDone: () {
          log("WebSocket closed for $connectionId. Scheduling reconnect...");
          connection.onDone();
          _scheduleReconnect(connectionId);
        },
        cancelOnError: true,
      );

      connection.isConnected = true;
      connection.reconnectAttempts = 0;
      
      // Start ping-pong mechanism
      connection.startPingPong();
      
      log("✅ Websocket $connectionId connected successfully");
    } catch (e) {
      log("Failed to connect websocket $connectionId: $e");
      connection.onError(e);
      _scheduleReconnect(connectionId);
    }
  }

  /// Disconnect a specific websocket
  void disconnect(String connectionId) {
    final connection = _connections[connectionId];
    if (connection == null) return;

    log("🔌 Disconnecting websocket: $connectionId");
    
    _reconnectTimers[connectionId]?.cancel();
    _reconnectTimers.remove(connectionId);
    
    connection.subscription?.cancel();
    connection.channel?.sink.close();
    connection.heartbeatTimer?.cancel();
    connection.pongTimeoutTimer?.cancel();
    
    connection.isConnected = false;
    connection.subscription = null;
    connection.channel = null;
  }

  /// Reconnect all connections
  Future<void> reconnectAllConnections() async {
    log("🔄 Reconnecting all websocket connections...");
    
    final connectionIds = _connections.keys.toList();
    for (final connectionId in connectionIds) {
      await connect(connectionId);
      // Small delay between connections to avoid overwhelming the server
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Schedule reconnection for a specific connection
  void _scheduleReconnect(String connectionId) {
    final connection = _connections[connectionId];
    if (connection == null) return;

    if (connection.reconnectAttempts >= _maxReconnectAttempts) {
      log("❌ Max reconnection attempts reached for $connectionId");
      return;
    }

    connection.reconnectAttempts++;
    final delay = Duration(seconds: _reconnectDelay * connection.reconnectAttempts);
    
    log("🔄 Scheduling reconnect for $connectionId in ${delay.inSeconds}s (attempt ${connection.reconnectAttempts}/$_maxReconnectAttempts)");
    
    _reconnectTimers[connectionId]?.cancel();
    _reconnectTimers[connectionId] = Timer(delay, () {
      connect(connectionId);
    });
  }

  /// Get connection status
  bool isConnected(String connectionId) {
    return _connections[connectionId]?.isConnected ?? false;
  }

  /// Get all connection statuses
  Map<String, bool> getAllConnectionStatuses() {
    final statuses = <String, bool>{};
    for (final entry in _connections.entries) {
      statuses[entry.key] = entry.value.isConnected;
    }
    return statuses;
  }

  /// Dispose all connections
  void dispose() {
    log("🔄 Disposing all websocket connections...");
    
    for (final connectionId in _connections.keys.toList()) {
      disconnect(connectionId);
    }
    
    _connections.clear();
    _reconnectTimers.clear();
  }
}

class WebSocketConnection {
  final String id;
  final String url;
  final Function(dynamic data) onData;
  final Function(dynamic error) onError;
  final Function() onDone;
  final Map<String, dynamic>? headers;
  int reconnectAttempts;
  
  WebSocketChannel? channel;
  StreamSubscription? subscription;
  bool isConnected = false;
  
  // Ping-pong mechanism
  Timer? heartbeatTimer;
  Timer? pongTimeoutTimer;
  bool isPongReceived = true;
  DateTime? lastPingTime;
  static const int pingInterval = 30; // seconds
  static const int pongTimeout = 10; // seconds

  WebSocketConnection({
    required this.id,
    required this.url,
    required this.onData,
    required this.onError,
    required this.onDone,
    this.headers,
    this.reconnectAttempts = 0,
  });

  void startPingPong() {
    heartbeatTimer?.cancel();
    pongTimeoutTimer?.cancel();
    isPongReceived = true;
    
    heartbeatTimer = Timer.periodic(Duration(seconds: pingInterval), (_) {
      if (!isConnected) {
        heartbeatTimer?.cancel();
        pongTimeoutTimer?.cancel();
        return;
      }
      
      sendPing();
    });
  }

  void sendPing() {
    try {
      final pingMessage = jsonEncode({
        'type': 'ping',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      channel?.sink.add(pingMessage);
      lastPingTime = DateTime.now();
      isPongReceived = false;
      
      // Set timeout for pong response
      pongTimeoutTimer?.cancel();
      pongTimeoutTimer = Timer(Duration(seconds: pongTimeout), () {
        if (!isPongReceived) {
          log("⚠️ Pong timeout for $id, reconnecting...");
          onError("Pong timeout");
        }
      });
    } catch (e) {
      log("Error sending ping for $id: $e");
    }
  }

  void handlePongResponse() {
    isPongReceived = true;
    pongTimeoutTimer?.cancel();
    log("🏓 Pong received for $id");
  }
}
