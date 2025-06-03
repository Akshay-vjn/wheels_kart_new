// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:wheels_kart/core/components/app_custom_widgets.dart';
// import 'package:wheels_kart/core/components/app_empty_text.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/style.dart';

// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/helper/build_question_tile.dart';

// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspection%20prefilled/fetch_prefill_data_of_inspection_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';

// class EvAnswerQuestionScreen extends StatefulWidget {
//   final String portionId;
//   final String systemId;
//   final String portionName;
//   final String systemName;
//   final String inspectionId;

//   const EvAnswerQuestionScreen({
//     super.key,
//     required this.portionId,
//     required this.systemId,
//     required this.portionName,
//     required this.systemName,
//     required this.inspectionId,
//   });

//   @override
//   State<EvAnswerQuestionScreen> createState() => _EvAnswerQuestionScreenState();
// }

// class _EvAnswerQuestionScreenState extends State<EvAnswerQuestionScreen> {
//   List<Map<String, dynamic>> helperVariables = [];

//   @override
//   void initState() {
//     super.initState();
//     context.read<FetchQuestionsBloc>().add(
//       OnCallQuestinApiRepoEvent(
//         inspectionId: widget.inspectionId,
//         context: context,
//         portionId: widget.portionId,
//         systemId: widget.systemId,
//       ),
//     );
//     context.read<EvFetchPrefillDataOfInspectionBloc>().add(
//       OnFetchTheDataForPreFill(
//         inspectionId: widget.inspectionId,
//         context: context,
//         portionId: widget.portionId,
//         systemId: widget.systemId,
//       ),
//     );

//     log("portion id ${widget.portionId}");
//     log("inspection Id ${widget.inspectionId}");
//     log("system id ${widget.systemId}");
//   }

