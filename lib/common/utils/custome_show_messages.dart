import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

void showCustomLoadingDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => EVAppLoadingIndicator());
}

showToastMessage(BuildContext context, String message, {bool? isError}) async {
  final getUserType = await AppAuthController().getUserData;
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,

    timeInSecForIosWeb: 1,

    backgroundColor:
        (isError == null || isError == false)
            ? EvAppColors.kAppSecondaryColor
            : EvAppColors.kRed,
    textColor: EvAppColors.white,
    fontSize: AppDimensions.fontSize13(context),
  );
}

showSnakBar(
  BuildContext context,
  String title, {
  bool? isError = false,
  bool? enablePop,
}) {
  if (enablePop == true) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  // Future.delayed(Duration(milliseconds: 100), () {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     backgroundColor: isError == true ? EvAppColors.kRed : EvAppColors.kGreen,
  //     behavior: SnackBarBehavior.floating,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     margin: const EdgeInsets.all(16),
  //     duration: const Duration(seconds: 3),
  //     content: Row(
  //       children: [
  //         Icon(
  //           isError == true ? Icons.error : Icons.check_circle,
  //           color: EvAppColors.white,
  //         ),
  //         AppSpacer(widthPortion: .015),
  //         Expanded(
  //           child: Text(
  //             title,
  //             style: EvAppStyle.style(
  //               context: context,
  //               fontWeight: FontWeight.w600,
  //               color: EvAppColors.white,
  //               size: AppDimensions.fontSize15(context),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError == true ? Icons.error : Icons.check_circle,
            color: EvAppColors.white,
          ),
          AppSpacer(widthPortion: .015),
          Expanded(
            child: Text(
              title,
              style: EvAppStyle.style(
                context: context,
                fontWeight: FontWeight.w600,
                color: EvAppColors.white,
                size: AppDimensions.fontSize15(context),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError! ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ),
  );
  // });
}
