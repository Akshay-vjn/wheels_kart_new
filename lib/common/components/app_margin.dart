import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';

class AppMargin extends StatelessWidget {
  final Widget child;
  const AppMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize15),
      child: child,
    );
  }
}
