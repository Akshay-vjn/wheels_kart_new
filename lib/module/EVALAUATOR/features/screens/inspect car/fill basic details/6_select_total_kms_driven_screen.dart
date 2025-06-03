import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/7_select_and_search_car_location_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_selection_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

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
        leading: evCustomBackButton(context),
        backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
        title: Text(
          '${widget.evaluationDataModel.carMake} ${widget.evaluationDataModel.carModel}',
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
              color: EvAppColors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: EvAppColors.black.withOpacity(.1),
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
                    style: EvAppStyle.style(
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
                          style: EvAppStyle.style(
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
