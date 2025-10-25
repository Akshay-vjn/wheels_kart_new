import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:wheels_kart/common/managers/websocket_manager.dart';

/// Manages app lifecycle events and handles websocket auto-reconnection
class AppLifecycleManager with WidgetsBindingObserver {
  static final AppLifecycleManager _instance = AppLifecycleManager._internal();
  factory AppLifecycleManager() => _instance;
  AppLifecycleManager._internal();

  final WebSocketManager _wsManager = WebSocketManager();
  AppLifecycleState _currentState = AppLifecycleState.resumed;

  /// Initialize the app lifecycle manager
  void initialize() {
    log("🚀 Initializing AppLifecycleManager...");
    
    WidgetsBinding.instance.addObserver(this);
    
    log("✅ AppLifecycleManager initialized");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("📱 App lifecycle state changed: $_currentState -> $state");
    
    final previousState = _currentState;
    _currentState = state;

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed(previousState);
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }

  /// Handle app resumed event with instant reconnection
  void _onAppResumed(AppLifecycleState previousState) {
    log("🔄 App resumed from $previousState - Starting instant websocket reconnection...");
    
    // Start reconnection immediately without delay for instant refresh
    _wsManager.reconnectAllConnections().then((_) {
      log("✅ Instant websocket reconnection completed");
    }).catchError((error) {
      log("❌ Error during instant reconnection: $error");
    });
  }

  /// Handle app paused event
  void _onAppPaused() {
    log("⏸️ App paused - Websockets will auto-reconnect when resumed");
    // Don't disconnect websockets immediately, let them handle reconnection
  }

  /// Handle app inactive event
  void _onAppInactive() {
    log("😴 App inactive - Maintaining websocket connections");
    // Keep websockets connected during brief inactive states
  }

  /// Handle app detached event
  void _onAppDetached() {
    log("🔌 App detached - Disposing websocket connections");
    _wsManager.dispose();
  }

  /// Handle app hidden event
  void _onAppHidden() {
    log("👻 App hidden - Maintaining websocket connections");
    // Keep websockets connected when app is hidden
  }

  /// Get current app lifecycle state
  AppLifecycleState get currentState => _currentState;

  /// Check if app is in foreground
  bool get isInForeground => _currentState == AppLifecycleState.resumed;

  /// Check if app is in background
  bool get isInBackground => 
      _currentState == AppLifecycleState.paused || 
      _currentState == AppLifecycleState.hidden;

  /// Dispose the lifecycle manager
  void dispose() {
    log("🔄 Disposing AppLifecycleManager...");
    
    WidgetsBinding.instance.removeObserver(this);
    
    _wsManager.dispose();
    
    log("✅ AppLifecycleManager disposed");
  }
}
