import 'package:flutter/cupertino.dart';
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

            EvAppCustomButton(
              title: "SUBMIT",
              onTap: () {
                showSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AppSpacer(heightPortion: 0.02),
              Text(
                'Vehicle Registered',

                style: AppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize17(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacer(heightPortion: 0.01),
              Text(
                'Do you want to inspect the vehicle now or later?',
                textAlign: TextAlign.center,
                style: AppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize15(context),
                  color: AppColors.grey,
                ),
              ),
              AppSpacer(heightPortion: 0.03),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to inspection screen
                },
                icon: Icon(Icons.search, color: Colors.white),
                label: Text(
                  'Inspect Now',
                  style: AppStyle.style(
                    context: context,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.DEFAULT_BLUE_DARK,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              AppSpacer(heightPortion: 0.015),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Vehicle registered for inspection. You can complete it later from the dashboard.',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Do It Later',
                  style: AppStyle.style(
                    context: context,
                    color: AppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
