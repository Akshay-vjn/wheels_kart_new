import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/paint/dash_border.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/widget_answer_selection_button.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/functions.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/widget_build_check_box.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/question_model_data.dart';
import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';

class EvAnswerQuestionScreen extends StatefulWidget {
  final String portionId;
  final String systemId;
  final String portionName;
  final String systemName;
  final String inspectionId;

  const EvAnswerQuestionScreen(
      {super.key,
      required this.portionId,
      required this.systemId,
      required this.portionName,
      required this.systemName,
      required this.inspectionId});

  @override
  State<EvAnswerQuestionScreen> createState() => _EvAnswerQuestionScreenState();
}

class _EvAnswerQuestionScreenState extends State<EvAnswerQuestionScreen> {
  List<Map<String, dynamic>> helperVariables = [];

  @override
  void initState() {
    super.initState();
    context.read<FetchQuestionsBloc>().add(OnCallQuestinApiRepoEvent(
        inspectionId: widget.inspectionId,
        context: context,
        postionId: widget.portionId,
        systemId: widget.systemId));
  }

  bool initializeState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(
          context,
        ),
        title: Text(
          '${widget.portionName}/${widget.systemName}',
          style: AppStyle.style(
              context: context,
              color: AppColors.kWhite,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context)),
        ),
        backgroundColor: AppColors.DEFAULT_BLUE_DARK,
      ),
      body: BlocConsumer<FetchQuestionsBloc, FetchQuestionsState>(
        listener: (context, state) {
          if (state is SuccessFetchQuestionsState) {
            if (!initializeState) {
              initializeState = true;
              context
                  .read<SubmitAnswerControllerCubit>()
                  .init(state.listOfQuestions.length);
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
                return Scrollbar(
                  thickness: 8.0, // Adjust thickness
                  radius: Radius.circular(10), // Make it rounded
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Container(
                            height: 10,
                            color: AppColors.kBlack,
                          ),
                      itemBuilder: (context, index) {
                        final currentQuestion = state.listOfQuestions[index];
                        helperVariables.add({
                          "commentController": TextEditingController(),
                          "commentKey": GlobalKey<FormState>(),
                          "descriptiveController": TextEditingController(),
                          "descriptiveKey": GlobalKey<FormState>(),
                          "listOfImages": <File>[]
                        });
                        return _buildQuestionTile(currentQuestion, index);
                      },
                      itemCount: state.listOfQuestions.length),
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

  Widget _buildQuestionTile(QuestionModelData question, int index) {
    return BlocBuilder<SubmitAnswerControllerCubit,
        SubmitAnswerControllerState>(
      builder: (context, state) {
        final currentstate = state.questionState[index];
        final errorState = currentstate == SubmissionState.ERROR;
        final successState = currentstate == SubmissionState.SUCCESS;
        final loadingState = currentstate == SubmissionState.LOADING;
        final initialState = currentstate == SubmissionState.INITIAL;

        final buttonColor = initialState
            ? AppColors.DEFAULT_BLUE_DARK
            : successState
                ? AppColors.kGreen
                : errorState
                    ? AppColors.kRed
                    : AppColors.kGrey;

        final titleColor = initialState
            ? null
            : successState
                ? AppColors.kGreen.withOpacity(.1)
                : errorState
                    ? AppColors.kRed.withOpacity(.1)
                    : null;

        return Container(
          color: titleColor,
          padding: EdgeInsets.all(AppDimensions.paddingSize10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question,
                style: AppStyle.style(
                    size: AppDimensions.fontSize18(context),
                    context: context,
                    fontWeight: FontWeight.bold),
              ),
              AppSpacer(
                heightPortion: .02,
              ),
              if (question.questionType == "MCQ") ...[
                _buildSubQuestionViewForMcq(
                  index,
                ),
                _buildAnswerForMcq(index),
                _buildValidOptionView(index),
                _buildInValidOptionView(index)
              ],
              if (question.questionType == "Descriptive") ...[
                _buildDescriptiveQuestion(index)
              ],
              if (question.picture != "Not Required") ...[
                _takePictureView(
                    question.picture == "Required Optional" ? true : false,
                    index)
              ],
              _commentBoxView(index),
              Align(
                  alignment: Alignment.centerRight,
                  child: successState
                      ? Icon(
                          Icons.cloud_done_outlined,
                          size: 35,
                          color: AppColors.kGreen,
                        )
                      : loadingState
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor),
                              onPressed: () {
                                if (currentstate != SubmissionState.LOADING) {
                                  onSubmitQuestion(context, index);
                                }
                              },
                              child: Text(
                                errorState ? "Failed" : "Save",
                                style: AppStyle.style(
                                    context: context, color: AppColors.kWhite),
                              )))
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubQuestionViewForMcq(
    int questionIndex,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final subQuestions = question.subQuestionOptions;
      return Visibility(
          visible: question.subQuestionOptions.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSize5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.subQuestionTitle ?? '',
                  style: AppStyle.style(
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: AppDimensions.fontSize17(context)),
                ),
                AppSpacer(
                  heightPortion: .01,
                ),
                Row(
                    children: subQuestions
                        .asMap()
                        .entries
                        .map(
                          (e) => BuildAnswerSelectionButton(
                              isOutlined: true,
                              isSelected: (currentIndexVariables
                                          .subQuestionAnswer !=
                                      null) &&
                                  (currentIndexVariables.subQuestionAnswer ==
                                      e.value),
                              title: e.value,
                              activeColor: AppColors.DEFAULT_BLUE_DARK,
                              inActiveColor: AppColors.kGrey.withOpacity(.4),
                              onTap: () => Functions.onSelectSubQuestion(
                                  context, questionIndex, e.value)),
                        )
                        .toList()),
              ],
            ),
          ));
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
        padding:
            const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
        child: Row(
            children: answers
                .asMap()
                .entries
                .map(
                  (e) => BuildAnswerSelectionButton(
                      isSelected: (currentIndexVariables.answer != null) &&
                          (currentIndexVariables.answer == e.value),
                      title: e.value,
                      activeColor: AppColors.kBlack,
                      inActiveColor: AppColors.kWhite,
                      onTap: () => Functions.onSelectAnswertion(
                          context, questionIndex, e.value)),
                )
                .toList()),
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

      return Visibility(
          visible: (currentIndexVariables.answer != null) &&
              (currentIndexVariables.answer == question.answers.first &&
                  question.validOptions.isNotEmpty),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSize5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer(
                  heightPortion: .01,
                ),
                Text(
                  question.validOptionsTitle.isNotEmpty
                      ? question.validOptionsTitle
                      : 'Please choose the option',
                  style: AppStyle.style(
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: AppDimensions.fontSize17(context)),
                ),
                AppSpacer(
                  heightPortion: .01,
                ),
                Column(
                  children: validOptions
                      .asMap()
                      .entries
                      .map((e) => BuildCheckBox(
                            isSelected:
                                currentIndexVariables.validOption == null
                                    ? false
                                    : currentIndexVariables.validOption!
                                        .contains(e.value),
                            title: e.value,
                            onChanged: (p0) {
                              Functions.onSelectValidOption(
                                  context, questionIndex, e.value);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ));
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
      return Visibility(
          visible: (currentIndexVariables.answer != null) &&
              currentIndexVariables.answer == question.invalidAnswers,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSize5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer(
                  heightPortion: .01,
                ),
                Text(
                  question.validOptionsTitle.isNotEmpty
                      ? question.invalidOptionsTitle
                      : 'Please choose the option',
                  style: AppStyle.style(
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: AppDimensions.fontSize17(context)),
                ),
                AppSpacer(
                  heightPortion: .01,
                ),
                Column(
                  children: inValidOptions
                      .asMap()
                      .entries
                      .map((e) => BuildCheckBox(
                            isSelected:
                                currentIndexVariables.invalidOption == null
                                    ? false
                                    : currentIndexVariables.invalidOption!
                                        .contains(e.value),
                            title: e.value,
                            onChanged: (p0) {
                              Functions.onSelectInValidOption(
                                  context, questionIndex, e.value);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ));
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
        key: helperVariables[questionIndex]["commentKey"],
        child: Column(
          children: [
            AppSpacer(
              heightPortion: .02,
            ),
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
                            size: AppDimensions.fontSize17(context)),
                        children: [
                      TextSpan(
                          text: commentTitle.isNotEmpty ||
                                  invalidAnswer == selectedMainOption
                              ? " * "
                              : "",
                          style: AppStyle.style(
                              context: context, color: AppColors.kRed))
                    ])),
                Flexible(
                    child: Divider(
                  thickness: .2,
                  endIndent: 10,
                  indent: 10,
                )),
              ],
            ),
            EvAppCustomTextfield(
                onChanged: (p0) {
                  final state =
                      BlocProvider.of<FetchQuestionsBloc>(context).state;
                  if (state is SuccessFetchQuestionsState) {
                    context
                        .read<SubmitAnswerControllerCubit>()
                        .resetState(questionIndex);
                  }
                },
                focusColor: AppColors.kBlack,
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
                controller: helperVariables[questionIndex]["commentController"],
                hintText: commentTitle.isEmpty
                    ? 'Enter the comment in any...'
                    : commentTitle),
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
        key: helperVariables[questionIndex]["descriptiveKey"],
        child: Column(
          children: [
            EvAppCustomTextfield(
              onChanged: (p0) {
                final state =
                    BlocProvider.of<FetchQuestionsBloc>(context).state;
                if (state is SuccessFetchQuestionsState) {
                  context
                      .read<SubmitAnswerControllerCubit>()
                      .resetState(questionIndex);
                }
              },
              focusColor: AppColors.kBlack,
              fontWeght: FontWeight.w500,
              keyBoardType: getKeyboardType(question.keyboardType),
              controller: helperVariables[questionIndex]
                  ['descriptiveController'],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This filed is required';
                } else {
                  return null;
                }
              },
              hintText: 'Enter the value here',
            )
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
      final listOfImages =
          helperVariables[questionIndex]["listOfImages"] as List;
      return Column(
        children: [
          AppSpacer(
            heightPortion: .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: 'Upload Pictures',
                      style: AppStyle.style(
                          context: context,
                          fontWeight: FontWeight.w600,
                          size: AppDimensions.fontSize17(context)),
                      children: [
                    TextSpan(
                        text: isOptional ? "" : " * ",
                        style: AppStyle.style(
                            context: context, color: AppColors.kRed))
                  ])),
              Flexible(
                  child: Divider(
                thickness: .2,
                endIndent: 10,
                indent: 10,
              )),
            ],
          ),
          AppSpacer(
            heightPortion: .02,
          ),
          SizedBox(
            width: w(context),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
              shrinkWrap: true,
              itemCount: listOfImages.length + 1,
              itemBuilder: (context, index) {
                if (index == listOfImages.length) {
                  return InkWell(
                    onTap: () {
                      _openCamera(questionIndex);
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 70,
                            color: AppColors.kGrey,
                          ),
                          AppSpacer(
                            heightPortion: .01,
                          ),
                          Text(
                            listOfImages.isNotEmpty
                                ? 'Add More'
                                : 'Add Picture',
                            style: AppStyle.style(
                                context: context,
                                color: AppColors.kGrey,
                                fontWeight: FontWeight.bold,
                                size: AppDimensions.fontSize12(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  width: w(context) * .23,
                  height: h(context) * .1,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kGrey),
                      // borderRadius:
                      //     BorderRadius.circular(AppDimensions.radiusSize10),
                      color: AppColors.kWhite,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(listOfImages[index]))),
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
      final listOfImages = helperVariables[questionIndex]["listOfImages"];
      final imagepicker = ImagePicker();
      final pickedXfile =
          await imagepicker.pickImage(source: ImageSource.camera);
      if (pickedXfile != null) {
        setState(() {
          listOfImages.add(File(pickedXfile.path));
        });
      }
    }
  }

  void onSubmitQuestion(
    BuildContext context,
    int index,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    final descriptiveKey =
        helperVariables[index]['descriptiveKey'] as GlobalKey<FormState>;

    final descriptiveController = helperVariables[index]
        ['descriptiveController'] as TextEditingController;

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
                  context, index, descriptiveController.text);
              checkCommentAndImage(index, question, uploadData, false);
            }
          }
      }
    }
  }

  void checkCommentAndImage(int index, QuestionModelData question,
      UploadInspectionModel uploadData, bool isCommentMandotory) async {
    final commentKey =
        helperVariables[index]["commentKey"] as GlobalKey<FormState>;
    final commentController =
        helperVariables[index]['commentController'] as TextEditingController;
    final listOFImages = helperVariables[index]['listOfImages'] as List<File>;
    bool? isImageOptioanl;
    if (question.picture == 'Required Optional') {
      isImageOptioanl = true;
    } else if (question.picture == 'Required Mandatory') {
      isImageOptioanl = false;
    }

    if (isCommentMandotory) {
      if (commentKey.currentState!.validate()) {
        if (isImageOptioanl == null || isImageOptioanl == true) {
          await Functions.onAddComment(context, index, commentController.text);
          await Functions.onAddImages(context, index, listOFImages);
          saveAnswer(index);
        } else {
          if (listOFImages.isEmpty) {
            // Error : Select atleast one image
            _showMessage("Select atlease one image");
          } else {
            await Functions.onAddComment(
                context, index, commentController.text);
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
          await Functions.onAddComment(context, index, commentController.text);
          saveAnswer(index);
        }
      }
    }
  }

  void saveAnswer(int questionIndex) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final data = currentState.listOfUploads[questionIndex];
      // log(data.toJson().toString());
      await context
          .read<SubmitAnswerControllerCubit>()
          .onSubmitAnswer(context, data, questionIndex);
      _showMessage("Saved !");
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: AppStyle.style(context: context, color: AppColors.kWhite),
        )));
  }
}
