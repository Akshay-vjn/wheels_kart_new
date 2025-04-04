import 'package:flutter/material.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class AppSpacer extends StatelessWidget {
  final double? heightPortion;
  final double? widthPortion;
  const AppSpacer({super.key, this.heightPortion, this.widthPortion});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightPortion == null ? 0 : h(context) * heightPortion!,
      width: widthPortion == null ? 0 : w(context) * widthPortion!,
    );
  }
}
