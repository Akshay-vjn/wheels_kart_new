import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/6_select_total_kms_driven_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvEnterVehicleRegNumSscreen extends StatelessWidget {
  final EvaluationDataEntryModel evaluationDataModel;
  EvEnterVehicleRegNumSscreen({super.key, required this.evaluationDataModel});

  final regNumberController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: customBackButton(context),
          backgroundColor: AppColors.DEFAULT_BLUE_DARK,
          title: Text(
            '${evaluationDataModel.carMake} ${evaluationDataModel.carModel}',
            style: AppStyle.style(
                context: context,
                fontWeight: FontWeight.w500,
                color: AppColors.kWhite,
                size: AppDimensions.fontSize18(context)),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              h(context) * .08,
            ),
            child: EvEvaluationProcessBar(
                currentPage: 4, evaluationDataModel: evaluationDataModel),
          )),
      body: AppMargin(
          child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSpacer(
              heightPortion: .03,
            ),
            Text(
              'Registration number',
              style: AppStyle.style(
                  size: AppDimensions.fontSize17(context),
                  context: context,
                  fontWeight: FontWeight.bold),
            ),
            EvAppCustomTextfield(
              focusColor: AppColors.DEFAULT_BLUE_DARK,
              isTextCapital: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the registration number';
                } else if (!AppString.carRegNumberRegex.hasMatch(value)) {
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
            const AppSpacer(
              heightPortion: .005,
            ),
            EvAppCustomButton(
              bgColor: AppColors.DEFAULT_BLUE_DARK,
              isSquare: true,
              title: 'Continue',
              onTap: () {
                if (formkey.currentState!.validate()) {
                  final _evaluationDataModel = evaluationDataModel;
                  _evaluationDataModel.vehicleRegNumber =
                      regNumberController.text;
                  Navigator.of(context)
                      .push(AppRoutes.createRoute(EvSelectTotalKmsDrivenScreen(
                    evaluationDataModel: _evaluationDataModel,
                  )));
                }
              },
            ),
            const AppSpacer(
              heightPortion: .07,
            ),
          ],
        ),
      )),
    );
  }
}
