import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

class AppEmptyText extends StatelessWidget {
  final String text;
  bool? neddMorhieght = false;
  AppEmptyText({super.key, required this.text, this.neddMorhieght});

  @override
  Widget build(BuildContext context) {
    return neddMorhieght == true
        ? SizedBox(
          height: h(context) * .8,
          child: Center(
            child: Text(text, style: EvAppStyle.style(context: context)),
          ),
        )
        : Center(child: Text(text, style: EvAppStyle.style(context: context)));
  }
}

class AppImageNotFoundText extends StatelessWidget {
  const AppImageNotFoundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '(Image Not Found)',
      textAlign: TextAlign.center,
      style: EvAppStyle.style(
        color: EvAppColors.grey,
        size: AppDimensions.fontSize10(context),
        context: context,
      ),
    );
  }
}
