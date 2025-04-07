import 'package:flutter/material.dart';
import 'package:wheels_kart/core/components/app_appbar.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';

class EvAddNewLeadScreen extends StatelessWidget {
  const EvAddNewLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: "Add New Lead"),
      body: AppMargin(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacer(heightPortion: .01),

            EvAppCustomTextfield(
              isTextCapital: false,
              borderRudius: 15,

              labeltext: "Full Name",

              hintText: "Alex John",
            ),
            EvAppCustomTextfield(
              keyBoardType: TextInputType.phone,
              borderRudius: 15,
              labeltext: "Mobile Number",
              hintText: "+91 9876543210",
            ),

            EvAppCustomTextfield(
              isTextCapital: false,
              borderRudius: 15,
              labeltext: "Address",
              hintText: """Ex.#204, Sai Residency Apartments  
5th Cross, 2nd Main Road, Indiranagar  
Bengaluru - 560038  
Karnataka, India  """,
              maxLine: 4,
            ),

            // Row(
            //   children: [
            //     Flexible(
            //       child: EvAppCustomTextfield(
            //         borderRudius: 15,

            //         labeltext: "",
            //         hintText: "Alex John",
            //       ),
            //     ),
            //     AppSpacer(widthPortion: .03),
            //     Flexible(
            //       child: EvAppCustomTextfield(
            //         borderRudius: 15,

            //         labeltext: "Full Name",
            //         hintText: "Alex John",
            //       ),
            //     ),
            //   ],
            // ),
            AppSpacer(heightPortion: .02),
            EvAppCustomButton(title: "SUBMIT"),
          ],
        ),
      ),
    );
  }
}
