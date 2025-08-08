import 'package:flutter/material.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

class EVAppLoadingIndicator extends StatelessWidget {
  bool? needMorHigt = false;
  EVAppLoadingIndicator({super.key, this.needMorHigt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          needMorHigt == true
              ? SizedBox(
                height: h(context) * .8,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
              : CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                constraints: BoxConstraints(minHeight: 30, minWidth: 30),
              ),
    );
  }
}
