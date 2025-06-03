import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/6_select_total_kms_driven_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_textfield.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

class EvEnterVehicleRegNumSscreen extends StatelessWidget {
  final EvaluationDataEntryModel evaluationDataModel;
  EvEnterVehicleRegNumSscreen({super.key, required this.evaluationDataModel});

  final regNumberController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  static RegExp carRegNumberRegex = RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{4}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: evCustomBackButton(context),
        backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
        title: Text(
          '${evaluationDataModel.carMake} ${evaluationDataModel.carModel}',
          style: EvAppStyle.style(
            context: context,
            fontWeight: FontWeight.w500,
            color: EvAppColors.white,
            size: AppDimensions.fontSize18(context),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(h(context) * .08),
          child: EvEvaluationProcessBar(
            currentPage: 4,
            evaluationDataModel: evaluationDataModel,
          ),
        ),
      ),
      body: AppMargin(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSpacer(heightPortion: .03),
              Text(
                'Registration number',
                style: EvAppStyle.style(
                  size: AppDimensions.fontSize17(context),
                  context: context,
                  fontWeight: FontWeight.bold,
                ),
              ),
              EvAppCustomTextfield(
                focusColor: EvAppColors.DEFAULT_BLUE_DARK,
                isTextCapital: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the registration number';
                  } else if (!carRegNumberRegex.hasMatch(value)) {
                    return 'Registration number is not valid';
                  } else {
                    return null;
                  }
                },
                controller: regNumberController,
                // labeltext: 'Registration number',
                maxLenght: 10,
                hintText: 'Enter the vehicle registration number',
              ),
              const AppSpacer(heightPortion: .005),
              EvAppCustomButton(
                bgColor: EvAppColors.DEFAULT_BLUE_DARK,
                isSquare: true,
                title: 'Continue',
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    final _evaluationDataModel = evaluationDataModel;
                    _evaluationDataModel.vehicleRegNumber =
                        regNumberController.text;
                    Navigator.of(context).push(
                      AppRoutes.createRoute(
                        EvSelectTotalKmsDrivenScreen(
                          evaluationDataModel: _evaluationDataModel,
                        ),
                      ),
                    );
                  }
                },
              ),
              const AppSpacer(heightPortion: .07),
            ],
          ),
        ),
      ),
    );
  }
}
