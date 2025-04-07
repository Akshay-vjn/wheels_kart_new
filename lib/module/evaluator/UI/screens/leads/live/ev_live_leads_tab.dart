import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/core/utils/intl_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_the_instruction_repo.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_eselect_postion_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/function_sale_car_screen.dart';

class EvLiveLeadsTab extends StatefulWidget {
  const EvLiveLeadsTab({super.key});

  @override
  State<EvLiveLeadsTab> createState() => _EvLiveLeadsTabState();
}

class _EvLiveLeadsTabState extends State<EvLiveLeadsTab> {
  @override
  void initState() {
    super.initState();
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'ASSIGNED'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchInspectionsBloc, FetchInspectionsState>(
      builder: (context, state) {
        switch (state) {
          case LoadingFetchInspectionsState():
            {
              return AppLoadingIndicator();
            }
          case SuccessFetchInspectionsState():
            {
              return state.listOfInspection.isEmpty
                  ? AppEmptyText(text: state.message)
                  : TransformableListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      InspectionModel data = state.listOfInspection[index];

                      return _buildItems(context, data);
                    },
                    getTransformMatrix: (item) {
                      return getTransformMatrix(item);
                    },
                    separatorBuilder:
                        (context, index) => const AppSpacer(heightPortion: .02),
                    itemCount: state.listOfInspection.length,
                  );
            }
          case ErrorFetchInspectionsState():
            {
              return AppEmptyText(text: state.errormessage);
            }
          default:
            {
              return const SizedBox();
            }
        }
      },
    );
  }

  Widget _buildItems(BuildContext context, InspectionModel inspectionModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppMargin(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inspectionModel.evaluationId,
                    style: AppStyle.style(
                      size: AppDimensions.fontSize24(context),
                      fontWeight: FontWeight.bold,
                      context: context,
                    ),
                  ),
                  Text(
                    IntlHelper.converToDate(inspectionModel.createdAt.date),
                    style: AppStyle.style(
                      size: AppDimensions.fontSize15(context),
                      fontWeight: FontWeight.w500,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacer(heightPortion: .01),
            Container(
              color: AppColors.DEFAULT_BLUE_GREY,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSize10,
              ),
              child: Column(
                children: [
                  AppSpacer(heightPortion: .004),
                  _buildDetails(
                    "Customer Name :",
                    inspectionModel.customer.customerName,
                    SolarIconsOutline.userCircle,
                  ),
                  AppSpacer(heightPortion: .008),
                  _buildDetails(
                    "Contact Number :",
                    inspectionModel.customer.customerMobileNumber,
                    SolarIconsOutline.phoneCallingRounded,
                  ),
                  AppSpacer(heightPortion: .004),
                ],
              ),
            ),
            AppSpacer(heightPortion: .01),

            AppMargin(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      overlayColor: AppColors.DEFAULT_ORANGE,
                      side: BorderSide(color: AppColors.DEFAULT_ORANGE),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        AppRoutes.createRoute(
                          EvSaleCarFunctionScreen(
                            inspectionId: inspectionModel.inspectionId,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.car_repair, color: AppColors.DEFAULT_ORANGE),
                        AppSpacer(widthPortion: .02),
                        Text(
                          "Vehilce Details",
                          style: AppStyle.style(
                            context: context,
                            color: AppColors.DEFAULT_ORANGE,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppSpacer(widthPortion: .02),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.kAppSecondaryColor),
                    ),
                    onPressed: () async {
                      if (inspectionModel.engineTypeId.isEmpty ||
                          inspectionModel.engineTypeId == '0') {
                        showCustomMessageDialog(
                          context,
                          'Fill the basic detailes and try again',
                          messageType: MessageCategory.WARNING,
                        );
                      } else {
                        if (inspectionModel.engineTypeId == '1') {
                          final snapshot =
                              await FetchTheInstructionRepo.getTheInstructionForStartEngine(
                                context,
                                inspectionModel.engineTypeId,
                              );

                          if (snapshot['error'] == true) {
                            showCustomMessageDialog(
                              context,
                              snapshot['message'],
                              messageType: MessageCategory.ERROR,
                            );
                          } else if (snapshot.isEmpty) {
                            showCustomMessageDialog(
                              context,
                              'Instruction page not found!',
                              messageType: MessageCategory.ERROR,
                            );
                          } else if (snapshot['error'] == false) {
                            log(snapshot['data'][0]['instructions'].toString());
                            Navigator.of(context).push(
                              AppRoutes.createRoute(
                                EvSelectPostionScreen(
                                  inspectionId: inspectionModel.inspectionId,
                                  instructionData:
                                      snapshot['data'][0]['instructions'],
                                ),
                              ),
                            );
                            // navigate to instruction page
                          }
                        } else if (inspectionModel.engineTypeId == '1') {
                          // naviga to guestion page
                          Navigator.of(context).push(
                            AppRoutes.createRoute(
                              EvSelectPostionScreen(
                                instructionData: null,
                                inspectionId: inspectionModel.inspectionId,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.content_paste_search_rounded,
                          color: AppColors.kAppSecondaryColor,
                        ),
                        AppSpacer(widthPortion: .02),
                        Text(
                          "Inspect",
                          style: AppStyle.style(
                            context: context,
                            color: AppColors.kAppSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(thickness: 2),
      ],
    );
  }

  Widget _buildDetails(String title, String details, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.white),
            AppSpacer(widthPortion: .02),
            Text(
              title,
              style: AppStyle.style(
                size: AppDimensions.fontSize15(context),
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                context: context,
              ),
            ),
          ],
        ),
        Text(
          details,
          style: AppStyle.style(
            color: AppColors.white,
            size: AppDimensions.fontSize15(context),
            fontWeight: FontWeight.w400,
            context: context,
          ),
        ),
      ],
    );
  }
}
