import 'package:flutter/cupertino.dart';

class AppRoutes {
  static Route createRoute(page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(microseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
