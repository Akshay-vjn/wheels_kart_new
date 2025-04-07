import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

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
            child: Text(text, style: AppStyle.style(context: context)),
          ),
        )
        : Center(child: Text(text, style: AppStyle.style(context: context)));
  }
}

class AppImageNotFoundText extends StatelessWidget {
  const AppImageNotFoundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '(Image Not Found)',
      textAlign: TextAlign.center,
      style: AppStyle.style(
        color: AppColors.grey,
        size: AppDimensions.fontSize10(context),
        context: context,
      ),
    );
  }
}
