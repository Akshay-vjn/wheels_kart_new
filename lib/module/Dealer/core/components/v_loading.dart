import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';

class VLoadingIndicator extends StatelessWidget {
  const VLoadingIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: VColors.SECONDARY.withAlpha(50),
      valueColor: AlwaysStoppedAnimation<Color>(VColors.WHITE),
      constraints:
          Platform.isAndroid
              ? BoxConstraints(minWidth: 20, minHeight: 20)
              : null,
      strokeWidth: Platform.isAndroid ? 3 : 2,
    );
  }
}
