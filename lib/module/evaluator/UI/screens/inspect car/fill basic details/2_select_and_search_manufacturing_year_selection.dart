import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/3_select_and_search_car_model_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_search_field.dart';

class EvSelectAndSeachManufacturingYear extends StatefulWidget {
  EvaluationDataEntryModel evaluationDataEntryModel;
  EvSelectAndSeachManufacturingYear({
    super.key,
    required this.evaluationDataEntryModel,
  });

  @override
  State<EvSelectAndSeachManufacturingYear> createState() =>
      _EvSelectAndSeachManufacturingYearState();
}

class _EvSelectAndSeachManufacturingYearState
    extends State<EvSelectAndSeachManufacturingYear> {
  List<String> years = [];
  @override
  void initState() {
    super.initState();
    final _year = _getLast20Years();
    for (var i in _year) {
      years.add(i.toString());
    }
  }

  List<int> _getLast20Years() {
    final currentYear = DateTime.now().year;
    return List.generate(20, (index) => currentYear - index);
  }

  List<String> searchReasult = [];

  final TextEditingController searchController = TextEditingController();

  int? selectedYearIndex;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // key: _scaffoldKey,
      body: Builder(
        builder: (context) {
          // log('building');
          List<String> listOfYear = [];

          if (searchController.text.isEmpty && searchReasult.isEmpty) {
            // log('controller is empty');
            listOfYear = years;
          } else if (searchReasult.isNotEmpty &&
              searchController.text.isNotEmpty) {
            // log('controller has data');
            listOfYear = searchReasult;
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                backgroundColor: AppColors.DEFAULT_BLUE_DARK,
                foregroundColor: Colors.transparent,
                leading: customBackButton(context, color: AppColors.white),
                floating: true,
                pinned: false,
                snap: true,
                title: Text(
                  'Select car manufacturing year',
                  style: AppStyle.style(
                    context: context,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    size: AppDimensions.fontSize18(context),
                  ),
                ),
                toolbarHeight: h(context) * .07,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(h(context) * .09),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppDimensions.paddingSize15,
                      right: AppDimensions.paddingSize15,
                      bottom: AppDimensions.paddingSize25,
                    ),
                    child: EvAppSearchField(
                      keyboardType: TextInputType.number,
                      controller: searchController,
                      hintText: 'Search manufacturing year',
                      onChanged: (value) {
                        List<String> searchList = List.from(years);

                        if (value.isEmpty) {
                          listOfYear = years;
                          searchReasult.clear();
                        } else {
                          log('searching');
                          searchReasult =
                              searchList
                                  .where((element) => element.contains(value))
                                  .toList();
                        }
                        setState(() {});
                        // log(listOfYear.length.toString());
                      },
                    ),
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                ),
              ),
              listOfYear.isEmpty
                  ? SliverFillRemaining(
                    child: AppEmptyText(text: 'Year not found !'),
                  )
                  : TransformableSliverList.builder(
                    itemCount: listOfYear.length,
                    itemBuilder:
                        (context, index) => AppMargin(
                          child: EvAppCustomeSelctionButton(
                            // data: listOfYear,
                            currentIndex: index,
                            onTap: () {
                              setState(() {
                                selectedYearIndex = index;
                                selectedYear = listOfYear[index];
                              });
                              Navigator.of(context).push(
                                AppRoutes.createRoute(
                                  EvSelectAndSearchCarModelScreen(
                                    evaluationDataEntryModel:
                                        EvaluationDataEntryModel(
                                          inspectionId:
                                              widget
                                                  .evaluationDataEntryModel
                                                  .inspectionId,
                                          makeId:
                                              widget
                                                  .evaluationDataEntryModel
                                                  .makeId!,
                                          makeYear: selectedYear!,
                                          carMake:
                                              widget
                                                  .evaluationDataEntryModel
                                                  .carMake!,
                                        ),
                                  ),
                                ),
                              );
                            },
                            selectedButtonIndex: selectedYearIndex,
                            child: Center(
                              child: Text(
                                listOfYear[index].toString(),
                                style: AppStyle.style(
                                  color:
                                      selectedYearIndex != null &&
                                              selectedYearIndex == index
                                          ? AppColors.white
                                          : AppColors.black,
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    getTransformMatrix: getTransformMatrix,
                  ),
            ],
          );
        },
      ),
    );
  }
}

Matrix4 getTransformMatrix(TransformableListItem item) {
  const endScaleBound = 0.3;

  final animationProgress = item.visibleExtent / item.size.height;

  final paintTransform = Matrix4.identity();

  if (item.position != TransformableListItemPosition.middle) {
    final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

    paintTransform
      ..translate(item.size.width / 2)
      ..scale(scale)
      ..translate(-item.size.width / 2);
  }

  return paintTransform;
}
