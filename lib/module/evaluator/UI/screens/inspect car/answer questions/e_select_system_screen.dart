import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_answer_question_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20systems/fetch_systems_bloc.dart';

class EvSelectSystemScreen extends StatefulWidget {
  final String postionId;
  final String inspectionID;
  final String postionName;

  const EvSelectSystemScreen({
    super.key,
    required this.postionId,
    required this.inspectionID,
    required this.postionName,
  });

  @override
  State<EvSelectSystemScreen> createState() => _EvSelectSystemScreenState();
}

class _EvSelectSystemScreenState extends State<EvSelectSystemScreen> {
  int? selectedindx;
  String? selectedSystemId;

  @override
  void initState() {
    super.initState();
    context.read<FetchSystemsBloc>().add(
      OnFetchSystemsOfPortions(context: context, portionId: widget.postionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select System',
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
      body: BlocBuilder<FetchSystemsBloc, FetchSystemsState>(
        builder: (context, state) {
          switch (state) {
            case LoadingFetchSystemsState():
              {
                return AppLoadingIndicator();
              }
            case SuccessFetchSystemsState():
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
                            selectedSystemId =
                                state.listOfSystemes[index].systemId;
                          });
                          if (selectedSystemId != null) {
                            Navigator.of(context).push(
                              AppRoutes.createRoute(
                                EvAnswerQuestionScreen(
                                  portionName: widget.postionName,
                                  systemName:
                                      state.listOfSystemes[index].systemName,
                                  portionId: widget.postionId,
                                  systemId: selectedSystemId!,
                                  inspectionId: widget.inspectionID,
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
                              // Icon(
                              //   Icons.check_circle_outline_outlined,
                              //   color: AppColors.DEFAULT_BLUE_GREY,
                              // ),
                              SizedBox(),

                              Text(
                                state.listOfSystemes[index].systemName,
                                style: AppStyle.style(
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                ),
                              ),
                              Text(
                                "9/10",
                                style: AppStyle.style(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kGrey,
                                  size: AppDimensions.fontSize17(context),
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) => AppSpacer(heightPortion: .005),
                    itemCount: state.listOfSystemes.length,
                  ),
                );
              }
            case ErrorFetchSystemsState():
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
}
