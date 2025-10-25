import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class LifecycleWatcher extends StatefulWidget {
  final Widget child;
  const LifecycleWatcher({super.key, required this.child});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App went to background
      _backgroundTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App came back from background
      if (_backgroundTime != null) {
        final idleTime = DateTime.now().difference(_backgroundTime!);
        if (idleTime.inMinutes >= 1) {
          // Restart the whole app if idle for more than 1 minute
          Phoenix.rebirth(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}