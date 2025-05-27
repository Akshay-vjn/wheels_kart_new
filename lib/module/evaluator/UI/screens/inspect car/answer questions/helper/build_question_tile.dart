import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/paint/dash_border.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/functions.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/widget_answer_selection_button.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/widget_build_check_box.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_prefill_model.dart';
import 'package:wheels_kart/module/evaluator/data/model/question_model_data.dart';
import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';

class BuildQuestionTile extends StatefulWidget {
  final QuestionModelData question;
  final InspectionPrefillModel? prefillModel;
  final int index;
  const BuildQuestionTile({
    super.key,
    required this.question,
    this.prefillModel,
    required this.index,
  });

  @override
  State<BuildQuestionTile> createState() => _BuildQuestionTileState();
}

class _BuildQuestionTileState extends State<BuildQuestionTile> {
  Map<String, dynamic> helperVariable = {
    "commentController": TextEditingController(),
    "commentKey": GlobalKey<FormState>(),
    "descriptiveController": TextEditingController(),
    "descriptiveKey": GlobalKey<FormState>(),
    "listOfImages": <Uint8List>[],
  };

  @override
  void initState() {
    if (widget.prefillModel != null) {
      Functions.onPrefillTheQuestion(
        context,
        widget.index,
        widget.prefillModel!,
      );

      if (widget.prefillModel!.comment != null) {
        helperVariable['commentController'].text = widget.prefillModel!.comment;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    } else {
      isLoadingImage = false;
    }

    super.initState();
  }

  bool isLoadingImage = true;
  void _init() async {
    final images = widget.prefillModel!.images;
    if (images.isNotEmpty) {
      List<Uint8List?> prefillImages = [];

      for (var image in images) {
        final bytes = await Functions.convartNetworkImageToUni8ListFormate(
          image.image,
        );
        prefillImages.add(bytes);
      }
      helperVariable['listOfImages'] = prefillImages;

      if (!mounted) return;
    }
    isLoadingImage = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      EvSubmitAnswerControllerCubit,
      EvSubmitAnswerControllerState
    >(
      builder: (context, state) {
        // String? subQuestionAnswer = widget.prefillModel?.subQuestionAnswer;
        // String? answer = widget.prefillModel?.answer;
        // String? validAnswer = widget.prefillModel?.validOption;
        // String? inValidAnswer = widget.prefillModel?.invalidOption;
        // String? comment = widget.prefillModel?.comment;
        // final images = widget.prefillModel?.images;
        // final submissionState =
        //     BlocProvider.of<FetchQuestionsBloc>(context).state;
        final currentstate = state.questionState[widget.index];

        final errorState = currentstate == SubmissionState.ERROR;
        final successState = currentstate == SubmissionState.SUCCESS;
        final loadingState = currentstate == SubmissionState.LOADING;
        final initialState = currentstate == SubmissionState.INITIAL;

        final buttonColor =
            initialState
                ? AppColors.DEFAULT_BLUE_DARK
                : successState
                ? AppColors.kGreen
                : errorState
                ? AppColors.kRed
                : AppColors.grey;

        final titleColor =
            initialState
                ? null
                : successState
                ? AppColors.kGreen.withOpacity(.1)
                : errorState
                ? AppColors.kRed.withOpacity(.1)
                : null;

        return Column(
          children: [
            Container(
              color: titleColor,
              padding: EdgeInsets.all(AppDimensions.paddingSize10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.question,
                    style: AppStyle.style(
                      size: AppDimensions.fontSize18(context),
                      context: context,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacer(heightPortion: .02),
                  if (widget.question.questionType == "MCQ") ...[
                    _buildSubQuestionViewForMcq(widget.index),
                    _buildAnswerForMcq(widget.index),
                    _buildValidOptionView(widget.index),
                    _buildInValidOptionView(widget.index),
                  ],
                  if (widget.question.questionType == "Descriptive") ...[
                    _buildDescriptiveQuestion(widget.index),
                  ],
                  if (widget.question.picture != "Not Required") ...[
                    Builder(
                      builder: (context) {
                        // This condition is NEW and this for verifying the selected is valid answer and image is optional .
                        // for the invalid answer have only
                        final currentState =
                            BlocProvider.of<FetchQuestionsBloc>(context).state;
                        if (currentState is SuccessFetchQuestionsState) {
                          final question =
                              currentState.listOfQuestions[widget.index];
                          final uploadData =
                              currentState.listOfUploads[widget.index];
                          final isSelectedInValid =
                              question.invalidAnswers == uploadData.answer;
                          return _takePictureView(
                            !isSelectedInValid
                                ? true
                                : widget.question.picture == "Required Optional"
                                ? true
                                : false,
                            widget.index,
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                  _commentBoxView(widget.index),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        successState
                            ? Icon(
                              Icons.cloud_done_outlined,
                              size: 35,
                              color: AppColors.kGreen,
                            )
                            : loadingState
                            ? CircularProgressIndicator(strokeWidth: 2)
                            : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                              ),
                              onPressed: () {
                                if (currentstate != SubmissionState.LOADING) {
                                  onSubmitQuestionEachQuestion(
                                    context,
                                    widget.index,
                                  );
                                }
                              },
                              child: Text(
                                errorState ? "Failed" : "Save",
                                style: AppStyle.style(
                                  context: context,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
            Container(height: 10, color: AppColors.DEFAULT_BLUE_DARK),
          ],
        );
      },
    );
  }

  Widget _buildSubQuestionViewForMcq(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final subQuestions = question.subQuestionOptions;
      return Visibility(
        visible: question.subQuestionOptions.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSize5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.subQuestionTitle ?? '',
                style: AppStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize17(context),
                ),
              ),
              AppSpacer(heightPortion: .01),
              Row(
                children:
                    subQuestions
                        .asMap()
                        .entries
                        .map(
                          (e) => BlocBuilder<
                            EvSubmitAnswerControllerCubit,
                            EvSubmitAnswerControllerState
                          >(
                            builder: (context, state) {
                              return BuildAnswerSelectionButton(
                                isOutlined: true,
                                isSelected:
                                    // (answer != null &&
                                    //         !state.canUpdate[questionIndex])
                                    //     ? answer == e.value
                                    //     :
                                    (currentIndexVariables.subQuestionAnswer !=
                                        null) &&
                                    (currentIndexVariables.subQuestionAnswer ==
                                        e.value),
                                title: e.value,
                                activeColor: AppColors.DEFAULT_BLUE_DARK,
                                inActiveColor: AppColors.grey.withOpacity(.4),
                                onTap: () {
                                  // context
                                  //     .read<EvSubmitAnswerControllerCubit>()
                                  //     .changeToUpdateView(questionIndex);
                                  Functions.onSelectSubQuestion(
                                    context,
                                    questionIndex,
                                    e.value,
                                  );
                                },
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildAnswerForMcq(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final answers = question.answers;
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSize5,
        ),
        child: Row(
          children:
              answers
                  .asMap()
                  .entries
                  .map(
                    (e) => BlocBuilder<
                      EvSubmitAnswerControllerCubit,
                      EvSubmitAnswerControllerState
                    >(
                      builder: (context, state) {
                        return BuildAnswerSelectionButton(
                          isSelected:
                              // (answer != null &&
                              //         !state.canUpdate[questionIndex])
                              //     ? answer == e.value
                              //     :
                              currentIndexVariables.answer != null &&
                              currentIndexVariables.answer == e.value,
                          title: e.value,
                          activeColor: AppColors.black,
                          inActiveColor: AppColors.white,
                          onTap: () {
                            // context
                            //     .read<EvSubmitAnswerControllerCubit>()
                            //     .changeToUpdateView(questionIndex);
                            Functions.onSelectAnswertion(
                              context,
                              questionIndex,
                              e.value,
                            );
                          },
                        );
                      },
                    ),
                  )
                  .toList(),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildValidOptionView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final validOptions = question.validOptions;
      // List<String> prefills = [];
      // if (answer != null) {
      //   prefills = answer.split(',');
      //   prefills.map((e) {
      //     Functions.onSelectValidOption(context, questionIndex, e);
      //   });
      // }

      return Visibility(
        visible:
            (currentIndexVariables.answer != null) &&
            (currentIndexVariables.answer == question.answers.first &&
                question.validOptions.isNotEmpty),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSize5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacer(heightPortion: .01),
              Text(
                question.validOptionsTitle.isNotEmpty
                    ? question.validOptionsTitle
                    : 'Please choose the option',
                style: AppStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize17(context),
                ),
              ),
              AppSpacer(heightPortion: .01),
              Column(
                children:
                    validOptions
                        .asMap()
                        .entries
                        .map(
                          (e) => BuildCheckBox(
                            isSelected:
                                currentIndexVariables.validOption == null
                                    ? false
                                    : currentIndexVariables.validOption!
                                        .contains(e.value),
                            title: e.value,
                            onChanged: (p0) {
                              Functions.onSelectValidOption(
                                context,
                                questionIndex,
                                e.value,
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildInValidOptionView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final inValidOptions = question.invalidOptions;
      // List<String> prefills = [];
      // if (answer != null) {
      //   prefills = answer.split(',');
      //   prefills.map((e) {
      //     Functions.onSelectInValidOption(context, questionIndex, e);
      //   });
      // }
      return Visibility(
        visible:
            (currentIndexVariables.answer != null) &&
            currentIndexVariables.answer == question.invalidAnswers,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSize5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacer(heightPortion: .01),
              Text(
                question.validOptionsTitle.isNotEmpty
                    ? question.invalidOptionsTitle
                    : 'Please choose the option',
                style: AppStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize17(context),
                ),
              ),
              AppSpacer(heightPortion: .01),
              Column(
                children:
                    inValidOptions
                        .asMap()
                        .entries
                        .map(
                          (e) => BuildCheckBox(
                            isSelected:
                                currentIndexVariables.invalidOption == null
                                    ? false
                                    : currentIndexVariables.invalidOption!
                                        .contains(e.value),
                            title: e.value,
                            onChanged: (p0) {
                              Functions.onSelectInValidOption(
                                context,
                                questionIndex,
                                e.value,
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  //-----------------------------TEXTFIELD-------------------------------------------
  Widget _commentBoxView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final commentTitle = question.commentsTitle;
      final invalidAnswer = question.invalidAnswers;

      final selectedMainOption =
          currentState.listOfUploads[questionIndex].answer;
      return Form(
        key: helperVariable["commentKey"],
        child: Column(
          children: [
            AppSpacer(heightPortion: .02),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    text: commentTitle.isEmpty ? 'Comment' : commentTitle,
                    style: AppStyle.style(
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: AppDimensions.fontSize17(context),
                    ),
                    children: [
                      TextSpan(
                        text:
                            commentTitle.isNotEmpty ||
                                    invalidAnswer == selectedMainOption
                                ? " * "
                                : "",
                        style: AppStyle.style(
                          context: context,
                          color: AppColors.kRed,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Divider(thickness: .2, endIndent: 10, indent: 10),
                ),
              ],
            ),
            EvAppCustomTextfield(
              onChanged: (p0) {
                final state =
                    BlocProvider.of<FetchQuestionsBloc>(context).state;
                if (state is SuccessFetchQuestionsState) {
                  context.read<EvSubmitAnswerControllerCubit>().resetState(
                    questionIndex,
                  );
                }
              },
              focusColor: AppColors.black,
              fontWeght: FontWeight.normal,
              maxLine: 3,
              validator: (value) {
                if (invalidAnswer == selectedMainOption) {
                  if (value!.isEmpty) {
                    return 'Enter the comment';
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              },
              controller: helperVariable["commentController"],
              hintText:
                  commentTitle.isEmpty
                      ? 'Enter the comment in any...'
                      : commentTitle,
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildDescriptiveQuestion(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      return Form(
        key: helperVariable["descriptiveKey"],
        child: Column(
          children: [
            EvAppCustomTextfield(
              onChanged: (p0) {
                final state =
                    BlocProvider.of<FetchQuestionsBloc>(context).state;
                if (state is SuccessFetchQuestionsState) {
                  context.read<EvSubmitAnswerControllerCubit>().resetState(
                    questionIndex,
                  );
                }
              },
              focusColor: AppColors.black,
              fontWeght: FontWeight.w500,
              keyBoardType: getKeyboardType(question.keyboardType),
              controller: helperVariable['descriptiveController'],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This filed is required';
                } else {
                  return null;
                }
              },
              hintText: 'Enter the value here',
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  TextInputType getKeyboardType(String keybordType) {
    switch (keybordType) {
      case 'Float':
        {
          return TextInputType.number;
        }
      case 'Integer':
        {
          return TextInputType.number;
        }
      default:
        {
          return TextInputType.name;
        }
    }
  }

  //--------------------------IMAGE
  Widget _takePictureView(bool isOptional, int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final listOfImages = helperVariable["listOfImages"] as List;
      return Column(
        children: [
          AppSpacer(heightPortion: .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Upload Pictures',
                  style: AppStyle.style(
                    context: context,
                    fontWeight: FontWeight.w600,
                    size: AppDimensions.fontSize17(context),
                  ),
                  children: [
                    TextSpan(
                      text: isOptional ? "" : " * ",
                      style: AppStyle.style(
                        context: context,
                        color: AppColors.kRed,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Divider(thickness: .2, endIndent: 10, indent: 10),
              ),
            ],
          ),
          AppSpacer(heightPortion: .02),
          SizedBox(
            width: w(context),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              shrinkWrap: true,
              itemCount:
                  isLoadingImage
                      ? listOfImages.length + 2
                      : listOfImages.length + 1,
              itemBuilder: (context, index) {
                if (isLoadingImage && index == 0) {
                  return AppLoadingIndicator();
                }
                if (index ==
                    (isLoadingImage
                        ? listOfImages.length + 1
                        : listOfImages.length)) {
                  return InkWell(
                    onTap: () {
                      _openCamera(questionIndex);
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 70, color: AppColors.grey),
                          AppSpacer(heightPortion: .01),
                          Text(
                            listOfImages.isNotEmpty
                                ? 'Add More'
                                : 'Add Picture',
                            style: AppStyle.style(
                              context: context,
                              color: AppColors.grey,
                              fontWeight: FontWeight.bold,
                              size: AppDimensions.fontSize12(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final imageIndex = isLoadingImage ? index - 1 : index;
                return Stack(
                  children: [
                    Container(
                      // width: w(context) * .23,
                      // height: h(context) * .1,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        // borderRadius:
                        //     BorderRadius.circular(AppDimensions.radiusSize10),
                        color: AppColors.white,
                        image:
                            listOfImages[imageIndex] == null
                                ? null
                                : DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(listOfImages[imageIndex]),
                                ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          try {
                            log("Remove");
                            listOfImages.removeWhere(
                              (element) => element == listOfImages[imageIndex],
                            );
                            Functions.resetButtonStatus(context, questionIndex);
                            // setState(() {});
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 18, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  void _openCamera(int questionIndex) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final listOfImages = helperVariable["listOfImages"];
      final imagepicker = ImagePicker();
      final pickedXfile = await imagepicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedXfile != null) {
        final bytes = await pickedXfile.readAsBytes();

        setState(() {
          listOfImages.add(bytes);
        });
      }

      Functions.resetButtonStatus(context, questionIndex);
    }
  }

  void onSubmitQuestionEachQuestion(BuildContext context, int index) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    final descriptiveKey =
        helperVariable['descriptiveKey'] as GlobalKey<FormState>;

    final descriptiveController =
        helperVariable['descriptiveController'] as TextEditingController;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[index];
      final uploadData = currentState.listOfUploads[index];
      final isMcq = question.questionType == "MCQ";

      final isSelectedInValid = question.invalidAnswers == uploadData.answer;
      final isInValidHaveOptions = question.invalidOptions.isNotEmpty;
      final isValidHaveOptions = question.validOptions.isNotEmpty;
      switch (isMcq) {
        case true:
          {
            if (uploadData.answer != null) {
              // ---------------------------------SELECTED INVALID  --------------
              if (isSelectedInValid) {
                if (isInValidHaveOptions) {
                  if (uploadData.invalidOption != null) {
                    checkCommentAndImage(index, question, uploadData, true);
                  } else {
                    // show Error Message : Select atleast on option
                    // Completed
                    _showMessage('Select atleast one option!');
                  }
                } else {
                  checkCommentAndImage(index, question, uploadData, true);
                }
                //------------------------< SELECTED VALID  >--------------------------------------------------
              } else {
                if (isValidHaveOptions) {
                  if (uploadData.validOption != null) {
                    checkCommentAndImage(index, question, uploadData, false);
                  } else {
                    // show Error Message : Select atleast on option
                    //Completed
                    _showMessage("Select atleast one option");
                  }
                } else {
                  checkCommentAndImage(index, question, uploadData, false);
                }
              }
            } else {
              //---show Error : Select the Main Option
              _showMessage("Please choose the answer");
              // Completed
            }
          }
        case false:
          {
            if (descriptiveKey.currentState!.validate()) {
              Functions.onFillDescriptiveAnswer(
                context,
                index,
                descriptiveController.text,
              );
              checkCommentAndImage(index, question, uploadData, false);
            }
          }
      }
    }
  }

  // void onSubmitQuestionAllQuestion(BuildContext context) {
  //   final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

  //   final descriptiveKey =
  //       helperVariable['descriptiveKey'] as GlobalKey<FormState>;

  //   final descriptiveController =
  //       helperVariable['descriptiveController'] as TextEditingController;

  //   if (currentState is SuccessFetchQuestionsState) {
  //     final questions = currentState.listOfQuestions;

  //     for (var question in questions) {
  //       final index = questions.indexOf(question);
  //       final uploadData = currentState.listOfUploads[index];
  //       final isMcq = question.questionType == "MCQ";

  //       final isSelectedInValid = question.invalidAnswers == uploadData.answer;
  //       final isInValidHaveOptions = question.invalidOptions.isNotEmpty;
  //       final isValidHaveOptions = question.validOptions.isNotEmpty;
  //       switch (isMcq) {
  //         case true:
  //           {
  //             if (uploadData.answer != null) {
  //               // ---------------------------------SELECTED INVALID  --------------
  //               if (isSelectedInValid) {
  //                 if (isInValidHaveOptions) {
  //                   if (uploadData.invalidOption != null) {
  //                     checkCommentAndImage(index, question, uploadData, true);
  //                   } else {
  //                     // show Error Message : Select atleast on option
  //                     // Completed
  //                     _showMessage('Select atleast one option!');
  //                   }
  //                 } else {
  //                   checkCommentAndImage(index, question, uploadData, true);
  //                 }
  //                 //------------------------< SELECTED VALID  >--------------------------------------------------
  //               } else {
  //                 if (isValidHaveOptions) {
  //                   if (uploadData.validOption != null) {
  //                     checkCommentAndImage(index, question, uploadData, false);
  //                   } else {
  //                     // show Error Message : Select atleast on option
  //                     //Completed
  //                     _showMessage("Select atleast one option");
  //                   }
  //                 } else {
  //                   checkCommentAndImage(index, question, uploadData, false);
  //                 }
  //               }
  //             } else {
  //               //---show Error : Select the Main Option
  //               _showMessage("Please choose the answer");
  //               // Completed
  //             }
  //           }
  //         case false:
  //           {
  //             if (descriptiveKey.currentState!.validate()) {
  //               Functions.onFillDescriptiveAnswer(
  //                 context,
  //                 index,
  //                 descriptiveController.text,
  //               );
  //               checkCommentAndImage(index, question, uploadData, false);
  //             }
  //           }
  //       }
  //     }
  //   }
  // }

  void checkCommentAndImage(
    int index,
    QuestionModelData question,
    UploadInspectionModel uploadData,
    bool isCommentMandotory,
  ) async {
    try {
      final commentKey = helperVariable["commentKey"] as GlobalKey<FormState>;
      final commentController =
          helperVariable['commentController'] as TextEditingController;
      final listOFImages = helperVariable['listOfImages'] as List<Uint8List?>;
      bool? isImageOptioanl;
      if (question.picture == 'Required Optional') {
        isImageOptioanl = true;
      } else if (question.picture == 'Required Mandatory') {
        isImageOptioanl = false;
      }

      if (isCommentMandotory) {
        if (commentKey.currentState!.validate()) {
          if (isImageOptioanl == null || isImageOptioanl == true) {
            await Functions.onAddComment(
              context,
              index,
              commentController.text,
            );
            await Functions.onAddImages(context, index, listOFImages);
            saveAnswer(index);
          } else {
            if (listOFImages.isEmpty) {
              // Error : Select atleast one image
              _showMessage("Select atlease one image");
            } else {
              await Functions.onAddComment(
                context,
                index,
                commentController.text,
              );
              await Functions.onAddImages(context, index, listOFImages);
              saveAnswer(index);
            }
          }
        }
      } else {
        if (isImageOptioanl == null || isImageOptioanl == true) {
          await Functions.onAddImages(context, index, listOFImages);
          await Functions.onAddComment(context, index, commentController.text);

          saveAnswer(index);

          // PROCEED
        } else {
          // Error : Select atleast one image
          if (listOFImages.isEmpty) {
            _showMessage("Select atlease one image");
          } else {
            await Functions.onAddImages(context, index, listOFImages);
            await Functions.onAddComment(
              context,
              index,
              commentController.text,
            );
            saveAnswer(index);
          }
        }
      }
    } catch (e) {
      log("Error - ${e}");
    }
  }

  void saveAnswer(int questionIndex) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final data = currentState.listOfUploads[questionIndex];
      // log(data.toJson().toString());
      await context.read<EvSubmitAnswerControllerCubit>().onSubmitAnswer(
        context,
        data,
        questionIndex,
      );
      _showMessage("Saved !");
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: AppStyle.style(context: context, color: AppColors.white),
        ),
      ),
    );
  }
}
