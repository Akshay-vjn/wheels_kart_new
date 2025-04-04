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
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_select_system_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20portions/fetch_portions_bloc.dart';

class EvSelectPostionScreen extends StatefulWidget {
  final String inspectionId;
  final String? instructionData;

  const EvSelectPostionScreen({
    super.key,
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

    context.read<FetchPortionsBloc>().add(OngetPostionsEvent(context: context));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.instructionData != null) {
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
  String? selectedPostionID;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Portion',
          style: AppStyle.style(
            color: AppColors.kWhite,
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
                return AppMargin(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return EvAppCustomeSelctionButton(
                        isButtonBorderView: true,
                        currentIndex: index,
                        onTap: () {
                          setState(() {
                            selectedindx = index;
                            selectedPostionID =
                                state.listOfPortios[index].portionId;
                          });
                          if (selectedPostionID != null) {
                            Navigator.of(context).push(
                              AppRoutes.createRoute(
                                EvSelectSystemScreen(
                                  postionName:
                                      state.listOfPortios[index].portionName,
                                  inspectionID: widget.inspectionId,
                                  postionId: selectedPostionID!,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (index == 0 || index == 1)
                                  ? Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: AppColors.DEFAULT_BLUE_GREY,
                                  )
                                  : SizedBox(),

                              Text(
                                state.listOfPortios[index].portionName,
                                style: AppStyle.style(
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                ),
                              ),
                              SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) => AppSpacer(heightPortion: .005),
                    itemCount: state.listOfPortios.length,
                  ),
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
      backgroundColor: AppColors.kWhite,
      builder:
          (context) => AppMargin(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Follow the Instruction',
                  style: AppStyle.style(
                    context: context,
                    color: AppColors.kBlack,
                    fontWeight: FontWeight.bold,
                    size: AppDimensions.fontSize24(context),
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
                EvAppCustomButton(
                  bgColor: AppColors.DEFAULT_BLUE_DARK,
                  isSquare: true,
                  title: 'Continue',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppSpacer(heightPortion: .05),
              ],
            ),
          ),
    );
  }
}
