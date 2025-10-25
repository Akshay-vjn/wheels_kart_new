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
  final Map<String, bool> _isReconnecting = {};
  final Map<String, DateTime> _lastConnectionTime = {};
  
  static const int _maxReconnectAttempts = 5;
  static const int _reconnectDelay = 1; // Reduced from 3 to 1 second
  static const int _instantReconnectDelay = 100; // 100ms for instant reconnect
  static const int _connectionTimeout = 5; // 5 seconds timeout

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

  /// Reconnect all connections with instant reconnection
  Future<void> reconnectAllConnections() async {
    log("🔄 Reconnecting all websocket connections...");
    
    final connectionIds = _connections.keys.toList();
    final futures = <Future>[];
    
    // Connect all connections in parallel for instant reconnection
    for (final connectionId in connectionIds) {
      futures.add(_instantConnect(connectionId));
    }
    
    // Wait for all connections to complete or timeout
    await Future.wait(futures, eagerError: false);
    
    log("✅ All websocket reconnections completed");
  }

  /// Instant connect with timeout and fallback
  Future<void> _instantConnect(String connectionId) async {
    if (_isReconnecting[connectionId] == true) {
      log("⏳ Connection $connectionId already reconnecting, skipping...");
      return;
    }

    _isReconnecting[connectionId] = true;
    
    try {
      // Try instant connection with timeout
      await connect(connectionId).timeout(
        Duration(seconds: _connectionTimeout),
        onTimeout: () {
          log("⏰ Connection timeout for $connectionId, will retry...");
          _scheduleReconnect(connectionId);
        },
      );
      
      _lastConnectionTime[connectionId] = DateTime.now();
      log("✅ Instant connection successful for $connectionId");
    } catch (e) {
      log("❌ Instant connection failed for $connectionId: $e");
      _scheduleReconnect(connectionId);
    } finally {
      _isReconnecting[connectionId] = false;
    }
  }

  /// Schedule reconnection for a specific connection with smart delays
  void _scheduleReconnect(String connectionId) {
    final connection = _connections[connectionId];
    if (connection == null) return;

    if (connection.reconnectAttempts >= _maxReconnectAttempts) {
      log("❌ Max reconnection attempts reached for $connectionId");
      return;
    }

    connection.reconnectAttempts++;
    
    // Smart delay: instant for first attempt, then exponential backoff
    Duration delay;
    if (connection.reconnectAttempts == 1) {
      delay = Duration(milliseconds: _instantReconnectDelay);
    } else {
      delay = Duration(seconds: _reconnectDelay * connection.reconnectAttempts);
    }
    
    log("🔄 Scheduling reconnect for $connectionId in ${delay.inMilliseconds}ms (attempt ${connection.reconnectAttempts}/$_maxReconnectAttempts)");
    
    _reconnectTimers[connectionId]?.cancel();
    _reconnectTimers[connectionId] = Timer(delay, () {
      _instantConnect(connectionId);
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

  /// Pre-warm connections for instant reconnection
  Future<void> preWarmConnections() async {
    log("🔥 Pre-warming websocket connections...");
    
    final connectionIds = _connections.keys.toList();
    for (final connectionId in connectionIds) {
      final connection = _connections[connectionId];
      if (connection != null && !connection.isConnected) {
        // Pre-warm by preparing connection without full initialization
        log("🔥 Pre-warming connection: $connectionId");
        _lastConnectionTime[connectionId] = DateTime.now();
      }
    }
    
    log("✅ Connection pre-warming completed");
  }

  /// Check if connection is stale and needs refresh
  bool _isConnectionStale(String connectionId) {
    final lastConnection = _lastConnectionTime[connectionId];
    if (lastConnection == null) return true;
    
    final timeSinceLastConnection = DateTime.now().difference(lastConnection);
    return timeSinceLastConnection.inMinutes > 5; // Consider stale after 5 minutes
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
  static const int pingInterval = 15; // Reduced from 30 to 15 seconds for faster detection
  static const int pongTimeout = 5; // Reduced from 10 to 5 seconds for faster reconnection
  static const int maxPingRetries = 3; // Max ping retries before considering connection dead

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

  int _pingRetryCount = 0;

  void sendPing() {
    try {
      final pingMessage = jsonEncode({
        'type': 'ping',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'retry_count': _pingRetryCount,
      });
      
      channel?.sink.add(pingMessage);
      lastPingTime = DateTime.now();
      isPongReceived = false;
      _pingRetryCount++;
      
      // Set timeout for pong response with retry logic
      pongTimeoutTimer?.cancel();
      pongTimeoutTimer = Timer(Duration(seconds: pongTimeout), () {
        if (!isPongReceived) {
          if (_pingRetryCount < maxPingRetries) {
            log("⚠️ Pong timeout for $id, retrying ping (${_pingRetryCount}/$maxPingRetries)...");
            sendPing(); // Retry ping immediately
          } else {
            log("❌ Max ping retries reached for $id, reconnecting...");
            _pingRetryCount = 0;
            onError("Pong timeout - max retries reached");
          }
        }
      });
    } catch (e) {
      log("Error sending ping for $id: $e");
    }
  }

  void handlePongResponse() {
    isPongReceived = true;
    pongTimeoutTimer?.cancel();
    _pingRetryCount = 0; // Reset retry count on successful pong
    log("🏓 Pong received for $id");
  }
}
