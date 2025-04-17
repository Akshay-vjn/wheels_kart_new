import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
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
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_prefill_model.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
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
                                    state.listOfQuestions.asMap().entries.map((
                                      e,
                                    ) {
                                      final index = e.key;
                                      final currentQuestion =
                                          state.listOfQuestions[index];

                                      helperVariables.add({
                                        "commentController":
                                            TextEditingController(),
                                        "commentKey": GlobalKey<FormState>(),
                                        "descriptiveController":
                                            TextEditingController(),
                                        "descriptiveKey":
                                            GlobalKey<FormState>(),
                                        "listOfImages": <Uint8List>[],
                                      });
                                      final prefills =
                                          prefillState.prefillInspectionDatas
                                              .where(
                                                (element) =>
                                                    element.questionId ==
                                                    currentQuestion.questionId,
                                              )
                                              .toList();
                                      // if (prefills.isNotEmpty) {
                                      //   Functions.onPrefillTheQuestion(
                                      //     context,
                                      //     index,
                                      //     prefills.first,
                                      //   );
                                      // }
                                      return BuildQuestionTile(
                                        helperVariables: helperVariables,
                                        question: currentQuestion,
                                        prefillModel:
                                            prefills.isNotEmpty
                                                ? prefills.first
                                                : null,
                                        index: index,
                                      );
                                    }).toList(),
                              ),
                            ),
                            // child: ListView.separated(
                            //   separatorBuilder: (context, index) {
                            //     return Container(
                            //       height: 10,
                            //       color: AppColors.black,
                            //     );
                            //   },
                            //   itemBuilder: (context, index) {
                            //     final currentQuestion =
                            //         state.listOfQuestions[index];

                            //     helperVariables.add({
                            //       "commentController": TextEditingController(),
                            //       "commentKey": GlobalKey<FormState>(),
                            //       "descriptiveController":
                            //           TextEditingController(),
                            //       "descriptiveKey": GlobalKey<FormState>(),
                            //       "listOfImages": <Uint8List>[],
                            //     });
                            //     InspectionPrefillModel? prefill;
                            //     final prefills =
                            //         prefillState.prefillInspectionDatas
                            //             .where(
                            //               (element) =>
                            //                   element.questionId ==
                            //                   currentQuestion.questionId,
                            //             )
                            //             .toList();
                            //     // if (prefills.isNotEmpty) {
                            //     //   Functions.onPrefillTheQuestion(
                            //     //     context,
                            //     //     index,
                            //     //     prefills.first,
                            //     //   );
                            //     // }
                            //     return BuildQuestionTile(
                            //       helperVariables: helperVariables,
                            //       question: currentQuestion,
                            //       prefillModel:
                            //           prefills.isNotEmpty
                            //               ? prefills.first
                            //               : null,
                            //       index: index,
                            //     );
                            //     // return prefills.isNotEmpty
                            //     //     ? BlocBuilder<
                            //     //       EvSubmitAnswerControllerCubit,
                            //     //       EvSubmitAnswerControllerState
                            //     //     >(
                            //     //       builder: (context, state) {
                            //     //         return state.isUpdateView[index]
                            //     //             ? _buildQuestionTile(
                            //     //               currentQuestion,

                            //     //               index,
                            //     //             )
                            //     //             : _buildAnswerdUi(
                            //     //               prefills.first,
                            //     //               currentQuestion,
                            //     //               index,
                            //     //             );
                            //     //       },
                            //     //     )
                            //     //     : _buildQuestionTile(
                            //     //       currentQuestion,

                            //     //       index,
                            //     //     );
                            //   },
                            //   itemCount: state.listOfQuestions.length,
                            // ),
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
    );
  }

  // Widget _buildQuestionTile(
  //   QuestionModelData question,
  //   InspectionPrefillModel? prefillModel,
  //   int index,
  // ) {
  //   return BlocBuilder<
  //     EvSubmitAnswerControllerCubit,
  //     EvSubmitAnswerControllerState
  //   >(
  //     builder: (context, state) {
  //       String? subQuestionAnswer = prefillModel?.subQuestionAnswer;
  //       String? answer = prefillModel?.answer;
  //       String? validAnswer = prefillModel?.validOption;
  //       String? inValidAnswer = prefillModel?.invalidOption;
  //       String? comment = prefillModel?.comment;
  //       final images = prefillModel?.images;

  //       final currentstate = state.questionState[index];
  //       final errorState = currentstate == SubmissionState.ERROR;
  //       final successState = currentstate == SubmissionState.SUCCESS;
  //       final loadingState = currentstate == SubmissionState.LOADING;
  //       final initialState = currentstate == SubmissionState.INITIAL;

  //       final buttonColor =
  //           initialState
  //               ? AppColors.DEFAULT_BLUE_DARK
  //               : successState
  //               ? AppColors.kGreen
  //               : errorState
  //               ? AppColors.kRed
  //               : AppColors.grey;

  //       final titleColor =
  //           initialState
  //               ? null
  //               : successState
  //               ? AppColors.kGreen.withOpacity(.1)
  //               : errorState
  //               ? AppColors.kRed.withOpacity(.1)
  //               : null;

  //       return Container(
  //         color: titleColor,
  //         padding: EdgeInsets.all(AppDimensions.paddingSize10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               question.question,
  //               style: AppStyle.style(
  //                 size: AppDimensions.fontSize18(context),
  //                 context: context,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             AppSpacer(heightPortion: .02),
  //             if (question.questionType == "MCQ") ...[
  //               _buildSubQuestionViewForMcq(index, subQuestionAnswer),
  //               _buildAnswerForMcq(index, answer),
  //               _buildValidOptionView(index, validAnswer),
  //               _buildInValidOptionView(index, inValidAnswer),
  //             ],
  //             if (question.questionType == "Descriptive") ...[
  //               _buildDescriptiveQuestion(index, answer),
  //             ],
  //             if (question.picture != "Not Required") ...[
  //               _takePictureView(
  //                 question.picture == "Required Optional" ? true : false,
  //                 index,
  //                 images,
  //               ),
  //             ],
  //             _commentBoxView(index, comment),
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child:
  //                   successState
  //                       ? Icon(
  //                         Icons.cloud_done_outlined,
  //                         size: 35,
  //                         color: AppColors.kGreen,
  //                       )
  //                       : loadingState
  //                       ? CircularProgressIndicator(strokeWidth: 2)
  //                       : ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: buttonColor,
  //                         ),
  //                         onPressed: () {
  //                           if (currentstate != SubmissionState.LOADING) {
  //                             onSubmitQuestion(context, index);
  //                           }
  //                         },
  //                         child: Text(
  //                           errorState ? "Failed" : "Save",
  //                           style: AppStyle.style(
  //                             context: context,
  //                             color: AppColors.white,
  //                           ),
  //                         ),
  //                       ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildAnswerdUi(
  //   InspectionPrefillModel prefill,
  //   QuestionModelData currentQuestion,
  //   int index,
  // ) {
  //   return BlocBuilder<
  //     EvSubmitAnswerControllerCubit,
  //     EvSubmitAnswerControllerState
  //   >(
  //     builder: (context, state) {
  //       String? subQuestionAnswer = prefill.subQuestionAnswer;
  //       String? answer = prefill.answer;
  //       String? validAnswer = prefill.validOption;
  //       String? inValidAnswer = prefill.invalidOption;
  //       String? comment = prefill.comment;
  //       final images = prefill.images;
  //       return Container(
  //         color: AppColors.DEFAULT_ORANGE.withAlpha(50),
  //         padding: EdgeInsets.all(10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Text(currentQuestion.questionId),
  //             if (images.isNotEmpty) ...[
  //               SizedBox(
  //                 width: w(context),
  //                 child: GridView.builder(
  //                   physics: NeverScrollableScrollPhysics(),
  //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     crossAxisSpacing: 20,
  //                     mainAxisSpacing: 20,
  //                   ),
  //                   shrinkWrap: true,
  //                   itemCount: images.length >= 2 ? 2 : images.length,
  //                   itemBuilder: (context, index) {
  //                     return Container(
  //                       width: w(context) * .23,
  //                       height: h(context) * .1,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(color: AppColors.grey),
  //                         // borderRadius:
  //                         //     BorderRadius.circular(AppDimensions.radiusSize10),
  //                         color: AppColors.white,
  //                         image: DecorationImage(
  //                           fit: BoxFit.fill,
  //                           image: CachedNetworkImageProvider(
  //                             images[index].image,
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: TextButton(onPressed: () {}, child: Text("See All")),
  //               ),
  //             ],
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     currentQuestion.question,
  //                     style: AppStyle.style(
  //                       size: AppDimensions.fontSize24(context),
  //                       context: context,
  //                       color: AppColors.black,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //                 if (currentQuestion.questionType == "MCQ" &&
  //                     subQuestionAnswer != null &&
  //                     currentQuestion.subQuestionTitle == null) ...[
  //                   Text("($subQuestionAnswer)"),
  //                 ],
  //                 if (currentQuestion.questionType == "MCQ" &&
  //                     answer != null) ...[
  //                   // selected option
  //                   CircleAvatar(
  //                     backgroundColor:
  //                         answer == "Yes" || answer == "Ok"
  //                             ? AppColors.kGreen
  //                             : AppColors.kRed,
  //                     radius: 30,
  //                     child: Text(
  //                       answer.toUpperCase(),
  //                       style: AppStyle.style(
  //                         context: context,
  //                         color: AppColors.white,
  //                         size: AppDimensions.fontSize16(context),
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ],
  //             ),

  //             // ----------MCQ
  //             if (currentQuestion.questionType == "MCQ") ...[
  //               // Subquestion
  //               if (subQuestionAnswer != null) ...[
  //                 AppSpacer(heightPortion: .01),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Container(
  //                         padding: EdgeInsets.all(10),
  //                         decoration: BoxDecoration(
  //                           color: AppColors.FILL_COLOR,
  //                           border: Border.all(color: AppColors.grey),
  //                         ),
  //                         child: Text(
  //                           currentQuestion.subQuestionTitle ?? '',
  //                           style: AppStyle.style(
  //                             context: context,
  //                             fontWeight: FontWeight.w600,
  //                             size: AppDimensions.fontSize17(context),
  //                           ),
  //                         ),
  //                       ),
  //                     ),

  //                     Container(
  //                       padding: EdgeInsets.all(10),
  //                       decoration: BoxDecoration(
  //                         color: AppColors.kAppSecondaryColor,
  //                         border: Border.all(
  //                           color: AppColors.kAppSecondaryColor,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         subQuestionAnswer,
  //                         style: AppStyle.style(
  //                           color: AppColors.white,
  //                           context: context,
  //                           fontWeight: FontWeight.w600,
  //                           size: AppDimensions.fontSize17(context),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 AppSpacer(heightPortion: .01),
  //               ],
  //               AppSpacer(heightPortion: .01),
  //               Visibility(
  //                 visible: validAnswer != null || inValidAnswer != null,
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   width: w(context),
  //                   decoration: BoxDecoration(
  //                     color:
  //                         answer == "Yes" || answer == "Ok"
  //                             ? AppColors.kGreen.withAlpha(60)
  //                             : AppColors.kRed.withAlpha(60),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // if selected valid
  //                       if (validAnswer != null)
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               currentQuestion.validOptionsTitle.isNotEmpty
  //                                   ? currentQuestion.validOptionsTitle
  //                                   : 'Selected answers :-',
  //                               style: AppStyle.style(
  //                                 context: context,
  //                                 color: AppColors.DARK_SECONDARY,
  //                                 fontWeight: FontWeight.w600,
  //                                 size: AppDimensions.fontSize17(context),
  //                               ),
  //                             ),
  //                             AppSpacer(heightPortion: .01),
  //                             Padding(
  //                               padding: EdgeInsets.only(left: 10),
  //                               child: Text(
  //                                 validAnswer,
  //                                 style: AppStyle.style(
  //                                   context: context,
  //                                   color: AppColors.kGreen,
  //                                   fontWeight: FontWeight.w600,
  //                                   size: AppDimensions.fontSize17(context),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),

  //                       // if selected inValid
  //                       if (inValidAnswer != null)
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               currentQuestion.validOptionsTitle.isNotEmpty
  //                                   ? currentQuestion.invalidOptionsTitle
  //                                   : 'Selected answers :-',
  //                               style: AppStyle.style(
  //                                 context: context,
  //                                 color: AppColors.DARK_SECONDARY,
  //                                 fontWeight: FontWeight.w600,
  //                                 size: AppDimensions.fontSize17(context),
  //                               ),
  //                             ),
  //                             AppSpacer(heightPortion: .01),
  //                             Padding(
  //                               padding: EdgeInsets.only(left: 10),
  //                               child: Text(
  //                                 inValidAnswer,
  //                                 style: AppStyle.style(
  //                                   context: context,
  //                                   color: AppColors.kRed,
  //                                   fontWeight: FontWeight.w600,
  //                                   size: AppDimensions.fontSize17(context),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //             // Descriptive
  //             if (currentQuestion.questionType == "Descriptive" &&
  //                 answer != null) ...[
  //               AppSpacer(heightPortion: .01),
  //               Container(
  //                 width: w(context),
  //                 padding: EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: AppColors.BORDER_COLOR),
  //                 ),
  //                 child: Text(
  //                   answer,
  //                   style: AppStyle.style(
  //                     context: context,
  //                     color: AppColors.DEFAULT_BLUE_GREY,
  //                     fontWeight: FontWeight.w600,
  //                     size: 18,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //             if (comment != null) ...[
  //               AppSpacer(heightPortion: .01),
  //               Container(
  //                 width: w(context),
  //                 padding: EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: AppColors.BORDER_COLOR),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Additional Comment :-",
  //                       style: AppStyle.style(
  //                         context: context,
  //                         color: AppColors.DEFAULT_BLUE_GREY,
  //                         fontWeight: FontWeight.w600,
  //                         size: 18,
  //                       ),
  //                     ),
  //                     Text(
  //                       comment,
  //                       style: AppStyle.style(
  //                         context: context,
  //                         color: AppColors.BORDER_COLOR,
  //                         fontWeight: FontWeight.w400,
  //                         size: 15,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //             AppSpacer(heightPortion: .01),
  //             Align(
  //               alignment: Alignment.bottomRight,
  //               child: ElevatedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.DARK_SECONDARY,
  //                 ),
  //                 onPressed: () {
  //                   context
  //                       .read<EvSubmitAnswerControllerCubit>()
  //                       .changeToUpdateView(index);
  //                 },
  //                 icon: Icon(SolarIconsOutline.pen2, color: AppColors.white),
  //                 label: Text(
  //                   "Edit",
  //                   style: AppStyle.style(
  //                     context: context,
  //                     color: AppColors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),

  //             // AppSpacer(heightPortion: .02),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
