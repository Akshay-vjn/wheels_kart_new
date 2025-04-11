import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pdf_preview.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

class EvCompletedLeadTab extends StatefulWidget {
  const EvCompletedLeadTab({super.key});

  @override
  State<EvCompletedLeadTab> createState() => _EvCompletedLeadTabState();
}

class _EvCompletedLeadTabState extends State<EvCompletedLeadTab> {
  @override
  void initState() {
    super.initState();
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'ASSIGNED'),
    );
  }

  List<Map<String, dynamic>> datas = [
    {'id': '1', "name": 'John Doe', 'mobileNumber': '1234567890'},
    {'id': '2', 'name': 'Jane Smith', 'mobileNumber': '0987654321'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                    : TransformableListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        InspectionModel data = state.listOfInspection[index];

                        return AppMargin(
                          child: _buildItems(
                            context,
                            datas[index]['id'],
                            datas[index]['id'],
                            datas[index]['name'],
                            datas[index]['mobileNumber'],
                            data,
                          ),
                        );
                      },
                      getTransformMatrix: (item) {
                        return getTransformMatrix(item);
                      },
                      separatorBuilder:
                          (context, index) => AppSpacer(heightPortion: .02),
                      itemCount: state.listOfInspection.length,
                    );
              }
            case ErrorFetchInspectionsState():
              {
                return AppEmptyText(text: state.errormessage);
              }
            default:
              {
                return SizedBox();
              }
          }
        },
      ),
    );
  }

  Widget _buildItems(
    BuildContext context,
    String inspection,
    String id,
    String name,
    String mobileNumber,
    InspectionModel model,
  ) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (_) => PdfPreviewScreen(model: model)),
        // );

        Navigator.of(
          context,
        ).push(AppRoutes.createRoute(PdfPreviewScreen(model: model)));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(color: AppColors.black2, height: 100, width: 100),
                AppSpacer(widthPortion: .02),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Flexible(
                                child: Text(
                                  "Maruti Suzuki Alto 800",
                                  style: AppStyle.style(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                    size: AppDimensions.fontSize18(context),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kGreen,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "COMPLETED",
                                  style: AppStyle.style(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "KL10AU1234",
                            style: AppStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                              size: AppDimensions.fontSize13(context),
                            ),
                          ),
                        ],
                      ),
                      AppSpacer(heightPortion: .01),
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Contact Info",
                                style: AppStyle.style(
                                  context: context,
                                  color: AppColors.black2,
                                  fontWeight: FontWeight.w300,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                              Flexible(child: Divider(indent: 10)),
                            ],
                          ),
                          AppSpacer(heightPortion: .001),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                "Anad Jain",
                                style: AppStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                              Text(
                                "7956873424",
                                style: AppStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
