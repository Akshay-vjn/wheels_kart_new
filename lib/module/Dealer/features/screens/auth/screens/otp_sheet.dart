// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/common/dimensions.dart';
// import 'package:wheels_kart/common/utils/responsive_helper.dart';
// import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
// import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
// import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_button.dart';
// import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_texfield.dart';
// import 'package:wheels_kart/module/vendor/core/v_style.dart';

// class OtpSheet extends StatelessWidget {
//   final String mobilNumber;
//   const OtpSheet({super.key, required this.mobilNumber});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPadding(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//       padding: EdgeInsets.only(
//         left: 10,
//         right: 10,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: Container(
//         padding: EdgeInsets.all(20),
//         width: w(context),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(AppDimensions.radiusSize50),
//           color: VColors.WHITE,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AppSpacer(heightPortion: .02),
//             Text(
//               textAlign: TextAlign.center,
//               "We sent 6 digit verification code to",
//               style: VStyle.style(
//                 context: context,
//                 size: AppDimensions.fontSize15(context),
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Text(
//               textAlign: TextAlign.center,
//               "+91 $mobilNumber",
//               style: VStyle.style(
//                 context: context,
//                 size: AppDimensions.fontSize17(context),
//                 color: VColors.SECONDARY,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             AppSpacer(heightPortion: .025),

//             Pinput(
//               length: 6,
//               defaultPinTheme: _pintheme(context, TextFieldState.OUTOFFOCUS),
//               errorPinTheme: _pintheme(context, TextFieldState.ERROR),
//               focusedPinTheme: _pintheme(context, TextFieldState.FOCUSED),
//               disabledPinTheme: _pintheme(context, TextFieldState.OUTOFFOCUS),
//               submittedPinTheme: _pintheme(context, TextFieldState.OUTOFFOCUS),
//               followingPinTheme: _pintheme(context, TextFieldState.FOCUSED),
//             ),

//             AppSpacer(heightPortion: .01),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Dont't receive the OTP ?",
//                   style: VStyle.style(
//                     context: context,
//                     size: AppDimensions.fontSize13(context),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     "RESEND OTP",
//                     style: VStyle.style(
//                       context: context,
//                       size: AppDimensions.fontSize13(context),
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             AppSpacer(heightPortion: .01),
//             VCustomButton(width: w(context) * .7, title: "VERIFY"),
//             AppSpacer(heightPortion: .01),
//           ],
//         ),
//       ),
//     );
//   }

//   PinTheme _pintheme(context, TextFieldState state) {
//     Color borderColor;

//     switch (state) {
//       case TextFieldState.ERROR:
//         {
//           borderColor = VColors.ERROR;
//         }
//       case TextFieldState.FOCUSED:
//         {
//           borderColor = VColors.SECONDARY;
//         }
//       case TextFieldState.OUTOFFOCUS:
//         {
//           borderColor = VColors.SECONDARY.withAlpha(120);
//         }
//     }
//     return PinTheme(
//       textStyle: VStyle.style(
//         context: context,
//         color: borderColor,
//         fontWeight: FontWeight.bold,
//         size: AppDimensions.fontSize16(context),
//       ),
//       width: w(context) / 6,
//       height: 50,

//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
//         border: Border.all(color: borderColor),
//       ),
//     );
//   }
// }
