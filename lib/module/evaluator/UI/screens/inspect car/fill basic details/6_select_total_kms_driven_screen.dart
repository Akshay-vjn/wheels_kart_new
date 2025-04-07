import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/7_select_and_search_car_location_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvSelectTotalKmsDrivenScreen extends StatefulWidget {
  final EvaluationDataEntryModel evaluationDataModel;
  EvSelectTotalKmsDrivenScreen({super.key, required this.evaluationDataModel});

  @override
  State<EvSelectTotalKmsDrivenScreen> createState() =>
      _EvSelectTotalKmsDrivenScreenState();
}

class _EvSelectTotalKmsDrivenScreenState
    extends State<EvSelectTotalKmsDrivenScreen> {
  int? selectedIndexofKmsDrive;

  String? selectedKmsDrivenvalue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genarateKmsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        backgroundColor: AppColors.DEFAULT_BLUE_DARK,
        title: Text(
          '${widget.evaluationDataModel.carMake} ${widget.evaluationDataModel.carModel}',
          style: AppStyle.style(
            context: context,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            size: AppDimensions.fontSize18(context),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(h(context) * .08),
          child: EvEvaluationProcessBar(
            currentPage: 5,
            evaluationDataModel: widget.evaluationDataModel,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w(context),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: AppColors.black.withOpacity(.1),
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: AppMargin(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSpacer(heightPortion: .02),
                  Text(
                    'Kilometers driven',
                    style: AppStyle.style(
                      size: AppDimensions.fontSize17(context),
                      context: context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const AppSpacer(heightPortion: .02),
                ],
              ),
            ),
          ),
          Expanded(
            child: AppMargin(
              child: ListView.builder(
                itemCount: listOfKmsData.length,
                shrinkWrap: true,
                itemBuilder:
                    (context, index) => EvAppCustomeSelctionButton(
                      isButtonBorderView: true,
                      currentIndex: index,
                      onTap: () {
                        setState(() {
                          selectedIndexofKmsDrive = index;
                          selectedKmsDrivenvalue = listOfKmsData[index];
                        });
                        final _evaluationData = widget.evaluationDataModel;
                        _evaluationData.totalKmsDriven = selectedKmsDrivenvalue;

                        Navigator.of(context).push(
                          AppRoutes.createRoute(
                            EvSelectAndSearchCarLocationScreen(
                              evaluationDataModel: _evaluationData,
                            ),
                          ),
                        );
                      },
                      selectedButtonIndex: selectedIndexofKmsDrive,
                      child: Center(
                        child: Text(
                          listOfKmsData[index],
                          style: AppStyle.style(
                            context: context,
                            fontWeight: FontWeight.bold,
                            size: AppDimensions.fontSize16(context),
                          ),
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> listOfKmsData = [];
  _genarateKmsList() {
    int to = 0;
    int from = 0;
    List.generate(12, (index) {
      from = to;
      to = index * 10000;
      if (to != 0) {
        if (to > 100000) {
          listOfKmsData.add('Above - ${from} Km');
        } else {
          listOfKmsData.add('${from} - ${to} Km');
        }
      }
    });
  }
}
