import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/ev_dashboard_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/live/ev_live_leads_tab.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_cutom_evaluation_status_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20city/fetch_city_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/city_model.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/update_inspection_repo.dart';

import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvSelectAndSearchCarLocationScreen extends StatefulWidget {
  final EvaluationDataEntryModel evaluationDataModel;

  const EvSelectAndSearchCarLocationScreen({
    super.key,
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

    context.read<EvFetchCityBloc>().add(OnFetchCityDataEvent(context: context));
  }

  int? selectedCityindex;
  String? selctedCityId;
  String? selectedCityName;

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
                  return AppLoadingIndicator();
                }
              case FetchCitySuccessSate():
                {
                  return _buildCityView(state.listOfCities);
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

  Widget _buildCityView(List<CityModel> cityList) {
    return ListView.builder(
      itemCount: cityList.length,
      itemBuilder: (context, index) {
        return EvAppCustomeSelctionButton(
          isButtonBorderView: true,
          currentIndex: index,
          onTap: () {
            setState(() {
              selectedCityindex = index;
              selectedCityName = cityList[index].cityName;
              selctedCityId = cityList[index].cityId;
            });

            final _evaluationData = widget.evaluationDataModel;
            _evaluationData.carLocation = selectedCityName;
            _evaluationData.locationID = selctedCityId;

            showModalBottomSheet(
              enableDrag: true,
              context: context,
              shape: BeveledRectangleBorder(),
              builder: (context) {
                return Container(
                  color: AppColors.white,
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
                        bgColor: AppColors.DEFAULT_BLUE_DARK,
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
                          AppColors.kAppSecondaryColor.withOpacity(0.1),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: w(context),
                          padding: const EdgeInsetsDirectional.all(
                            AppDimensions.paddingSize20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kRed),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppStyle.style(
                              fontWeight: FontWeight.bold,
                              context: context,
                              size: AppDimensions.fontSize16(context),
                              color: AppColors.kRed,
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
          selectedButtonIndex: selectedCityindex,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSize15,
            ),
            child: Row(
              children: [
                Icon(Iconsax.location, color: AppColors.black),
                AppSpacer(widthPortion: .04),
                Text(
                  cityList[index].cityName,
                  style: AppStyle.style(
                    size: AppDimensions.fontSize18(context),
                    context: context,
                    color: selectedCityindex != index ? AppColors.black : null,
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
      style: AppStyle.style(
        context: context,
        size: AppDimensions.fontSize13(context),
      ),
    );
  }
}
