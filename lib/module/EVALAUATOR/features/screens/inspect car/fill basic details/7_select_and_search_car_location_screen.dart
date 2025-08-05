import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/home/ev_live_leads_tab.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_selection_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20city/fetch_city_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/city_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/update_inspection_repo.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

class EvSelectAndSearchCarLocationScreen extends StatefulWidget {
  final EvaluationDataEntryModel evaluationDataModel;
  final InspectionModel? prefillInspection;

  const EvSelectAndSearchCarLocationScreen({
    super.key,
    required this.prefillInspection,
    required this.evaluationDataModel,
  });

  @override
  State<EvSelectAndSearchCarLocationScreen> createState() =>
      _EvSelectAndSearchCarLocationScreenState();
}

class _EvSelectAndSearchCarLocationScreenState
    extends State<EvSelectAndSearchCarLocationScreen> {
  @override
  void initState() {
    super.initState();
    final lastCitySelected =
        widget.prefillInspection != null
            ? widget.prefillInspection!.cityId.isNotEmpty
                ? widget.prefillInspection!.cityId
                : null
            : null;
    context.read<EvFetchCityBloc>().add(
      OnFetchCityDataEvent(
        context: context,
        lastCitySelected: lastCitySelected,
      ),
    );
  }

  // int? selectedCityindex;
  // String? selctedCityId;
  // String? selectedCityName;

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
            prefillInspection: widget.prefillInspection,

            currentPage: 6,
            evaluationDataModel: widget.evaluationDataModel,
          ),
        ),
      ),
      body: AppMargin(
        child: BlocConsumer<EvFetchCityBloc, EvFetchCityState>(
          builder: (context, state) {
            switch (state) {
              case FetchCityLoadingState():
                {
                  return EVAppLoadingIndicator();
                }
              case FetchCitySuccessSate():
                {
                  return _buildCityView(state.listOfCities, state);
                }
              case FetchCityErrorState():
                {
                  return AppEmptyText(text: state.errorMessage);
                }
              default:
                {
                  return AppEmptyText(text: 'Loading please wait');
                }
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }

  Widget _buildCityView(List<CityModel> cityList, FetchCitySuccessSate state) {
    return ListView.builder(
      itemCount: cityList.length,
      itemBuilder: (context, index) {
        bool isSelected = state.selectedCityId == cityList[index].cityId;
        return EvAppCustomeSelctionButton(
          isButtonBorderView: true,
          currentIndex: index,
          onTap: () {
            // setState(() {
            //   selectedCityindex = index;
            //   selectedCityName = cityList[index].cityName;
            //   selctedCityId = cityList[index].cityId;
            // });
            context.read<EvFetchCityBloc>().add(
              OnSelectCity(selectedCityId: cityList[index].cityId),
            );
            final _evaluationData = widget.evaluationDataModel;
            _evaluationData.carLocation = cityList[index].cityName;
            ;
            _evaluationData.locationID = cityList[index].cityId;

            showModalBottomSheet(
              enableDrag: true,
              context: context,
              shape: BeveledRectangleBorder(),
              builder: (context) {
                return Container(
                  color: EvAppColors.white,
                  padding: const EdgeInsets.all(AppDimensions.paddingSize15),
                  width: w(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Confirm Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppDimensions.fontSize24(context),
                        ),
                      ),
                      AppSpacer(heightPortion: .02),
                      _buildItemText('Brand', _evaluationData.carMake!),
                      _buildItemText(
                        'Manufacturing year',
                        _evaluationData.makeYear!,
                      ),
                      _buildItemText('Model', _evaluationData.carModel!),
                      _buildItemText('Fuel type', _evaluationData.fuelType!),
                      _buildItemText(
                        'Transmission type',
                        _evaluationData.transmissionType!,
                      ),
                      _buildItemText('Varient', _evaluationData.varient!),
                      _buildItemText(
                        'Reg. no.',
                        _evaluationData.vehicleRegNumber!,
                      ),
                      _buildItemText(
                        'Kms driven',
                        _evaluationData.totalKmsDriven!,
                      ),
                      _buildItemText('City', _evaluationData.carLocation!),
                      const AppSpacer(heightPortion: .02),
                      EvAppCustomButton(
                        bgColor: EvAppColors.DEFAULT_BLUE_DARK,
                        isSquare: true,
                        title: 'Save Inspection',
                        onTap: () async {
                          final snapshot =
                              await UpdateInspectionRepo.updateInspection(
                                context,
                                _evaluationData,
                              );

                          if (snapshot.isEmpty) {
                            showToastMessage(
                              context,
                              'Updating inspection failed !,please try agian',
                              isError: true,
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              AppRoutes.createRoute(EvDashboardScreen()),
                              (route) => false,
                            );
                          } else if (snapshot['error'] == true) {
                            showToastMessage(
                              context,
                              snapshot['message'],
                              isError: true,
                            );
                            Navigator.pop(context);
                          } else if (snapshot['error'] == false) {
                            showToastMessage(context, snapshot['message']);
                            Navigator.of(context).pushAndRemoveUntil(
                              AppRoutes.createRoute(EvDashboardScreen()),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      const AppSpacer(heightPortion: .02),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            AppRoutes.createRoute(EvDashboardScreen()),
                            (context) => false,
                          );
                        },
                        overlayColor: WidgetStatePropertyAll(
                          EvAppColors.kAppSecondaryColor.withOpacity(0.1),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: w(context),
                          padding: const EdgeInsetsDirectional.all(
                            AppDimensions.paddingSize20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: EvAppColors.kRed),
                          ),
                          child: Text(
                            'Cancel',
                            style: EvAppStyle.style(
                              fontWeight: FontWeight.bold,
                              context: context,
                              size: AppDimensions.fontSize16(context),
                              color: EvAppColors.kRed,
                            ),
                          ),
                        ),
                      ),
                      //
                      // Divider(),
                      // _buildItemText(
                      //     'inspaction id', _evaluationData.inspectionId!),
                      // _buildItemText(
                      //     'engine type', _evaluationData.engineTypeId!),
                      // _buildItemText('make id', _evaluationData.makeId!),
                      // _buildItemText('model id', _evaluationData.modelId!),
                      // _buildItemText(
                      //     'location id', _evaluationData.locationID!),
                      // _buildItemText(
                      //     'varient id', _evaluationData.varientId!),
                    ],
                  ),
                );
              },
            );
          },
          selectedButtonIndex: isSelected ? index : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSize15,
            ),
            child: Row(
              children: [
                Icon(Iconsax.location, color: EvAppColors.black),
                AppSpacer(widthPortion: .04),
                Text(
                  cityList[index].cityName,
                  style: EvAppStyle.style(
                    size: AppDimensions.fontSize18(context),
                    context: context,
                    color: isSelected ? EvAppColors.black : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemText(String title, String data) {
    return Text(
      '$title : $data',
      style: EvAppStyle.style(
        context: context,
        size: AppDimensions.fontSize13(context),
      ),
    );
  }
}
