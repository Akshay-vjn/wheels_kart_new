import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_select_system_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20portions/fetch_portions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

class EvSelectPostionScreen extends StatefulWidget {
  final InspectionModel inspectionModel;
  final String inspectionId;
  final String? instructionData;

  const EvSelectPostionScreen({
    super.key,
    required this.inspectionModel,
    required this.inspectionId,
    required this.instructionData,
  });

  @override
  State<EvSelectPostionScreen> createState() => _EvSelectPostionScreenState();
}

class _EvSelectPostionScreenState extends State<EvSelectPostionScreen> {
  @override
  void initState() {
    super.initState();

    context.read<FetchPortionsBloc>().add(
      OngetPostionsEvent(context: context, inspectionId: widget.inspectionId),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.instructionData != null
      // &&    widget.inspectionModel.currentStatus.isEmpty
      ) {
        showInstructions();
      }
    });
  }

  String getInstruction() {
    return """
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
          body { font-family: Arial, sans-serif; padding: 20px; }
          ul { padding-left: 20px; }
          li { margin-bottom: 10px; }
        </style>
      </head>
      <body>
        ${widget.instructionData}
      </body>
      </html>
    """;
  }

  int? selectedindx;
  String? selectedPortionId;
  @override
  Widget build(BuildContext context) {
    final currentStatus = widget.inspectionModel.currentStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Portion',
          style: AppStyle.style(
            color: AppColors.white,
            context: context,
            fontWeight: FontWeight.bold,
            size: AppDimensions.fontSize18(context),
          ),
        ),
        backgroundColor: AppColors.DEFAULT_BLUE_DARK,
        leading: customBackButton(context),
      ),
      body: BlocBuilder<FetchPortionsBloc, FetchPortionsState>(
        builder: (context, state) {
          switch (state) {
            case LoadingFetchPortionsState():
              {
                return AppLoadingIndicator();
              }
            case SuccessFetchPortionsState():
              {
                final allZero = widget.inspectionModel.currentStatus.every(
                  (element) => element.balance == 0,
                );
                return Column(
                  children: [
                    Expanded(
                      child: AppMargin(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            CurrentStatus current =
                                currentStatus
                                    .where(
                                      (element) =>
                                          element.portionId ==
                                          state.listOfPortios[index].portionId,
                                    )
                                    .toList()
                                    .first;

                            return EvAppCustomeSelctionButton(
                              fillColor:
                                  current.balance == 0
                                      ? AppColors.kGreen.withAlpha(70)
                                      : null,
                              isButtonBorderView: true,
                              currentIndex: index,
                              onTap: () {
                                setState(() {
                                  selectedindx = index;
                                  selectedPortionId =
                                      state.listOfPortios[index].portionId;
                                });
                                if (selectedPortionId != null) {
                                  Navigator.of(context).push(
                                    AppRoutes.createRoute(
                                      EvSelectSystemScreen(
                                        current: current,
                                        portionName:
                                            state
                                                .listOfPortios[index]
                                                .portionName,
                                        inspectionID: widget.inspectionId,
                                        portionId: selectedPortionId!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              selectedButtonIndex: selectedindx,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingSize10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (current.balance == 0)
                                      Icon(
                                        Icons.check_circle_outline_outlined,
                                        color: AppColors.kGreen,
                                      ),

                                    Text(
                                      state.listOfPortios[index].portionName,
                                      style: AppStyle.style(
                                        color:
                                            current.balance == 0
                                                ? AppColors.kGreen
                                                : null,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                      ),
                                    ),
                                    Text(
                                      style: AppStyle.style(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            current.balance == 0
                                                ? AppColors.kGreen
                                                : AppColors.grey,
                                        context: context,
                                      ),
                                      '${current.completed.toString()}/${current.totalQuestions.toString()}',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          itemCount: state.listOfPortios.length,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,
                            color: AppColors.DARK_PRIMARY.withAlpha(50),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AppSpacer(heightPortion: .02),
                          AppMargin(
                            child: EvAppCustomButton(
                              isSquare: false,
                              bgColor: allZero ? null : Color(0xFFC2C3C5),
                              onTap: () {
                                if (allZero) {}
                              },
                              title: "SUBMIT",
                            ),
                          ),
                          AppSpacer(heightPortion: .02),
                        ],
                      ),
                    ),
                  ],
                );
              }
            case ErrorFetchPortionsState():
              {
                return AppEmptyText(text: state.errorMessage);
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

  showInstructions() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,

      shape: ContinuousRectangleBorder(),
      context: context,
      // enableDrag: true,
      backgroundColor: AppColors.white,
      builder:
          (context) => AppMargin(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  child: Text(
                    'Follow the Instruction',
                    style: AppStyle.style(
                      context: context,
                      size: AppDimensions.fontSize17(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Html(
                  data: getInstruction(),
                  style: {
                    "ul": Style(
                      fontSize: FontSize.large,
                      textDecorationStyle: TextDecorationStyle.dotted,
                    ),
                    "li": Style(
                      fontSize: FontSize.large,
                      textDecorationStyle: TextDecorationStyle.dotted,
                    ),
                    "table": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: HtmlPaddings.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: HtmlPaddings.all(6),
                      alignment: Alignment.topLeft,
                    ),
                    'h5': Style(
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to inspection screen
                  },

                  label: Text(
                    'Continue',
                    style: AppStyle.style(
                      context: context,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.DEFAULT_BLUE_DARK,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // EvAppCustomButton(
                //   bgColor: AppColors.DEFAULT_BLUE_DARK,
                //   isSquare: true,
                //   title: 'Continue',
                //   onTap: () {

                //   },
                // ),
                AppSpacer(heightPortion: .05),
              ],
            ),
          ),
    );
  }
}
