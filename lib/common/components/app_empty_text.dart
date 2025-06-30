import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';

class AppEmptyText extends StatelessWidget {
  final String text;
  bool? neddMorhieght = false;
  bool showIcon;
  AppEmptyText({
    super.key,
    required this.text,
    this.neddMorhieght,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return neddMorhieght == true
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showIcon == true
                ? Icon(Icons.sentiment_dissatisfied, size: 50)
                : SizedBox.shrink(),
            SizedBox(
              height: h(context) * .8,
              child: Center(
                child: Text(text, style: EvAppStyle.style(context: context)),
              ),
            ),
          ],
        )
        : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showIcon == true
                  ? Icon(
                    Icons.sentiment_dissatisfied,
                    size: 50,
                    color: VColors.GREYHARD,
                  )
                  : SizedBox.shrink(),
              AppSpacer(heightPortion: .02),
              Text(
                text,
                style: EvAppStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  color: VColors.GREYHARD,
                ),
              ),
            ],
          ),
        );
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
