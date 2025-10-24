import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/camera_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:image/image.dart' as img;

import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/functions.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/widget_build_check_box.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/e_answer_question_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_textfield.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_prefill_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/question_model_data.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/upload_inspection_model.dart';

class BuildQuestionTile extends StatefulWidget {
  final QuestionModelData question;
  final InspectionPrefillModel? prefillModel;
  final int index;
  final ScrollController? scrollController;

  const BuildQuestionTile({
    super.key,
    required this.question,
    this.prefillModel,
    required this.index,
    this.scrollController,
  });

  @override
  State<BuildQuestionTile> createState() => _BuildQuestionTileState();
}

class _BuildQuestionTileState extends State<BuildQuestionTile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, dynamic> helperVariable = {
    "commentController": TextEditingController(),
    "commentKey": GlobalKey<FormState>(),
    "descriptiveController": TextEditingController(),
    "descriptiveKey": GlobalKey<FormState>(),
    "listOfImages": <Uint8List>[],
  };

  bool isLoadingImage = true;
  bool _isExpanded = true;
  bool _isCapturingImage = false;
  double? _pendingScrollPosition;
  FocusNode? _addPictureFocusNode;
  bool _disableTextFields = false;

  @override
  bool get wantKeepAlive => true;

  ScrollController? _getScrollController() {
    // Use the passed scroll controller or try to find one
    return widget.scrollController ?? _findScrollController();
  }

  ScrollController? _findScrollController() {
    // Find scroll controller by looking up the widget tree
    ScrollController? scrollController;
    context.visitAncestorElements((element) {
      if (element.widget is SingleChildScrollView) {
        final scrollView = element.widget as SingleChildScrollView;
        if (scrollView.controller != null) {
          scrollController = scrollView.controller;
          return false; // Stop searching
        }
      }
      return true; // Continue searching
    });
    return scrollController;
  }

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Initialize focus node for add picture button
    _addPictureFocusNode = FocusNode();

    if (widget.prefillModel != null) {
      _initializePrefillData();
    } else {
      isLoadingImage = false;
    }
  }

  @override
  void didUpdateWidget(BuildQuestionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If we were capturing an image and the widget just rebuilt due to BLoC state change,
    // restore the scroll position and focus on add picture button
    if (_isCapturingImage && _pendingScrollPosition != null) {
      print("🔄 Widget updated during image capture, restoring scroll position");
      
      final scrollController = _getScrollController();
      if (scrollController != null) {
        // Use a longer delay to ensure text field focus changes are complete
        Future.delayed(const Duration(milliseconds: 300), () {
          _restoreScrollPosition(scrollController, _pendingScrollPosition);
          // Focus on add picture button after scroll restoration
          _addPictureFocusNode?.requestFocus();
        });
      }
    }
  }

  /// Focus on add picture button when returning from camera
  void _focusOnAddPictureButton() {
    print("📸 Focusing on add picture button");
    _addPictureFocusNode?.requestFocus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _addPictureFocusNode?.dispose();
    helperVariable['commentController']?.dispose();
    helperVariable['descriptiveController']?.dispose();
    super.dispose();
  }

  Future<void> _initializePrefillData() async {
    Functions.onPrefillTheQuestion(context, widget.index, widget.prefillModel!);
    if (widget.question.questionType == "Descriptive") {
      helperVariable['descriptiveController'].text =
          widget.prefillModel!.answer;
    }
    if (widget.prefillModel!.comment != null) {
      helperVariable['commentController'].text = widget.prefillModel!.comment;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrefillImages());
  }

  Future<void> _loadPrefillImages() async {
    try {
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
      }
      setState(() {
        isLoadingImage = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocBuilder<
            EvSubmitAnswerControllerCubit,
            EvSubmitAnswerControllerState
        >(builder: (context, state) => _buildQuestionCard(state)),
      ),
    );
  }

  Widget _buildQuestionCard(EvSubmitAnswerControllerState state) {
    final currentstate = state.questionState[widget.index];
    final isCompleted = currentstate == SubmissionState.SUCCESS;
    final hasError = currentstate == SubmissionState.ERROR;
    final isLoading = currentstate == SubmissionState.LOADING;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSize10,
        vertical: AppDimensions.paddingSize10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: _getBorderColor(currentstate), width: 1.5),
      ),
      child: Column(
        children: [
          _buildQuestionHeader(currentstate),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(AppDimensions.paddingSize15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionContent(),
                if (_isExpanded || isCompleted || hasError) ...[
                  // AppSpacer(heightPortion: .02),
                  _buildActionButton(currentstate, isLoading),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(SubmissionState currentstate) {
    final isCompleted = currentstate == SubmissionState.SUCCESS;
    final hasError = currentstate == SubmissionState.ERROR;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingSize10),
        decoration: BoxDecoration(
          border: Border.all(color: _getBorderColor(currentstate), width: 1.5),
          color: _getHeaderColor(currentstate),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusSize18 - 2),
            topRight: Radius.circular(AppDimensions.radiusSize18 - 2),
          ),
        ),
        child: Row(
          children: [
            // Question number badge
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: EvAppStyle.style(
                    context: context,
                    fontWeight: FontWeight.bold,
                    size: AppDimensions.fontSize13(context),
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingSize10),

            // Question title and type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.question,
                    style: EvAppStyle.style(
                      size: AppDimensions.fontSize16(context),
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 8,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Text(
                  //     widget.question.questionType,
                  //     style: EvAppStyle.style(
                  //       context: context,
                  //       size: AppDimensions.fontSize12(context),
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Status icon and expand button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCompleted)
                  Icon(Icons.check_circle, color: Colors.white, size: 20)
                else if (hasError)
                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 5),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child:
      _isExpanded
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            _buildImageSection(),
          ],
          _commentBoxView(widget.index),
        ],
      )
          : const SizedBox.shrink(),
    );
  }

  Color _getBorderColor(SubmissionState state) {
    switch (state) {
      case SubmissionState.SUCCESS:
        return EvAppColors.kGreen;
      case SubmissionState.ERROR:
        return EvAppColors.kRed;
      case SubmissionState.LOADING:
        return EvAppColors.DEFAULT_BLUE_DARK;
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color _getHeaderColor(SubmissionState state) {
    switch (state) {
      case SubmissionState.SUCCESS:
        return EvAppColors.kGreen;
      case SubmissionState.ERROR:
        return EvAppColors.kRed;
      case SubmissionState.LOADING:
        return EvAppColors.DEFAULT_BLUE_DARK;
      default:
        return EvAppColors.DEFAULT_BLUE_DARK;
    }
  }

  Widget _buildSubQuestionViewForMcq(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final subQuestions = question.subQuestionOptions;

      return Visibility(
        visible: question.subQuestionOptions.isNotEmpty,
        child: _buildSection(
          title: question.subQuestionTitle ?? '',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
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
                  return _buildChipButton(
                    title: e.value,
                    isSelected:
                    (currentIndexVariables.subQuestionAnswer !=
                        null) &&
                        (currentIndexVariables.subQuestionAnswer ==
                            e.value),
                    onTap: () {
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
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildAnswerForMcq(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final answers = question.answers;

      return _buildSection(
        title: 'Select Answer',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
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
                return _buildChipButton(
                  title: e.value,
                  isSelected:
                  currentIndexVariables.answer != null &&
                      currentIndexVariables.answer == e.value,
                  onTap: () {
                    Functions.onSelectAnswertion(
                      context,
                      questionIndex,
                      e.value,
                    );
                  },
                  isPrimary: true,
                );
              },
            ),
          )
              .toList(),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildValidOptionView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final validOptions = question.validOptions;

      return Visibility(
        visible:
        (currentIndexVariables.answer != null) &&
            (currentIndexVariables.answer == question.answers.first &&
                question.validOptions.isNotEmpty),
        child: _buildSection(
          title:
          question.validOptionsTitle.isNotEmpty
              ? question.validOptionsTitle
              : 'Please select the option',
          child: Column(
            children:
            validOptions
                .asMap()
                .entries
                .map(
                  (e) => BuildCheckBox(
                isSelected:
                currentIndexVariables.validOption == null
                    ? false
                    : currentIndexVariables.validOption!.contains(
                  e.value,
                ),
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
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildInValidOptionView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final currentIndexVariables = currentState.listOfUploads[questionIndex];
      final inValidOptions = question.invalidOptions;

      return Visibility(
        visible:
        ((currentIndexVariables.answer != null) &&
            (currentIndexVariables.answer == question.invalidAnswers)) &&
            inValidOptions.isNotEmpty,
        child: _buildSection(
          title:
          question.invalidOptionsTitle.isNotEmpty
              ? question.invalidOptionsTitle
              : 'Please select the option',
          child: Column(
            children:
            inValidOptions
                .asMap()
                .entries
                .map(
                  (e) => BuildCheckBox(
                isSelected:
                currentIndexVariables.invalidOption == null
                    ? false
                    : currentIndexVariables.invalidOption!.contains(
                  e.value,
                ),
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
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildDescriptiveQuestion(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];

      return _buildSection(
        title: 'Your Answer',
        child: Form(
          key: helperVariable["descriptiveKey"],
          child: EvAppCustomTextfield(
            onChanged: (p0) {
              final state = BlocProvider.of<FetchQuestionsBloc>(context).state;
              if (state is SuccessFetchQuestionsState) {
                context.read<EvSubmitAnswerControllerCubit>().resetState(
                  questionIndex,
                );
              }
            },
            focusColor: EvAppColors.DEFAULT_BLUE_DARK,
            fontWeght: FontWeight.w500,
            keyBoardType: getKeyboardType(question.keyboardType),
            controller: helperVariable['descriptiveController'],
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            hintText: 'Enter the value here',
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _commentBoxView(int questionIndex) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      final question = currentState.listOfQuestions[questionIndex];
      final commentTitle = question.commentsTitle;
      final invalidAnswer = question.invalidAnswers;
      final selectedMainOption =
          currentState.listOfUploads[questionIndex].answer;

      return _buildSection(
        title: commentTitle.isEmpty ? 'Comment' : commentTitle,
        isRequired: false,
        // commentTitle.isNotEmpty || invalidAnswer == selectedMainOption,
        child: Form(
          key: helperVariable["commentKey"],
          child: EvAppCustomTextfield(
            onChanged: (p0) {
              final state = BlocProvider.of<FetchQuestionsBloc>(context).state;
              if (state is SuccessFetchQuestionsState) {
                context.read<EvSubmitAnswerControllerCubit>().resetState(
                  questionIndex,
                );
              }
            },
            focusColor: EvAppColors.DEFAULT_BLUE_DARK,
            fontWeght: FontWeight.normal,
            maxLine: 1,
            validator: (value) {
              // if (invalidAnswer == selectedMainOption) {
              //   if (value!.isEmpty) {
              //     return 'Enter the comment';
              //   }
              // }

              return null;
            },
            controller: helperVariable["commentController"],
            hintText:
            commentTitle.isEmpty
                ? 'Enter the comment in any...'
                : commentTitle,
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildImageSection() {
    return Builder(
      builder: (context) {
        final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
        if (currentState is SuccessFetchQuestionsState) {
          final question = currentState.listOfQuestions[widget.index];
          final uploadData = currentState.listOfUploads[widget.index];
          final isSelectedInValid =
              question.invalidAnswers == uploadData.answer;
          bool isDescriptiveQuestion = question.questionType == "Descriptive";

          // bool isOptional =
          //     isDescriptiveQuestion
          //         ? question.picture == "Required Optional"
          //         : !isSelectedInValid
          //         ? true
          //         : question.picture == "Required Optional";

          bool isOptional = false;

          if (isDescriptiveQuestion) {
            if (question.picture == 'Required Optional') {
              isOptional = true;
            } else if (question.picture == 'Required Mandatory') {
              isOptional = false;
            }
          } else {
            if (question.picture == 'Required Mandatory') {
              isOptional = false;
            } else if (question.picture == 'Required Optional') {
              if (isSelectedInValid) {
                isOptional = false; // NOT OK: Images mandatory
              } else {
                isOptional = true;  // OK: Images optional (as before)
              }
            }
          }

          return _takePictureView(isOptional, widget.index);
        }
        return const SizedBox();
      },
    );
  }

  Widget _takePictureView(bool isOptional, int questionIndex) {
    final listOfImages = helperVariable["listOfImages"] as List;

    return _buildSection(
      title: 'Upload Pictures',
      isRequired: !isOptional,
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            shrinkWrap: true,
            itemCount:
            isLoadingImage
                ? listOfImages.length + 2
                : listOfImages.length + 1,
            itemBuilder: (context, index) {
              if (isLoadingImage && index == 0) {
                return _buildImageLoadingPlaceholder();
              }
              if (index ==
                  (isLoadingImage
                      ? listOfImages.length + 1
                      : listOfImages.length)) {
                return _buildAddImageButton(
                  questionIndex,
                  listOfImages.isNotEmpty,
                );
              }
              final imageIndex = isLoadingImage ? index - 1 : index;
              return _buildImagePreview(
                listOfImages,
                imageIndex,
                questionIndex,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Center(child: EVAppLoadingIndicator()),
    );
  }

  Widget _buildAddImageButton(int questionIndex, bool hasImages) {
    return Focus(
      focusNode: _addPictureFocusNode,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          print("📸 Add picture button focused");
        }
      },
      child: InkWell(
        onTap: () => _openCamera(questionIndex),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _addPictureFocusNode?.hasFocus == true
                  ? EvAppColors.DEFAULT_BLUE_DARK
                  : EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
              width: _addPictureFocusNode?.hasFocus == true ? 3 : 2,
              style: BorderStyle.solid,
            ),
            color: _addPictureFocusNode?.hasFocus == true
                ? EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1)
                : EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                size: 32,
                color: EvAppColors.DEFAULT_BLUE_DARK,
              ),
              const SizedBox(height: 8),
              Text(
                hasImages ? 'Add More' : 'Add Picture',
                style: EvAppStyle.style(
                  context: context,
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize12(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(
      List listOfImages,
      int imageIndex,
      int questionIndex,
      ) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: EvAppColors.black,
                    image: DecorationImage(
                      image: MemoryImage(listOfImages[imageIndex]),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white,
              image:
              listOfImages[imageIndex] == null
                  ? null
                  : DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(listOfImages[imageIndex]),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // Use a more stable state update to prevent scroll jumping
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  listOfImages.removeAt(imageIndex);
                });
                Functions.resetButtonStatus(context, questionIndex);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: EvAppStyle.style(
                context: context,
                fontWeight: FontWeight.w600,
                size: AppDimensions.fontSize16(context),
                color: Colors.black87,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: " *",
                    style: EvAppStyle.style(
                      context: context,
                      color: EvAppColors.kRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildChipButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
            isSelected
                ? (isPrimary
                ? EvAppColors.DEFAULT_BLUE_DARK
                : EvAppColors.kGreen)
                : Colors.transparent,
            border: Border.all(
              color:
              isSelected
                  ? (isPrimary
                  ? EvAppColors.DEFAULT_BLUE_DARK
                  : EvAppColors.kGreen)
                  : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Text(
            title,
            style: EvAppStyle.style(
              context: context,
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              size: AppDimensions.fontSize15(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(SubmissionState currentstate, bool isLoading) {
    final isCompleted = currentstate == SubmissionState.SUCCESS;
    final hasError = currentstate == SubmissionState.ERROR;

    if (isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: EvAppColors.kGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: EvAppColors.kGreen.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_done, color: EvAppColors.kGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              'Saved Successfully',
              style: EvAppStyle.style(
                context: context,
                color: EvAppColors.kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          hasError ? EvAppColors.kRed : EvAppColors.DEFAULT_BLUE_DARK,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        onPressed:
        isLoading
            ? null
            : () => onSubmitQuestionEachQuestion(context, widget.index),
        child:
        isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          hasError ? "Retry" : "Save Answer",
          style: EvAppStyle.style(
            context: context,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
                    showSnakBar(
                      context,
                      'Select atleast one option.',
                      isError: true,
                    );
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
                    showSnakBar(
                      context,
                      "Select atleast one option.",
                      isError: true,
                    );
                  }
                } else {
                  checkCommentAndImage(index, question, uploadData, false);
                }
              }
            } else {
              //---show Error : Select the Main Option
              showSnakBar(context, "Please select the answer", isError: true);
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

  void _restoreScrollPosition(ScrollController? scrollController, double? savedPosition) {
    if (scrollController != null && savedPosition != null) {
      print("🔄 Restoring scroll position: $savedPosition");
      
      // Try multiple times to ensure scroll restoration works after BLoC rebuild
      _attemptScrollRestoration(scrollController, savedPosition, 0);
    } else {
      print("❌ Scroll controller or saved position is null");
      // Try to restore using global position as backup
      if (scrollController != null) {
        _restoreScrollPositionWithGlobalBackup(scrollController);
      }
    }
  }

  void _attemptScrollRestoration(ScrollController scrollController, double targetPosition, int attempt) {
    const maxAttempts = 8; // Increased attempts
    const delayMs = 300; // Increased delay
    
    if (attempt >= maxAttempts) {
      print("❌ Max scroll restoration attempts reached, using global backup");
      _restoreScrollPositionWithGlobalBackup(scrollController);
      return;
    }
    
    print("🔄 Scroll restoration attempt ${attempt + 1}/$maxAttempts");
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && mounted) {
        final currentPosition = scrollController.offset;
        print("📊 Current position: $currentPosition, Target: $targetPosition");
        
        if ((currentPosition - targetPosition).abs() > 10) {
          print("✅ Animating to position: $targetPosition");
          scrollController.animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          
          // Check if restoration was successful after animation
          Future.delayed(const Duration(milliseconds: 500), () {
            if (scrollController.hasClients && mounted) {
              final newPosition = scrollController.offset;
              print("📊 Post-animation position: $newPosition, Target: $targetPosition");
              
              if ((newPosition - targetPosition).abs() > 10) {
                print("🔄 Scroll restoration not successful, retrying...");
                _attemptScrollRestoration(scrollController, targetPosition, attempt + 1);
              } else {
                print("✅ Scroll restoration successful");
              }
            }
          });
        } else {
          print("✅ Scroll position already correct");
        }
      } else {
        print("❌ Scroll controller not available, retrying...");
        Future.delayed(Duration(milliseconds: delayMs), () {
          _attemptScrollRestoration(scrollController, targetPosition, attempt + 1);
        });
      }
    });
  }

  void _restoreScrollPositionWithGlobalBackup(ScrollController scrollController) {
    final globalPosition = ScrollPositionManager.getCurrentScrollPosition();
    if (globalPosition > 0) {
      print("🔄 Using global position as backup: $globalPosition");
      // Use a small delay to ensure the widget is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients && mounted) {
          scrollController.animateTo(
            globalPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _openCamera(int questionIndex) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;

    if (currentState is SuccessFetchQuestionsState) {
      // Set flags to track image capture operation
      setState(() {
        _isCapturingImage = true;
      });
      
      // Save current scroll position before opening camera
      final scrollController = _getScrollController();
      double? savedPosition;
      if (scrollController != null) {
        savedPosition = scrollController.offset;
        _pendingScrollPosition = savedPosition;
        print("📸 Saved scroll position: $savedPosition");
        // Also save to global position tracker
        ScrollPositionManager.setScrollPosition(savedPosition);
      }

      Navigator.of(context).push(
        AppRoutes.createRoute(
          CameraScreen(
            onImageCaptured: (file) async {
              print("📷 Image captured callback triggered");
              final listOfImages = helperVariable["listOfImages"];

              try {
                final bytes = await file.readAsBytes();
                print("📷 Image bytes read: ${bytes.length} bytes");

                img.Image? image = img.decodeImage(bytes);
                if (image == null) {
                  print("❌ Failed to decode image");
                  throw Exception("Unable to decode image");
                }
                print("📷 Image decoded: ${image.width}x${image.height}");

                if (image.width > 800) {
                  image = img.copyResize(image, width: 800);
                  print("📷 Image resized to 800px width");
                }
                final compressed = img.encodeJpg(image, quality: 80);
                print("📷 Image compressed: ${compressed.length} bytes");

                // Add image to list first
                setState(() {
                  listOfImages.add(compressed);
                });
                print("📷 Image added to list, total images: ${listOfImages.length}");

                // Reset button status (this triggers BLoC state change)
                Functions.resetButtonStatus(context, questionIndex);
                print("📷 Button status reset");

                // Clear image capture flag
                setState(() {
                  _isCapturingImage = false;
                });

                // Restore scroll position and focus on add picture button AFTER BLoC state change completes
                Future.delayed(const Duration(milliseconds: 400), () {
                  _restoreScrollPosition(scrollController, savedPosition);
                  
                  // Focus on add picture button after scroll restoration
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _focusOnAddPictureButton();
                  });
                });
              } catch (e) {
                print("❌ Error in image processing: $e");
              }
            },
          ),
        ),
      );
      //  final listOfImages = helperVariable["listOfImages"];
      // final imagepicker = ImagePicker();
      // final pickedXfile = await imagepicker.pickImage(
      //   source: ImageSource.camera,
      //   preferredCameraDevice: CameraDevice.rear,
      // );
      // if (pickedXfile != null) {
      //   final bytes = await pickedXfile.readAsBytes();
      //   //--
      //   img.Image? image = img.decodeImage(bytes);
      //   if (image == null) {
      //     throw Exception("Unable to decode image");
      //   }
      //   if (image.width > 800) {
      //     image = img.copyResize(image, width: 800);
      //   }
      //   final compressed = img.encodeJpg(image, quality: 80);
      //   //---------------
      //   setState(() {
      //     listOfImages.add(compressed);
      //   });
      // Functions.resetButtonStatus(context, questionIndex);
      // }
    }
  }

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
      bool isDescriptiveQuestion = question.questionType == "Descriptive";
      bool isSelectedInValid = question.invalidAnswers == uploadData.answer;
      bool? isImageOptioanl;
      // if (isDescriptiveQuestion) {
      //   if (question.picture == 'Required Optional') {
      //     isImageOptioanl = true;
      //   } else if (question.picture == 'Required Mandatory') {
      //     isImageOptioanl = false;
      //   }
      // } else {
      //   if (!isSelectedInValid) {
      //     isImageOptioanl = true;
      //   } else {
      //     if (question.picture == 'Required Optional') {
      //       isImageOptioanl = true;
      //     } else if (question.picture == 'Required Mandatory') {
      //       isImageOptioanl = false;
      //     }
      //   }
      // }
      if (isDescriptiveQuestion) {
        if (question.picture == 'Required Optional') {
          isImageOptioanl = true;
        } else if (question.picture == 'Required Mandatory') {
          isImageOptioanl = false;
        }
      } else {
        if (question.picture == 'Required Mandatory') {
          isImageOptioanl = false;
        } else if (question.picture == 'Required Optional') {
          if (isSelectedInValid) {
            isImageOptioanl = false; // NOT OK: Images mandatory
          } else {
            isImageOptioanl = true;  // OK: Images optional (as before)
          }
        }
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
              showSnakBar(context, "Take atleast one picture", isError: true);
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
            showSnakBar(context, "Take atleast one picture", isError: true);
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
      // showSnakBar(context, "Saved !");
    }
  }

  // _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       showCloseIcon: true,
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(
  //         message,
  //         style: EvAppStyle.style(context: context, color: EvAppColors.white),
  //       ),
  //     ),
  //   );
  // }

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
}