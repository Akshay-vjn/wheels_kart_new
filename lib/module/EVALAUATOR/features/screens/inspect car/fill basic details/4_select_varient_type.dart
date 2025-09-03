import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/const/ev_const_images.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/varient_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/fetch_car_varient_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/5_enter_vehicle_reg_num_sscreen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_selection_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

class EvSelectFuealTypeScreen extends StatefulWidget {
  EvaluationDataEntryModel evaluationDataEntryModel;
  final InspectionModel? prefillInspection;

  EvSelectFuealTypeScreen({
    super.key,
    required this.evaluationDataEntryModel,
    required this.prefillInspection,
  });

  @override
  State<EvSelectFuealTypeScreen> createState() =>
      _EvSelectFuealTypeScreenState();
}

class _EvSelectFuealTypeScreenState extends State<EvSelectFuealTypeScreen> {
  List<Map<String, dynamic>> listOFFuelType = [
    {'title': 'Petrol', 'img': EvConstImages.petrolImage},
    {'title': 'Diesel', 'img': EvConstImages.dieselImage},
    {'title': 'Petrol+CNG', 'img': EvConstImages.petrolAndCngImage},
    {'title': 'Hybrid', 'img': EvConstImages.hybridImae},
    {'title': 'Petrol+LPG', 'img': EvConstImages.petrolAndLpgImage},
    {'title': 'CNG', 'img': EvConstImages.cngImage},
    {'title': 'Electric', 'img': EvConstImages.electricalImage},
  ];

  List<Map<String, dynamic>> transmissionsList = [
    {'title': 'Manual'},
    {'title': 'Automatic'},
  ];

  List<VarientModel> varientList = [];

  int? selectedFuelTypeIndex;
  String? selectedFuelType;
  bool disableFuelView = false;

  int? selectedTransmissionIndex;
  String? selectedTransmission;
  bool disableTransmissionView = false;

  int? selectedVarientIndex;
  String? selectedVarient;
  bool disableVarientView = false;

