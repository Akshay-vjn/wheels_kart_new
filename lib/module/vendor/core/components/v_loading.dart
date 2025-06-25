import 'package:flutter/material.dart';
import 'package:wheels_kart/module/vendor/core/const/v_colors.dart';

class VLoadingIndicator extends StatelessWidget {
  const VLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      
      backgroundColor: VColors.SECONDARY,
    );
  }
}