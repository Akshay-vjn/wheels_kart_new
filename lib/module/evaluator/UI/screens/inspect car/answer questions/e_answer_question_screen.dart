import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/build_question_tile.dart';

import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspection%20prefilled/fetch_prefill_data_of_inspection_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';

class EvAnswerQuestionScreen extends StatefulWidget {
  final String portionId;
  final String systemId;
  final String portionName;
  final String systemName;
  final String inspectionId;

  const EvAnswerQuestionScreen({
    super.key,
    required this.portionId,
    required this.systemId,
    required this.portionName,
    required this.systemName,
    required this.inspectionId,
  });

  @override
  State<EvAnswerQuestionScreen> createState() => _EvAnswerQuestionScreenState();
}

class _EvAnswerQuestionScreenState extends State<EvAnswerQuestionScreen> {
  List<Map<String, dynamic>> helperVariables = [];

  @override
  void initState() {
    super.initState();
    context.read<FetchQuestionsBloc>().add(
      OnCallQuestinApiRepoEvent(
        inspectionId: widget.inspectionId,
        context: context,
        portionId: widget.portionId,
        systemId: widget.systemId,
      ),
    );
    context.read<EvFetchPrefillDataOfInspectionBloc>().add(
      OnFetchTheDataForPreFill(
        inspectionId: widget.inspectionId,
        context: context,
        portionId: widget.portionId,
        systemId: widget.systemId,
      ),
    );

    log("portion id ${widget.portionId}");
    log("inspection Id ${widget.inspectionId}");
    log("system id ${widget.systemId}");
  }

  bool initializeState = false;

  @override
  void dispose() {
    super.dispose();
  }

  bool calledBackFunction = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: customBackButton(
            context,
            onPressed: () {
              if (!calledBackFunction) {
                calledBackFunction = true;
                context.read<FetchInspectionsBloc>().add(
                  OnGetInspectionList(
                    context: context,
                    inspetionListType: 'ASSIGNED',
                  ),
                );
              }

              Navigator.of(context).pop();
            },
          ),
          title: Text(
            '${widget.portionName}/${widget.systemName}',
            style: AppStyle.style(
              context: context,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
            ),
          ),
          backgroundColor: AppColors.DEFAULT_BLUE_DARK,
        ),
        body: BlocConsumer<FetchQuestionsBloc, FetchQuestionsState>(
          listener: (context, state) {
            if (state is SuccessFetchQuestionsState) {
              if (!initializeState) {
                initializeState = true;
                context.read<EvSubmitAnswerControllerCubit>().init(
                  state.listOfQuestions.length,
                );
              }
            }
          },
          builder: (context, state) {
            switch (state) {
              case LoadingFetchQuestionsState():
                {
                  return AppLoadingIndicator();
                }
              case SuccessFetchQuestionsState():
                {
                  return BlocBuilder<
                    EvFetchPrefillDataOfInspectionBloc,
                    EvFetchPrefillDataOfInspectionState
                  >(
                    builder: (context, prefillState) {
                      switch (prefillState) {
                        case EvFetchPrefillDataOfInspectionLoadingState():
                          {
                            return AppLoadingIndicator();
                          }
                        case EvFetchPrefillDataOfInspectionErrorState():
                          {
                            return AppEmptyText(
                              text: "Error while fetching prefill data",
                            );
                          }
                        case EvFetchPrefillDataOfInspectionSuccessState():
                          {
                            return Scrollbar(
                              thickness: 8.0, // Adjust thickness
                              radius: Radius.circular(10), // Make it rounded
                              child: SingleChildScrollView(
                                child: Column(
                                  children:
                                      state.listOfQuestions.asMap().entries.map(
                                        (e) {
                                          final index = e.key;
                                          final currentQuestion =
                                              state.listOfQuestions[index];

                                          final prefills =
                                              prefillState
                                                  .prefillInspectionDatas
                                                  .where(
                                                    (element) =>
                                                        element.questionId ==
                                                        currentQuestion
                                                            .questionId,
                                                  )
                                                  .toList();

                                          return BuildQuestionTile(
                                            question: currentQuestion,
                                            prefillModel:
                                                prefills.isNotEmpty
                                                    ? prefills.first
                                                    : null,
                                            index: index,
                                          );
                                        },
                                      ).toList(),
                                ),
                              ),
                            );
                          }
                        default:
                          {
                            return SizedBox();
                          }
                      }
                    },
                  );
                }
              case ErrorFetchQuestionsState():
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
      ),
    );
  }

  
}
