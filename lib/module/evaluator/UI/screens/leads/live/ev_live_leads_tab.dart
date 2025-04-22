import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
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
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_the_instruction_repo.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_eselect_portion_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';

class EvLiveLeadsTab extends StatefulWidget {
  const EvLiveLeadsTab({super.key});

  @override
  State<EvLiveLeadsTab> createState() => _EvLiveLeadsTabState();
}

class _EvLiveLeadsTabState extends State<EvLiveLeadsTab> {
  @override
  void initState() {
    super.initState();
    context.read<EvFetchCarMakeBloc>().add(
      InitalFetchCarMakeEvent(context: context),
    );
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'ASSIGNED'),
    );
  }

  Future<void> load() async {
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'ASSIGNED'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await load();
      },
      child: BlocBuilder<FetchInspectionsBloc, FetchInspectionsState>(
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
                    : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        InspectionModel data = state.listOfInspection[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                index + 1 == state.listOfInspection.length
                                    ? 80
                                    : 0,
                          ),
                          child: _buildItems(context, data),
                        );
                      },

                      // getTransformMatrix: (item) {
                      //   return getTransformMatrix(item);
                      // },
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
      ),
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
                  InkWell(
                    onTap: () {
                      final state =
                          BlocProvider.of<EvFetchCarMakeBloc>(context).state;
                      if (state is FetchCarMakeSuccessState) {
                        Navigator.of(context).push(
                          AppRoutes.createRoute(
                            EvSelectAndSearchCarMakes(
                              inspectuionId: inspectionModel.inspectionId,
                              listofCarMake: state.carMakeData,
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            border: Border.all(
                              color:
                                  inspectionModel.engineTypeId.isEmpty
                                      ? AppColors.DEFAULT_ORANGE
                                      : AppColors.kGreen,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.car_repair,
                                color:
                                    inspectionModel.engineTypeId.isEmpty
                                        ? AppColors.DEFAULT_ORANGE
                                        : AppColors.kGreen,
                              ),
                              AppSpacer(widthPortion: .02),
                              Text(
                                "Reg. Vehicle",
                                style: AppStyle.style(
                                  context: context,
                                  color:
                                      inspectionModel.engineTypeId.isEmpty
                                          ? AppColors.DEFAULT_ORANGE
                                          : AppColors.kGreen,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            color:
                                inspectionModel.engineTypeId.isEmpty
                                    ? AppColors.DEFAULT_ORANGE
                                    : AppColors.kGreen,
                          ),
                          child: Icon(
                            inspectionModel.engineTypeId.isEmpty
                                ? Icons.pending_actions
                                : Icons.task_alt_outlined,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppSpacer(widthPortion: .02),
                  InkWell(
                    onTap: () async {
                      if (inspectionModel.engineTypeId.isEmpty ||
                          inspectionModel.engineTypeId == '0') {
                        showCustomMessageDialog(
                          context,
                          'Complete the vehicle registration and try again.',
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
                            Navigator.of(context).push(
                              AppRoutes.createRoute(
                                EvSelectPostionScreen(
                                  inspectionId: inspectionModel.inspectionId,
                                  instructionData:
                                      snapshot['data'][0]['instructions'],
                                ),
                              ),
                            );
                          }
                        } else if (inspectionModel.engineTypeId == '1') {
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
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color:
                              inspectionModel.engineTypeId.isEmpty ||
                                      inspectionModel.engineTypeId == '0'
                                  ? AppColors.grey
                                  : AppColors.kAppSecondaryColor,
                        ),
                      ),
                      // style: OutlinedButton.styleFrom(
                      //   side: BorderSide(color: AppColors.kAppSecondaryColor),
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.content_paste_search_rounded,
                            color:
                                inspectionModel.engineTypeId.isEmpty ||
                                        inspectionModel.engineTypeId == '0'
                                    ? AppColors.grey
                                    : AppColors.kAppSecondaryColor,
                          ),
                          AppSpacer(widthPortion: .02),
                          Text(
                            "Inspect",
                            style: AppStyle.style(
                              context: context,
                              color:
                                  inspectionModel.engineTypeId.isEmpty ||
                                          inspectionModel.engineTypeId == '0'
                                      ? AppColors.grey
                                      : AppColors.kAppSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(thickness: 5),
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