  String? varientId;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initiateThePrefillData();
  }

  void _scrollToIndex() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color boxColor = EvAppColors.FILL_COLOR;

  _initiateThePrefillData() async {
    if (widget.prefillInspection != null) {
      final lastFuelType =
          widget.prefillInspection!.fuelType.isNotEmpty
              ? widget.prefillInspection!.fuelType
              : null;
      final lastTransmissionType =
          widget.prefillInspection!.transmissionType.isNotEmpty
              ? widget.prefillInspection!.transmissionType
              : null;
      final lastVarientId =
          widget.prefillInspection!.variantId.isNotEmpty
              ? widget.prefillInspection!.variantId
              : null;

      if (lastFuelType != null) {
        selectedFuelType = lastFuelType;
        selectedFuelTypeIndex = listOFFuelType.indexWhere(
          (element) => element['title'] == selectedFuelType,
        );
        disableFuelView = true;
      }
      if (lastTransmissionType != null) {
        selectedTransmission = lastTransmissionType;
        selectedTransmissionIndex = transmissionsList.indexWhere(
          (element) => element['title'] == selectedTransmission,
        );
        disableTransmissionView = true;
      }
      if (lastVarientId != null) {
        varientId = lastVarientId;
        final snapshot = await FetchCarVarientRepo.fetchCarVarient(
          context,
          widget.evaluationDataEntryModel.modelId!,
          selectedFuelType!,
          lastTransmissionType!.toLowerCase(),
        );

        if (snapshot['error'] == false ||
            snapshot['message'] == 'Variant list fetched successfully') {
          List data = snapshot['data'];
          varientList = data.map((e) => VarientModel.fromJson(e)).toList();
          selectedVarient = varientId;
          selectedVarientIndex=varientList.indexWhere((element) => element.variantId==varientId,);
          disableVarientView = true;
          setState(() {
            
          });

          // int? selectedVarientIndex;
          // String? selectedVarient;
          // bool disableVarientView = false;
          // final varient = varientList.firstWhere(
          //   (element) => element.variantId == varientId,
          // );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: evCustomBackButton(context),
        backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
        title: Text(
          '${widget.evaluationDataEntryModel.carMake} ${widget.evaluationDataEntryModel.carModel}',
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
            prefillInspection: widget.prefillInspection,
            currentPage: 3,
            evaluationDataModel: widget.evaluationDataEntryModel,
          ),
        ),
      ),
      body: AppMargin(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              AppSpacer(heightPortion: .02),
              //  fuel type
              _feulType(),
              AppSpacer(heightPortion: .02),
              //transmission type
              selectedFuelTypeIndex != null
                  ? _transmissionType()
                  : const SizedBox(),
              AppSpacer(heightPortion: .02),
              selectedTransmissionIndex != null
                  ? _varientType()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feulType() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      color: boxColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Select fuel type'),
          if (disableFuelView) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: EvAppCustomeSelctionButton(
                    isButtonBorderView: false,
                    currentIndex: selectedFuelTypeIndex!,
                    onTap: () {},
                    selectedButtonIndex: selectedFuelTypeIndex,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //     listOFFuelType[selectedFuelTypeIndex!]['img']),
                        // // Icon(Icons.),
                        // AppSpacer(
                        //   widthPortion: .05,
                        // ),
                        Text(
                          listOFFuelType[selectedFuelTypeIndex!]['title'],
                          style: EvAppStyle.style(
                            size: AppDimensions.fontSize17(context),
                            context: context,
                            color: EvAppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacer(widthPortion: .02),
                InkWell(
                  onTap: () {
                    setState(() {
                      disableFuelView = false;
                      disableTransmissionView = false;
                      disableVarientView = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 53,
                    width: 53,
                    decoration: BoxDecoration(
                      color: EvAppColors.white,
                      border: Border.all(color: EvAppColors.DEFAULT_BLUE_GREY),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize5,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: EvAppColors.DEFAULT_BLUE_GREY,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (!disableFuelView) ...[
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2,
                crossAxisCount: 2,
                crossAxisSpacing: AppDimensions.paddingSize15,
              ),
              children:
                  listOFFuelType.asMap().entries.map((element) {
                    return EvAppCustomeSelctionButton(
                      isButtonBorderView: selectedFuelTypeIndex != null,
                      currentIndex: element.key,
                      onTap: () {
                        setState(() {
                          selectedFuelTypeIndex = element.key;
                          selectedFuelType = element.value['title'];
                          selectedFuelType!.toLowerCase();
                          disableFuelView = true;
                        });
                        if (selectedFuelTypeIndex != null) {
                          selectedTransmission = null;
                          selectedTransmissionIndex = null;
                          selectedVarient = null;
                          selectedVarientIndex = null;
                        }
                      },
                      // data: listOFFuelType,
                      selectedButtonIndex: selectedFuelTypeIndex,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(element.value['img']),
                          // Icon(Icons.),
                          Text(
                            element.value['title'],
                            style: EvAppStyle.style(
                              context: context,
                              color:
                                  selectedFuelTypeIndex != null
                                      ? EvAppColors.DEFAULT_BLUE_DARK
                                      : selectedFuelTypeIndex == element.key
                                      ? EvAppColors.white
                                      : EvAppColors.DEFAULT_BLUE_DARK,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _transmissionType() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      color: boxColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Select transmission type'),
          if (disableTransmissionView) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: EvAppCustomeSelctionButton(
                    isButtonBorderView: false,
                    currentIndex: selectedTransmissionIndex!,
                    onTap: () async {},
                    // data: transmissionsList,
                    selectedButtonIndex: selectedTransmissionIndex,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          transmissionsList[selectedTransmissionIndex!]['title'],
                          style: EvAppStyle.style(
                            size: AppDimensions.fontSize17(context),
                            context: context,
                            color: EvAppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacer(widthPortion: .02),
                InkWell(
                  onTap: () {
                    setState(() {
                      disableTransmissionView = false;
                      disableVarientView = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 53,
                    width: 53,
                    decoration: BoxDecoration(
                      color: EvAppColors.white,
                      border: Border.all(color: EvAppColors.DEFAULT_BLUE_GREY),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize5,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: EvAppColors.DEFAULT_BLUE_GREY,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (!disableTransmissionView) ...[
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2,
                crossAxisCount: 2,
                crossAxisSpacing: AppDimensions.paddingSize15,
              ),
              children:
                  transmissionsList.asMap().entries.map((element) {
                    return EvAppCustomeSelctionButton(
                      isButtonBorderView: selectedTransmissionIndex != null,
                      currentIndex: element.key,
                      onTap: () async {
                        String transmissionTyp = element.value['title'];
                        final snapshot =
                            await FetchCarVarientRepo.fetchCarVarient(
                              context,
                              widget.evaluationDataEntryModel.modelId!,
                              selectedFuelType!,
                              transmissionTyp.toLowerCase(),
                            );

                        if (snapshot.isEmpty) {
                          setState(() {
                            selectedTransmissionIndex = element.key;
                            selectedTransmission = element.value['title'];
                            varientList = [];
                          });
                        } else if (snapshot['error'] == false ||
                            snapshot['message'] ==
                                'Variant list fetched successfully') {
                          setState(() {
                            selectedTransmission = element.value['title'];
                            selectedTransmissionIndex = element.key;
                            List data = snapshot['data'];
                            varientList =
                                data
                                    .map((e) => VarientModel.fromJson(e))
                                    .toList();
                          });
                        } else if (snapshot['error'] == true) {
                          setState(() {
                            varientList = [];
                          });
                          log(snapshot['message'].toString());
                        }
                        if (selectedTransmissionIndex != null) {
                          selectedVarient = null;
                          selectedVarientIndex = null;
                        }
                        disableTransmissionView = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToIndex();
                        });
                      },
                      // data: transmissionsList,
                      selectedButtonIndex: selectedTransmissionIndex,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            element.value['title'],
                            style: EvAppStyle.style(
                              context: context,
                              color:
                                  selectedTransmissionIndex != null
                                      ? EvAppColors.DEFAULT_BLUE_DARK
                                      : selectedTransmissionIndex == element.key
                                      ? EvAppColors.white
                                      : EvAppColors.DEFAULT_BLUE_DARK,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _varientType() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      color: boxColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Select varient '),
          if (disableVarientView) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: EvAppCustomeSelctionButton(
                    isButtonBorderView: false,
                    currentIndex: selectedTransmissionIndex!,
                    onTap: () {},
                    // data: varientList,
                    selectedButtonIndex: selectedVarientIndex,
                    child: AppMargin(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              varientList[selectedTransmissionIndex!].fullName,
                              style: EvAppStyle.style(
                                size: AppDimensions.fontSize17(context),
                                context: context,
                                color: EvAppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacer(widthPortion: .02),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedVarientIndex = null;
                      disableVarientView = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 53,
                    width: 53,
                    decoration: BoxDecoration(
                      color: EvAppColors.white,
                      border: Border.all(color: EvAppColors.DEFAULT_BLUE_GREY),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize5,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: EvAppColors.DEFAULT_BLUE_GREY,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (!disableVarientView) ...[
            varientList.isEmpty
                ? Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: AppEmptyText(text: 'Varient not found'),
                )
                : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: varientList.length,
                  itemBuilder:
                      (context, index) => EvAppCustomeSelctionButton(
                        isButtonBorderView: selectedTransmissionIndex != null,
                        currentIndex: index,
                        onTap: () {
                          if (selectedVarientIndex == null) {
                            String? enginTypeId;

                            setState(() {
                              selectedVarientIndex = index;
                              selectedVarient = varientList[index].fullName;
                              varientId = varientList[index].variantId;
                              if (selectedFuelType == 'Electric') {
                                enginTypeId = '2';
                              } else {
                                enginTypeId = "1";
                              }
                              disableVarientView = true;
                            });

                            Navigator.of(context).push(
                              AppRoutes.createRoute(
                                EvEnterVehicleRegNumSscreen(
                                  prefillInspection: widget.prefillInspection,
                                  evaluationDataModel: EvaluationDataEntryModel(
                                    modelId:
                                        widget.evaluationDataEntryModel.modelId,
                                    inspectionId:
                                        widget
                                            .evaluationDataEntryModel
                                            .inspectionId,
                                    varientId: varientId!,
                                    carMake:
                                        widget.evaluationDataEntryModel.carMake,
                                    carModel:
                                        widget
                                            .evaluationDataEntryModel
                                            .carModel,
                                    fuelType: selectedFuelType,
                                    makeId:
                                        widget.evaluationDataEntryModel.makeId,
                                    makeYear:
                                        widget
                                            .evaluationDataEntryModel
                                            .makeYear,
                                    transmissionType: selectedTransmission,
                                    varient: selectedVarient,
                                    engineTypeId: enginTypeId!,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        // data: varientList,
                        selectedButtonIndex: selectedVarientIndex,
                        child: AppMargin(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  varientList[index].fullName,
                                  style: EvAppStyle.style(
                                    context: context,
                                    color:
                                        selectedVarientIndex != null
                                            ? EvAppColors.DEFAULT_BLUE_DARK
                                            : selectedVarientIndex == index
                                            ? EvAppColors.white
                                            : EvAppColors.DEFAULT_BLUE_DARK,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Column(
      children: [
        const AppSpacer(heightPortion: .01),
        Text(
          title,
          style: EvAppStyle.style(
            size: AppDimensions.fontSize17(context),
            context: context,
            fontWeight: FontWeight.bold,
          ),
        ),
        const AppSpacer(heightPortion: .02),
      ],
    );
  }
}
