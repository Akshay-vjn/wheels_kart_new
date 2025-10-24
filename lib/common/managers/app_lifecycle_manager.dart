import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/managers/websocket_manager.dart';

class AppLifecycleManager with WidgetsBindingObserver {
  static final AppLifecycleManager _instance = AppLifecycleManager._internal();
  factory AppLifecycleManager() => _instance;
  AppLifecycleManager._internal();

  bool _isInitialized = false;
  bool _isAppInBackground = false;
  Timer? _reconnectionTimer;

  /// Initialize the lifecycle manager
  void initialize() {
    if (!_isInitialized) {
      WidgetsBinding.instance.addObserver(this);
      _isInitialized = true;
      log("🔄 AppLifecycleManager initialized");
    }
  }

  /// Dispose the lifecycle manager
  void dispose() {
    if (_isInitialized) {
      WidgetsBinding.instance.removeObserver(this);
      _reconnectionTimer?.cancel();
      _isInitialized = false;
      log("🔄 AppLifecycleManager disposed");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("🔄 App lifecycle state changed: $state");
    
    switch (state) {
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      case AppLifecycleState.inactive:
        // App is transitioning between foreground and background
        break;
      case AppLifecycleState.hidden:
        // App is hidden (iOS specific)
        break;
    }
  }

  /// Handle when app goes to background
  void _handleAppPaused() {
    _isAppInBackground = true;
    log("📱 App paused - websockets will disconnect");
    
    // Cancel any pending reconnection attempts
    _reconnectionTimer?.cancel();
  }

  /// Handle when app comes back to foreground
  void _handleAppResumed() {
    if (_isAppInBackground) {
      log("📱 App resumed - checking websocket connections");
      _isAppInBackground = false;
      
      // Delay reconnection to ensure app is fully resumed
      _reconnectionTimer?.cancel();
      _reconnectionTimer = Timer(const Duration(milliseconds: 500), () {
        _reconnectWebSockets();
      });
    }
  }

  /// Handle when app is completely closed
  void _handleAppDetached() {
    log("📱 App detached - cleaning up websockets");
    _isAppInBackground = false;
    _reconnectionTimer?.cancel();
  }

  /// Reconnect all websockets
  Future<void> _reconnectWebSockets() async {
    try {
      log("🔄 Attempting to reconnect websockets...");
      
      // Get the WebSocketManager instance and reconnect all connections
      final wsManager = WebSocketManager();
      await wsManager.reconnectAllConnections();
      
      log("✅ Websocket reconnection completed");
    } catch (e) {
      log("❌ Failed to reconnect websockets: $e");
      
      // Retry after a delay
      _reconnectionTimer?.cancel();
      _reconnectionTimer = Timer(const Duration(seconds: 3), () {
        _reconnectWebSockets();
      });
    }
  }

  /// Check if app is currently in background
  bool get isAppInBackground => _isAppInBackground;

  /// Force reconnect websockets (can be called manually)
  Future<void> forceReconnect() async {
    log("🔄 Force reconnecting websockets...");
    await _reconnectWebSockets();
  }
}
