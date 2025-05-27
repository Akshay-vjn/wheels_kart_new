import 'package:flutter/material.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

class InspectionStartScreen extends StatelessWidget {
  final String inspectionId;
  final String? instructionData;
  const InspectionStartScreen({
    super.key,
    required this.inspectionId,
    this.instructionData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        title: Text(
          'Inspection',
          style: AppStyle.style(
            color: AppColors.white,
            context: context,
            fontWeight: FontWeight.bold,
            size: AppDimensions.fontSize18(context),
          ),
        ),
      ),

      body: AppMargin(child: Column(children: [

        
      ])),
    );
  }
}
