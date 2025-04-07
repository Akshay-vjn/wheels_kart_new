import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/string.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/3_select_and_search_car_model_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/4_select_varient_type.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/5_enter_vehicle_reg_num_sscreen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/6_select_total_kms_driven_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/7_select_and_search_car_location_screen.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';

class EvEvaluationProcessBar extends StatefulWidget {
  int currentPage;
  EvaluationDataEntryModel evaluationDataModel;
  EvEvaluationProcessBar({
    super.key,
    required this.currentPage,
    required this.evaluationDataModel,
  });

  @override
  State<EvEvaluationProcessBar> createState() => _EvEvaluationProcessBarState();
}

class _EvEvaluationProcessBarState extends State<EvEvaluationProcessBar> {
  bool isButtonEnabled = false;
  // done
  final doneTextColor = AppColors.kAppSecondaryColor;

  final doneBorderColor = AppColors.kAppSecondaryColor;

  final doneButtonColor = AppColors.kAppSecondaryColor.withOpacity(.2);

  final doneIcon = Icon(
    CupertinoIcons.check_mark_circled_solid,
    color: AppColors.kAppSecondaryColor,
  );
  // disbale
  final disableColor = AppColors.grey;

  final disabledBorderColor = AppColors.grey;

  final diabledButtonColor = AppColors.white;

  final disablesIcon = Icon(
    CupertinoIcons.multiply_circle_fill,
    color: AppColors.kRed,
  );
  // selcted
  final selctedBorderColor = AppColors.white;

  final selectedButtonColor = AppColors.DEFAULT_BLUE_DARK;

  final selectedTextColor = AppColors.white;

  final selectedIcon = Icon(
    Icons.add_circle_outline_sharp,
    color: AppColors.white,
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
        itemCount: AppString.listOfSteps.length,
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
                  switch (AppString.listOfSteps[index]) {
                    case 'Brand':
                      {
                        final state =
                            BlocProvider.of<EvFetchCarMakeBloc>(context).state;
                        if (state is FetchCarMakeSuccessState) {
                          navigatTo(
                            EvSelectAndSearchCarMakes(
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
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Model':
                      {
                        navigatTo(
                          EvSelectAndSearchCarModelScreen(
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Varient':
                      {
                        navigatTo(
                          EvSelectFuealTypeScreen(
                            evaluationDataEntryModel:
                                widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Reg. No.':
                      {
                        navigatTo(
                          EvEnterVehicleRegNumSscreen(
                            evaluationDataModel: widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Kms Driven':
                      {
                        navigatTo(
                          EvSelectTotalKmsDrivenScreen(
                            evaluationDataModel: widget.evaluationDataModel,
                          ),
                        );
                      }
                    case 'Car location':
                      {
                        navigatTo(
                          EvSelectAndSearchCarLocationScreen(
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
                      AppString.listOfSteps[index],
                      style: AppStyle.style(
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