//   bool initializeState = false;

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   bool calledBackFunction = false;
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: customBackButton(
//             context,
//             onPressed: () {
//               if (!calledBackFunction) {
//                 calledBackFunction = true;
//                 context.read<FetchInspectionsBloc>().add(
//                   OnGetInspectionList(
//                     context: context,
//                     inspetionListType: 'ASSIGNED',
//                   ),
//                 );
//               }

//               Navigator.of(context).pop();
//             },
//           ),
//           title: Text(
//             '${widget.portionName}/${widget.systemName}',
//             style: AppStyle.style(
//               context: context,
//               color: AppColors.white,
//               fontWeight: FontWeight.bold,
//               size: AppDimensions.fontSize18(context),
//             ),
//           ),
//           backgroundColor: AppColors.DEFAULT_BLUE_DARK,
//         ),
//         body: BlocConsumer<FetchQuestionsBloc, FetchQuestionsState>(
//           listener: (context, state) {
//             if (state is SuccessFetchQuestionsState) {
//               if (!initializeState) {
//                 initializeState = true;
//                 context.read<EvSubmitAnswerControllerCubit>().init(
//                   state.listOfQuestions.length,
//                 );
//               }
//             }
//           },
//           builder: (context, state) {
//             switch (state) {
//               case LoadingFetchQuestionsState():
//                 {
//                   return AppLoadingIndicator();
//                 }
//               case SuccessFetchQuestionsState():
//                 {
//                   return BlocBuilder<
//                     EvFetchPrefillDataOfInspectionBloc,
//                     EvFetchPrefillDataOfInspectionState
//                   >(
//                     builder: (context, prefillState) {
//                       switch (prefillState) {
//                         case EvFetchPrefillDataOfInspectionLoadingState():
//                           {
//                             return AppLoadingIndicator();
//                           }
//                         case EvFetchPrefillDataOfInspectionErrorState():
//                           {
//                             return AppEmptyText(
//                               text: "Error while fetching prefill data",
//                             );
//                           }
//                         case EvFetchPrefillDataOfInspectionSuccessState():
//                           {
//                             return Scrollbar(
//                               thickness: 8.0, // Adjust thickness
//                               radius: Radius.circular(10), // Make it rounded
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children:
//                                       state.listOfQuestions.asMap().entries.map(
//                                         (e) {
//                                           final index = e.key;
//                                           final currentQuestion =
//                                               state.listOfQuestions[index];

//                                           final prefills =
//                                               prefillState
//                                                   .prefillInspectionDatas
//                                                   .where(
//                                                     (element) =>
//                                                         element.questionId ==
//                                                         currentQuestion
//                                                             .questionId,
//                                                   )
//                                                   .toList();

//                                           return BuildQuestionTile(
//                                             question: currentQuestion,
//                                             prefillModel:
//                                                 prefills.isNotEmpty
//                                                     ? prefills.first
//                                                     : null,
//                                             index: index,
//                                           );
//                                         },
//                                       ).toList(),
//                                 ),
//                               ),
//                             );
//                           }
//                         default:
//                           {
//                             return SizedBox();
//                           }
//                       }
//                     },
//                   );
//                 }
//               case ErrorFetchQuestionsState():
//                 {
//                   return AppEmptyText(text: state.errorMessage);
//                 }
//               default:
//                 {
//                   return SizedBox();
//                 }
//             }
//           },
//         ),
//       ),
//     );
//   }

  
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/helper/build_question_tile.dart';

import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspection%20prefilled/fetch_prefill_data_of_inspection_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';

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

class _EvAnswerQuestionScreenState extends State<EvAnswerQuestionScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> helperVariables = [];
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool calledBackFunction = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize progress animation
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

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
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: EvAppColors.white,
        appBar: _buildEnhancedAppBar(),
        body: Column(
          children: [
            _buildProgressHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
        // floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      elevation: 0,
      leading: 
      evCustomBackButton(
          context,
          onPressed: () => _handleBackNavigation(),
        
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inspection',
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.white.withOpacity(0.8),
              size: AppDimensions.fontSize15(context),
            ),
          ),
          Text(
            '${widget.portionName}/${widget.systemName}',
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.white,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize16(context),
            ),
          ),
        ],
      ),
      backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              EvAppColors.DEFAULT_BLUE_DARK,
              EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return BlocBuilder<EvSubmitAnswerControllerCubit, EvSubmitAnswerControllerState>(
      builder: (context, state) {
        int completedQuestions = 0;
        int totalQuestions = state.questionState.length;
        
        for (var status in state.questionState) {
          if (status == SubmissionState.SUCCESS) {
            completedQuestions++;
          }
        }
        
        double progress = totalQuestions > 0 ? completedQuestions / totalQuestions : 0.0;
        
        return Container(
          padding: EdgeInsets.all(AppDimensions.paddingSize15),
          decoration: BoxDecoration(
            color: EvAppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: EvAppStyle.style(
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: AppDimensions.fontSize16(context),
                    ),
                  ),
                  Text(
                    '$completedQuestions/$totalQuestions completed',
                    style: EvAppStyle.style(
                      context: context,
                      color: EvAppColors.grey,
                      size: AppDimensions.fontSize15(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: progress * _progressAnimation.value,
                    backgroundColor: EvAppColors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? EvAppColors.kGreen : EvAppColors.DEFAULT_BLUE_DARK,
                    ),
                    minHeight: 6,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocConsumer<FetchQuestionsBloc, FetchQuestionsState>(
      listener: (context, state) {
        if (state is SuccessFetchQuestionsState) {
          if (!initializeState) {
            initializeState = true;
            context.read<EvSubmitAnswerControllerCubit>().init(
              state.listOfQuestions.length,
            );
            _progressController.forward();
          }
        }
      },
      builder: (context, state) {
        switch (state) {
          case LoadingFetchQuestionsState():
            return _buildLoadingState();
          case SuccessFetchQuestionsState():
            return _buildSuccessState(state);
          case ErrorFetchQuestionsState():
            return _buildErrorState(state.errorMessage);
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EVAppLoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading questions...',
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.grey,
              size: AppDimensions.fontSize16(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(SuccessFetchQuestionsState state) {
    return BlocBuilder<EvFetchPrefillDataOfInspectionBloc, EvFetchPrefillDataOfInspectionState>(
      builder: (context, prefillState) {
        switch (prefillState) {
          case EvFetchPrefillDataOfInspectionLoadingState():
            return _buildLoadingState();
          case EvFetchPrefillDataOfInspectionErrorState():
            return _buildErrorState("Error while fetching prefill data");
          case EvFetchPrefillDataOfInspectionSuccessState():
            return _buildQuestionsList(state, prefillState);
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget _buildQuestionsList(
    SuccessFetchQuestionsState state,
    EvFetchPrefillDataOfInspectionSuccessState prefillState,
  ) {
    return Scrollbar(
      thickness: 6.0,
      radius: Radius.circular(8),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSize15,
          vertical: AppDimensions.paddingSize10,
        ),
        child: Column(
          children: state.listOfQuestions.asMap().entries.map((e) {
            final index = e.key;
            final currentQuestion = state.listOfQuestions[index];

            final prefills = prefillState.prefillInspectionDatas
                .where((element) => element.questionId == currentQuestion.questionId)
                .toList();

            return Container(
              margin: EdgeInsets.only(bottom: AppDimensions.paddingSize15),
              child: BuildQuestionTile(
                question: currentQuestion,
                prefillModel: prefills.isNotEmpty ? prefills.first : null,
                index: index,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: EvAppColors.kRed.withOpacity(0.6),
          ),
          SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: EvAppStyle.style(
              context: context,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: EvAppStyle.style(
                context: context,
                color: EvAppColors.grey,
                size: AppDimensions.fontSize15(context),
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Retry logic
            },
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<EvSubmitAnswerControllerCubit, EvSubmitAnswerControllerState>(
      builder: (context, state) {
        int completedQuestions = 0;
        for (var status in state.questionState) {
          if (status == SubmissionState.SUCCESS) {
            completedQuestions++;
          }
        }
        
        bool allCompleted = completedQuestions == state.questionState.length && state.questionState.isNotEmpty;
        
        if (!allCompleted) return SizedBox();
        
        return FloatingActionButton.extended(
          onPressed: () {
            _showCompletionDialog();
          },
          backgroundColor: EvAppColors.kGreen,
          icon: Icon(Icons.check_circle, color: EvAppColors.white),
          label: Text(
            'Complete Inspection',
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _handleBackNavigation() {
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
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.celebration, color: EvAppColors.kGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'Inspection Complete!',
                style: EvAppStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize18(context),
                ),
              ),
            ],
          ),
          content: Text(
            'You have successfully completed all questions for this inspection. Would you like to proceed?',
            style: EvAppStyle.style(
              context: context,
              size: AppDimensions.fontSize15(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Review'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleBackNavigation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: EvAppColors.kGreen,
              ),
              child: Text(
                'Proceed',
                style: EvAppStyle.style(
                  context: context,
                  color: EvAppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
