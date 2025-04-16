import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';

enum MessageCategory { ERROR, SUCCESS, WARNING }

Color getColor(MessageCategory messageType) {
  switch (messageType) {
    case MessageCategory.ERROR:
      {
        return AppColors.black2;
      }
    case MessageCategory.WARNING:
      {
        return AppColors.kWarningColor;
      }
    case MessageCategory.SUCCESS:
      {
        return AppColors.kGreen;
      }
  }
}

IconData getIcon(MessageCategory messageType) {
  switch (messageType) {
    case MessageCategory.ERROR:
      {
        return SolarIconsOutline.closeCircle;
      }
    case MessageCategory.WARNING:
      {
        return Icons.warning_amber_rounded;
      }
    case MessageCategory.SUCCESS:
      {
        return Icons.sentiment_very_satisfied_rounded;
      }
  }
}

void showCustomMessageDialog(
  BuildContext context,
  String message, {
  String? title,
  required MessageCategory messageType,
  bool? enablePop,
}) {
  if (enablePop == true) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: context,
      builder:
          (context) => TweenAnimationBuilder(
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 0.8, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, v, _) {
              return Transform.scale(
                scale: v,
                child: AlertDialog(
                  icon: TweenAnimationBuilder(
                    duration: const Duration(seconds: 2),
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          size: 120,
                          getIcon(messageType),
                          color: getColor(messageType),
                        ),
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  titleTextStyle: AppStyle.style(
                    context: context,
                    fontWeight: FontWeight.bold,
                    size: AppDimensions.fontSize24(context),
                  ),
                  title:
                      title != null
                          ? Text(title, textAlign: TextAlign.center)
                          : null,
                  contentTextStyle: AppStyle.style(
                    size: AppDimensions.fontSize18(context),
                    context: context,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  content: Text(textAlign: TextAlign.center, message),
                ),
              );
            },
          ),
    );
  });
}

void showCustomLoadingDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => AppLoadingIndicator());
}

showToastMessage(BuildContext context, String message, {bool? isError}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor:
        (isError == null || isError == false)
            ? AppColors.DEFAULT_BLUE_DARK
            : AppColors.kRed,
    textColor: AppColors.white,
    fontSize: AppDimensions.fontSize15(context),
  );
}

showSnakBar(
  BuildContext context,
  String title, {
  bool? isError,
  bool? enablePop,
}) {
  if (enablePop == true) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  Future.delayed(Duration(milliseconds: 100), () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        content: Row(
          children: [
            Icon(SolarIconsOutline.closeCircle, color: AppColors.white),
            AppSpacer(widthPortion: .015),
            Flexible(
              child: Text(
                title,
                style: AppStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  size: AppDimensions.fontSize15(context),
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: isError == true ? AppColors.kRed : AppColors.black2,
      ),
    );
  });
}
