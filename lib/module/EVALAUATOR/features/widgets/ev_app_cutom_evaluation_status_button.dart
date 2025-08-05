import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_api_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/3_select_and_search_car_model_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/4_select_varient_type.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/5_enter_vehicle_reg_num_sscreen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/6_select_total_kms_driven_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/7_select_and_search_car_location_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';

class EvEvaluationProcessBar extends StatefulWidget {
  int currentPage;
  final InspectionModel? prefillInspection;

  EvaluationDataEntryModel evaluationDataModel;
  EvEvaluationProcessBar({
    super.key,
    required this.prefillInspection,
    required this.currentPage,
    required this.evaluationDataModel,
  });

  @override
  State<EvEvaluationProcessBar> createState() => _EvEvaluationProcessBarState();
}

class _EvEvaluationProcessBarState extends State<EvEvaluationProcessBar> {
  bool isButtonEnabled = false;
  // done
  final doneTextColor = EvAppColors.kAppSecondaryColor;

  final doneBorderColor = EvAppColors.kAppSecondaryColor;

  final doneButtonColor = EvAppColors.kAppSecondaryColor.withOpacity(.2);

  final doneIcon = Icon(
    CupertinoIcons.check_mark_circled_solid,
    color: EvAppColors.kAppSecondaryColor,
  );
  // disbale
  final disableColor = EvAppColors.grey;

  final disabledBorderColor = EvAppColors.grey;

  final diabledButtonColor = EvAppColors.white;

  final disablesIcon = Icon(
    CupertinoIcons.multiply_circle_fill,
    color: EvAppColors.kRed,
  );
  // selcted
  final selctedBorderColor = EvAppColors.white;

  final selectedButtonColor = EvAppColors.DEFAULT_BLUE_DARK;

  final selectedTextColor = EvAppColors.white;

  final selectedIcon = Icon(
    Icons.add_circle_outline_sharp,
    color: EvAppColors.white,
  );

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.currentPage);
    });
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index * w(context) * .35,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: EvConstString.listOfSteps.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index >= widget.currentPage) {
            isButtonEnabled = false;
          } else {
            isButtonEnabled = true;
          }
          final textColor =
              isButtonEnabled
                  ? doneTextColor
                  : widget.currentPage == index
                  ? selectedTextColor
                  : disableColor;
          final containerColor =
              isButtonEnabled
                  ? doneButtonColor
                  : widget.currentPage == index
                  ? selectedButtonColor
                  : diabledButtonColor;
          final borderColor =
              isButtonEnabled
                  ? doneBorderColor
                  : widget.currentPage == index
                  ? selctedBorderColor
                  : disabledBorderColor;

          final icon =
              isButtonEnabled
                  ? doneIcon
                  : widget.currentPage == index
                  ? selectedIcon
                  : disablesIcon;
          final borderWidth = widget.currentPage == index ? 2.0 : 1.0;
          return Center(
            child: InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                if (widget.currentPage > index) {
                  switch (EvConstString.listOfSteps[index]) {
                    case 'Brand':
                      {
                        final state =
                            BlocProvider.of<EvFetchCarMakeBloc>(context).state;
                        if (state is FetchCarMakeSuccessState) {
                          navigatTo(
                            EvSelectAndSearchCarMakes(
                              prefillInspection: widget.prefillInspection,
                              inspectuionId:
                                  widget.evaluationDataModel.inspectionId,
                              listofCarMake: state.carMakeData,
                            ),
                          );
                        }
                      }
                    case 'Year':
                      {
                        navigatTo(
                          EvSelectAndSeachManufacturingYear(
                            prefillInspection: widget.prefillInspection,
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Model':
                      {
                        navigatTo(
                          EvSelectAndSearchCarModelScreen(
                            prefillInspection: widget.prefillInspection,
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Varient':
                      {
                        navigatTo(
                          EvSelectFuealTypeScreen(
                            prefillInspection: widget.prefillInspection,
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Reg. No.':
                      {
                        navigatTo(
                          EvEnterVehicleRegNumSscreen(
                            prefillInspection: widget.prefillInspection,
                            evaluationDataModel: widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Kms Driven':
                      {
                        navigatTo(
                          EvSelectTotalKmsDrivenScreen(
                                prefillInspection: widget.prefillInspection,
                            evaluationDataModel: widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Car location':
                      {
                        navigatTo(
                          EvSelectAndSearchCarLocationScreen(
                                prefillInspection: widget.prefillInspection,
                            evaluationDataModel: widget.evaluationDataModel,
                          ),
                        );
                      }
                  }
                } else {
                  log('cant go ==>');
                }
              },
              child: Container(
                width: w(context) * .3,
                margin: const EdgeInsets.all(AppDimensions.paddingSize10),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSize10,
                  vertical: AppDimensions.paddingSize5,
                ),
                decoration: BoxDecoration(
                  color: containerColor,
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSize5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      EvConstString.listOfSteps[index],
                      style: EvAppStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    icon,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  navigatTo(page) {
    return Navigator.of(context).pushReplacement(AppRoutes.createRoute(page));
  }
}
